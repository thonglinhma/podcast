//
//  ALFeedItem+Additions.m
//  Podcast
//
//  Created by Mike Tran on 7/3/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALFeedItem+Additions.h"

@implementation ALFeedItem (Additions)

- (NSURL *)audioFileURL
{
    return [NSURL URLWithString:self.mediaUrl];
}

@end
