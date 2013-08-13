//
//  ALFeedItem.h
//  Podcast
//
//  Created by Mike Tran on 8/13/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ALFeedItem : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * filePath;

@end
