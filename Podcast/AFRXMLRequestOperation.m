//
//  AFRaptureXMLRequestOperation.m
//  Podcast
//
//  Created by Mike Tran on 30/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "AFRXMLRequestOperation.h"

static dispatch_queue_t af_xml_request_operation_processing_queue;
static dispatch_queue_t xml_request_operation_processing_queue() {
    if (af_xml_request_operation_processing_queue == NULL) {
        af_xml_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.xml-request.processing", 0);
    }
    
    return af_xml_request_operation_processing_queue;
}


@interface AFRXMLRequestOperation()
@property (readwrite, nonatomic, strong) RXMLElement *responseXMLElement;
@property (readwrite, nonatomic, strong) NSError *XMLError;
@end

@implementation AFRXMLRequestOperation
@synthesize responseXMLElement = _responseXMLElement;
@synthesize XMLError = _XMLError;

+ (AFRXMLRequestOperation *)RXMLRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement))failure
{
    AFRXMLRequestOperation *requestOperation = [[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(AFRXMLRequestOperation *)operation responseXMLElement]);
        }
    }];
    
    return requestOperation;
}

- (RXMLElement *)responseXMLElement
{
    if (!_responseXMLElement && [self.responseData length] > 0 && [self isFinished]) {
        self.responseXMLElement = [RXMLElement elementFromXMLData:self.responseData];
    }
    
    return _responseXMLElement;
}

- (NSError *)error {
    if (_XMLError) {
        return _XMLError;
    } else {
        return [super error];
    }
}

#pragma mark - NSOperation

- (void)cancel {
    [super cancel];
}

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml", @"application/rss+xml", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"xml"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.completionBlock = ^ {
        if ([self isCancelled]) {
            return;
        }
        
        dispatch_async(xml_request_operation_processing_queue(), ^(void) {
            RXMLElement* XMLElement = self.responseXMLElement;
            
            if (self.error) {
                if (failure) {
                    dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                if (success) {
                    dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                        success(self, XMLElement);
                    });
                }
            }
        });
    };
#pragma clang diagnostic pop
}



@end
