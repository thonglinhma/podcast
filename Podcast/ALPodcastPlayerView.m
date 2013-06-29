//
//  PodcastPlayerView.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastPlayerView.h"
#import "ALPodcastItemCell.h"

#define PULL_THRESHOLD 20
#define kALDefaultContentInset 500.0f

@interface ALPodcastPlayerView() <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (void)scrollingEnded;
@end

@implementation ALPodcastPlayerView {
     BOOL _pulling;
}

+ (instancetype)view
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[UINib nibWithNibName:@"ALPodcastPlayerView" bundle:nil]
                           instantiateWithOwner:self
                           options:nil] objectAtIndex:0];;
    });
    
    return sharedInstance;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_scrollView addSubview:_contentView];
    _scrollView.contentInset = UIEdgeInsetsMake(kALDefaultContentInset, 0, 0, 0);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    [_collectionView registerClass:[ALPodcastItemCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - Private methods

- (void)scrollingEnded
{
    [_delegate podcastPlayerViewDidEndPulling:self];
    _pulling = NO;
    
    CGFloat offset =  _scrollView.contentOffset.y;
    
    if (offset > -kALDefaultContentInset) {
        offset = fabs(kALDefaultContentInset + offset);
        
        if (offset > PULL_THRESHOLD*5) {
            _scrollView.contentOffset =  CGPointMake(0, -50);
        } else {
            _scrollView.contentOffset = CGPointMake(0, -kALDefaultContentInset);
        }
        
    }
    
    _scrollView.transform = CGAffineTransformIdentity;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset =  scrollView.contentOffset.y;
    
    if (offset > -kALDefaultContentInset) {
        return;
    }
    
    offset = fabs(kALDefaultContentInset + offset);
    
    if (offset > PULL_THRESHOLD && !_pulling) {
        [_delegate podcastPlayerViewDidBeginPulling:self];
        _pulling = YES;
    }
    
    if (_pulling) {
        CGFloat pullOffset = MAX(0, offset - PULL_THRESHOLD);
        
        
        [_delegate podcastPlayerView:self didChangePullOffset:pullOffset];
        _scrollView.transform = CGAffineTransformMakeTranslation(0, pullOffset);
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingEnded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingEnded];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
}


@end
