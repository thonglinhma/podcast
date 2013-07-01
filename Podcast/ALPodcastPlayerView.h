//
//  PodcastPlayerView.h
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALPodcastPlayerViewDelegate;

@interface ALPodcastPlayerView : UIView
@property (nonatomic, weak) id<ALPodcastPlayerViewDelegate>delegate;
@property (nonatomic, readonly, strong) UIScrollView *scrollView;

+ (instancetype)view;
@end

@protocol ALPodcastPlayerViewDelegate <NSObject>
- (void)podcastPlayerViewDidBeginPulling:(ALPodcastPlayerView *)view;
- (void)podcastPlayerView:(ALPodcastPlayerView *)view didChangePullOffset:(CGFloat)offset;
- (void)podcastPlayerViewDidEndPulling:(ALPodcastPlayerView *)view;
@end
