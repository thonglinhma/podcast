//
//  ALStoryboard.h
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALStoryboard : NSObject

+ (UIViewController *)menuController;
+ (UIViewController *)settingController;
+ (UIViewController *)podcastPlayerController;
+ (UIViewController *)sendFeedbackController;

@end
