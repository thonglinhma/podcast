//
//  ALFeedItem.m
//  Podcast
//
//  Created by Mike Tran on 29/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALFeedItem.h"

@implementation ALFeedItem

- (NSURL *)audioFileURL
{
    return [NSURL URLWithString:_itemUrl];
}

@end
