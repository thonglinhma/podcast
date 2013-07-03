//
//  ALPodcastStore.h
//  Podcast
//
//  Created by Mike Tran on 7/3/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALFeedInfo.h"
#import "ALFeedItem.h"

@interface ALPodcastStore : NSObject
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSArray *fetchFeedItems;
@property (nonatomic, readonly, strong) ALFeedInfo *fetchFeedInfo;

+ (instancetype)sharedStore;

- (id)insertNewObjectForEntityForName:(NSString *)entityName;

- (NSManagedObject *)fetchObjectForEntityForName:(NSString *)entityName
                             predicateWithFormat:(NSString *)predicateFormat
                                   argumentArray:(NSArray *)arguments;

- (NSArray *)fetchObjectArrayForEntityForName:(NSString *)entityName
                          predicateWithFormat:(NSString *)predicateFormat
                                argumentArray:(NSArray *)arguments;

- (BOOL)saveChanges;

- (ALFeedInfo *)newFeedInfo;
- (ALFeedItem *)newFeedItem;

- (NSArray *)reloadFetchFeedItems;


@end
