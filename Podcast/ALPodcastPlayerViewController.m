//
//  ALPodcastPlayerViewController.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastPlayerViewController.h"
#import "IIViewDeckController.h"
#import "ALPodcastPlayerView.h"
#import "ALLiveBlurView.h"
#import "UIScrollView+Additions.h"

@interface ALPodcastPlayerViewController ()
@property (nonatomic, weak) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) ALPodcastPlayerView *podcastPlayerView;
@property (nonatomic, strong) ALLiveBlurView *liveBlurView;
@end

@implementation ALPodcastPlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_menuButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    ALPodcastPlayerView *podcastPlayerView = [ALPodcastPlayerView view];
    [self.view insertSubview:podcastPlayerView atIndex:0];
    self.podcastPlayerView = podcastPlayerView;
    
    ALLiveBlurView *liveBlurView = [[ALLiveBlurView alloc] initWithFrame:self.view.bounds];
    liveBlurView.originalImage = [UIImage imageNamed:@"wallpaper.png"];
    liveBlurView.isGlassEffectOn = YES;
    UIScrollView *scrollView = podcastPlayerView.scrollView;
    liveBlurView.scrollView = scrollView;
    [liveBlurView setBlurLevel:kDKBlurredBackgroundDefaultLevel];
    [self.view insertSubview:liveBlurView belowSubview:_podcastPlayerView];
    self.liveBlurView = liveBlurView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_podcastPlayerView.scrollView removeObserver:_liveBlurView forKeyPath:@"contentOffset"];
}

@end
