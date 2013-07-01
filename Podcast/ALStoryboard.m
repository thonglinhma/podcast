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
- (UIViewController *)podcastPlayerController;
- (UIViewController *)sendFeedbackController;

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

- (UIViewController *)podcastPlayerController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALPodcastPlayerIdentifier"];
}

- (UIViewController *)sendFeedbackController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"sbALSendFeedbackIdentifier"];
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


+ (UIViewController *)podcastPlayerController
{
    return [[self sharedInstance] podcastPlayerController];
}

+ (UIViewController *)sendFeedbackController
{
    return [[self sharedInstance] sendFeedbackController];
}

@end
