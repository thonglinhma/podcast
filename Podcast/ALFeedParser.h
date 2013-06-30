//
//  ALFeedParser.h
//  Podcast
//
//  Created by Mike Tran on 29/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFXMLRequestOperation.h"
#import "ALFeedItem.h"
#import "ALFeedInfo.h"

@interface ALFeedParser : AFXMLRequestOperation

+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

@end
