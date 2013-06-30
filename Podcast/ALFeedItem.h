//
//  ALFeedItem.h
//  Podcast
//
//  Created by Mike Tran on 29/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALFeedItem : NSObject
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *itemDescription;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSURL *commentsLink;
@property (nonatomic, strong) NSURL *commentsFeed;
@property (nonatomic, strong) NSNumber *commentsCount;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *guid;
@end
