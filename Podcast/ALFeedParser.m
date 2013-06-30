//
//  ALFeedParser.m
//  Podcast
//
//  Created by Mike Tran on 29/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALFeedParser.h"

static dispatch_queue_t rssparser_success_callback_queue() {
    static dispatch_queue_t parser_success_callback_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser_success_callback_queue = dispatch_queue_create("rssparser.success_callback.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return parser_success_callback_queue;
}

@interface ALFeedParser()<NSXMLParserDelegate>
@end

@implementation ALFeedParser {
    ALFeedItem *_currentItem;
    NSMutableArray *_items;
    NSMutableString *_tmpString;
    void (^block)(NSArray *feedItems);
}

- (id)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure
{
    ALFeedParser *parser = [[ALFeedParser alloc] init];
    [parser parseRSSFeedForRequest:urlRequest success:success failure:failure];
}


- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure
{
    
    block = [success copy];
    
    AFXMLRequestOperation *operation = [ALFeedParser XMLParserRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        [XMLParser setDelegate:self];
        [XMLParser parse];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParse) {
        failure(error);
    }];
    
    [operation setSuccessCallbackQueue:rssparser_success_callback_queue()];
    
    [operation start];
}


#pragma mark - AFNetworking AFXMLRequestOperation acceptable Content-Type overwriting

+ (NSSet *)defaultAcceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml",@"application/rss+xml", nil];
}
+ (NSSet *)acceptableContentTypes {
    return [self defaultAcceptableContentTypes];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"item"]) {
        _currentItem = [[ALFeedItem alloc] init];
    }
    
    _tmpString = [[NSMutableString alloc] init];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [_items addObject:_currentItem];
    }
    if (_currentItem != nil && _tmpString != nil) {
        
        if ([elementName isEqualToString:@"title"]) {
            [_currentItem setTitle:_tmpString];
        }
        
        if ([elementName isEqualToString:@"description"]) {
            [_currentItem setItemDescription:_tmpString];
        }
        
        if ([elementName isEqualToString:@"content:encoded"]) {
            [_currentItem setContent:_tmpString];
        }
        
        if ([elementName isEqualToString:@"link"]) {
            [_currentItem setLink:[NSURL URLWithString:_tmpString]];
        }
        
        if ([elementName isEqualToString:@"comments"]) {
            [_currentItem setCommentsLink:[NSURL URLWithString:_tmpString]];
        }
        
        if ([elementName isEqualToString:@"wfw:commentRss"]) {
            [_currentItem setCommentsFeed:[NSURL URLWithString:_tmpString]];
        }
        
        if ([elementName isEqualToString:@"slash:comments"]) {
            [_currentItem setCommentsCount:[NSNumber numberWithInt:[_tmpString intValue]]];
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            [formatter setLocale:local];
            
            [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            
            [_currentItem setPubDate:[formatter dateFromString:_tmpString]];
        }
        
        if ([elementName isEqualToString:@"dc:creator"]) {
            [_currentItem setAuthor:_tmpString];
        }
        
        if ([elementName isEqualToString:@"guid"]) {
            [_currentItem setGuid:_tmpString];
        }
    }
    
    if ([elementName isEqualToString:@"rss"]) {
        block(_items);
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_tmpString appendString:string];
    
}

@end
