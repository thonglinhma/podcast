//
//  ALPodcastsViewController.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALMostPopularPodcastsViewController.h"
#import "ALPodcastCell.h"

static NSString *const kALPodcastCellIdentifier = @"ALPodcastCellIdentifier";

@interface ALMostPopularPodcastsViewController ()

@end

@implementation ALMostPopularPodcastsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Most Popular", @"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALPodcastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kALPodcastCellIdentifier forIndexPath:indexPath];
    
    return cell;
}


@end
