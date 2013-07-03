//
//  ALPodcastStore.m
//  Podcast
//
//  Created by Mike Tran on 7/3/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastStore.h"

@interface ALPodcastStore()
- (NSURL *)applicationDocumentsDirectory;
@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation ALPodcastStore
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchFeedItems = _fetchFeedItems;
@synthesize fetchFeedInfo = _fetchFeedInfo;

+ (instancetype)sharedStore
{
    static id sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Podcast" withExtension:@"momd"];
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Podcast.sqlite"];
        
        NSError *error = nil;
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            
            NIDPRINT(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        if (persistentStoreCoordinator != nil) {
            self.managedObjectContext = [[NSManagedObjectContext alloc] init];
            [self.managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        }
    }
    return self;
}

#pragma mark - 

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext;
}

#pragma mark - Private methods

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Public methods

- (id)insertNewObjectForEntityForName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
}

- (NSManagedObject *)fetchObjectForEntityForName:(NSString *)entityName
                             predicateWithFormat:(NSString *)predicateFormat
                                   argumentArray:(NSArray *)arguments
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat argumentArray:arguments];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array != nil && [array count] > 0){
        return [array objectAtIndex:0];
    }else {
        return nil;
    }
}

- (NSArray *)fetchObjectArrayForEntityForName:(NSString *)entityName
                             predicateWithFormat:(NSString *)predicateFormat
                                   argumentArray:(NSArray *)arguments
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat argumentArray:arguments];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (BOOL)saveChanges {
    NSError *error = nil;
    
    BOOL result = [self.managedObjectContext save:&error];
    
    if (!result) {
        NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                NIDPRINT(@"DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NIDPRINT(@"%@", [error userInfo]);
        }
        NIDPRINT(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return result;
}

- (NSArray *)reloadFetchFeedItems
{
    _fetchFeedItems = nil;
    return [self fetchFeedItems];
}

- (ALFeedInfo *)newFeedInfo
{
    return [self insertNewObjectForEntityForName:@"FeedInfo"];
}

- (ALFeedItem *)newFeedItem
{
    return [self insertNewObjectForEntityForName:@"FeedItem"];
}

- (ALFeedInfo *)fetchFeedInfo
{
    if (_fetchFeedInfo == nil) {
        _fetchFeedInfo  = (ALFeedInfo *)[self fetchObjectForEntityForName:@"FeedInfo" predicateWithFormat:nil argumentArray:nil];
    }
    return _fetchFeedInfo;
    
}

- (NSArray *)fetchFeedItems
{
    if (_fetchFeedItems == nil) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FeedItem"];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
        [fetchRequest setSortDescriptors:@[ descriptor ]];
        
        NSError *error = nil;
        NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if (nil == error) {
             _fetchFeedItems = array;
        }
    }
    
    return _fetchFeedItems;
}



@end
