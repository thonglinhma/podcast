//
//  ALPodcastPlayer.h
//  Podcast
//
//  Created by Mike Tran on 30/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPodcastPlayer : NSObject
+ (instancetype)sharedPlayer;

- (void)play;
- (void)pause;
- (void)playOrPause;
@end
