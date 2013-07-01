//
//  ALPodcastItemCell.m
//  Podcast
//
//  Created by Mike Tran on 6/28/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastItemCell.h"
#import "ALUIScrollView.h"
#import "ALFeedItem.h"

#define PULL_THRESHOLD 60

@interface ALPodcastItemCell()<UIScrollViewDelegate>
@property (nonatomic, readwrite, strong) UILabel *titleLabel;

- (void)scrollingEnded;
@end

@implementation ALPodcastItemCell {
    ALUIScrollView *_scrollView;
    UIView *_contentView;
    
    BOOL _pulling;
}

@synthesize titleLabel = _titleLabel;
@synthesize feedItem = _feedItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor lightGrayColor];
        
        _scrollView = [[ALUIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview:_scrollView];
        [_scrollView addSubview:_contentView];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_contentView addSubview:_titleLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *contentView = self.contentView;
    CGRect bounds = contentView.bounds;
    
    NSInteger pageWidth = CGRectGetWidth(bounds) + PULL_THRESHOLD;
    _scrollView.frame = CGRectMake(0, 0, pageWidth, CGRectGetHeight(bounds));
    _scrollView.contentSize = CGSizeMake(pageWidth * 2, CGRectGetHeight(bounds));
    _contentView.frame = [_scrollView convertRect:CGRectMake(15, 0, CGRectGetWidth(bounds) - 2*15, CGRectGetHeight(bounds)) fromView:contentView];
    _titleLabel.frame = [_contentView convertRect:_contentView.frame fromView:contentView];
}

- (void)setFeedItem:(ALFeedItem *)feedItem
{
    _feedItem = feedItem;
    
    if (_feedItem) {
        _titleLabel.text = _feedItem.title;
    }
}

- (ALFeedItem *)feedItem
{
    return _feedItem;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.x;
    
    if (offset > PULL_THRESHOLD && !_pulling) {
        [_delegate podcastItemCellDidBeginPulling:self];
        _pulling = YES;
    }
    
    if (_pulling) {
        CGFloat pullOffset = MAX(0, offset - PULL_THRESHOLD);
        
        [_delegate podcastItemCell:self didChangePullOffset:pullOffset];
        _scrollView.transform = CGAffineTransformMakeTranslation(pullOffset, 0);
        
    }
}

- (void)scrollingEnded
{
    [_delegate podcastItemCellDidEndPulling:self];
    _pulling = NO;
    
    _scrollView.contentOffset = CGPointZero;
    _scrollView.transform = CGAffineTransformIdentity;
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


@end
