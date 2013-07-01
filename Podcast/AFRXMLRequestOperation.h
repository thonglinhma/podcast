//
//  AFRaptureXMLRequestOperation.h
//  Podcast
//
//  Created by Mike Tran on 30/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

#import <Availability.h>

#import "RXMLElement.h"

@interface AFRXMLRequestOperation : AFHTTPRequestOperation
@property (readonly, nonatomic, strong) RXMLElement *responseXMLElement;

+ (AFRXMLRequestOperation *)RXMLRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement))success
                                                               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement))failure;
@end
