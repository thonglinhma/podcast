//
//  ALPodcastPlayerViewController.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastPlayerViewController.h"
#import "ALPodcastPlayerView.h"
#import "SVPullToRefresh.h"
#import "AlLiveBlurView.h"

@interface ALPodcastPlayerViewController () <ALPodcastPlayerViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation ALPodcastPlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ALPodcastPlayerView *podcastPlayerView = [ALPodcastPlayerView view];
    podcastPlayerView.delegate = self;
    
    
    [self.view addSubview:podcastPlayerView];
    
    AlLiveBlurView *backgroundView = [[AlLiveBlurView alloc] initWithFrame:self.view.bounds];
    backgroundView.originalImage = [UIImage imageNamed:@"wallpaper.png"];
    backgroundView.scrollView = podcastPlayerView.scrollView;
    backgroundView.isGlassEffectOn = YES;
    [self.view insertSubview:backgroundView belowSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    [_scrollView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
        //[_scrollView.pullToRefreshView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
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
