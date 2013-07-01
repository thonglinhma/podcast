//
//  ALFeedItem.h
//  Podcast
//
//  Created by Mike Tran on 29/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"

@interface ALFeedItem : NSObject <DOUAudioFile>
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *itemDescription;
@property (nonatomic, copy)   NSString *itemUrl;
@property (nonatomic, copy)   NSString *itemType;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSString *author;
@end
