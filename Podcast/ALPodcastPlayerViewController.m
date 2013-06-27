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

#define kALTableViewDefaultContentInset 500.0f

@interface ALPodcastPlayerViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView2;
@end

@implementation ALPodcastPlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(kALTableViewDefaultContentInset, 0, 0, 0);
    [self.scrollView addSubview:[ALPodcastPlayerView view]];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    [_scrollView2 addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
