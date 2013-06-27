//
//  ALStoryboard.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALStoryboard.h"

@interface ALStoryboard()
@property (nonatomic, strong) UIStoryboard *storyboard;

+ (instancetype)sharedInstance;

- (UIViewController *)menuController;
- (UIViewController *)settingController;
- (UIViewController *)mostPopularPodcastsController;
- (UIViewController *)myPodcastController;
- (UIViewController *)podcastPlayerController;

@end

@implementation ALStoryboard

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithStoryboardName:@"Main"];
    });
    return sharedInstance;
}

- (instancetype)initWithStoryboardName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    }
    return self;
}

#pragma mark - Private methods

- (UIViewController *)menuController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALMenuIdentifier"];
}

- (UIViewController *)settingController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALSettingIdentifier"];
}

- (UIViewController *)mostPopularPodcastsController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALMostPopularPodcastsIdentifier"];
}

- (UIViewController *)myPodcastController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALMyPodcastIdentifier"];
}

- (UIViewController *)podcastPlayerController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALPodcastPlayerIdentifier"];
}

#pragma mark - Public static methods

+ (UIViewController *)menuController
{
    return [[self sharedInstance] menuController];
}

+ (UIViewController *)settingController
{
    return [[self sharedInstance] settingController];
}

+ (UIViewController *)mostPopularPodcastsController
{
    return [[self sharedInstance] mostPopularPodcastsController];
}

+ (UIViewController *)myPodcastController
{
    return [[self sharedInstance] myPodcastController];
}

+ (UIViewController *)podcastPlayerController
{
    return [[self sharedInstance] podcastPlayerController];
}

@end
