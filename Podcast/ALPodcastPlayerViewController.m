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
#import "SVPullToRefresh.h"
#import "ALLiveBlurView.h"

@interface ALPodcastPlayerViewController () <ALPodcastPlayerViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonItem;
@property (nonatomic, strong) ALPodcastPlayerView *podcastPlayerView;
@property (nonatomic, strong)  ALLiveBlurView *liveBlurView;
@end

@implementation ALPodcastPlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ALPodcastPlayerView *podcastPlayerView = [ALPodcastPlayerView view];
    podcastPlayerView.delegate = self;
    [_scrollView insertSubview:podcastPlayerView atIndex:0];
    self.podcastPlayerView = podcastPlayerView;

    
    ALLiveBlurView *liveBlurView = [[ALLiveBlurView alloc] initWithFrame:self.view.bounds];
    liveBlurView.originalImage = [UIImage imageNamed:@"wallpaper.png"];
    liveBlurView.isGlassEffectOn = YES;
    UIScrollView *scrollView = podcastPlayerView.scrollView;
    liveBlurView.scrollView = scrollView;
    [liveBlurView setBlurLevel:kDKBlurredBackgroundDefaultLevel];
    [self.view insertSubview:liveBlurView belowSubview:_scrollView];
    self.liveBlurView = liveBlurView;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
//    [_scrollView addPullToRefreshWithActionHandler:^{
//        // prepend data to dataSource, insert cells at top of table view
//        // call [tableView.pullToRefreshView stopAnimating] when done
//        //[_scrollView.pullToRefreshView stopAnimating];
//    }];
    
    [_buttonItem setAction:@selector(toggleLeftView)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_podcastPlayerView.scrollView removeObserver:_liveBlurView forKeyPath:@"contentOffset"];
     _podcastPlayerView.delegate = nil;
}

#pragma mark - ALPodcastPlayerViewDelegate

- (void)podcastPlayerViewDidBeginPulling:(ALPodcastPlayerView *)view;
{
    [_scrollView setScrollEnabled:NO];
}

- (void)podcastPlayerView:(ALPodcastPlayerView *)view didChangePullOffset:(CGFloat)offset
{
    [_scrollView setContentOffset:CGPointMake(0, -offset)];
}

- (void)podcastPlayerViewDidEndPulling:(ALPodcastPlayerView *)view
{
    [_scrollView setScrollEnabled:YES];
}

@end
