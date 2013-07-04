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
#import "NSString+Additions.h"

#define PULL_THRESHOLD 60

@interface ALPodcastItemCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *downloadButton;

- (void)scrollingEnded;
@end

@implementation ALPodcastItemCell {
    ALUIScrollView *_scrollView;
    UIView *_contentView;
    UIView *_contentView2;
    
    BOOL _pulling;
}

@synthesize titleLabel = _titleLabel;
@synthesize feedItem = _feedItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGBCOLOR(250, 250, 250);
        
        _contentView2 = [[UIView alloc] init];
        _contentView2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentView2];
        
        self.downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _downloadButton.backgroundColor = [UIColor blueColor];
        [_downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        [_contentView2 addSubview:_downloadButton];
        
        
        _scrollView = [[ALUIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 85, 0, 0);
        
        [self.contentView addSubview:_scrollView];
        [_scrollView addSubview:_contentView];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_contentView addSubview:_titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        [_contentView addSubview:_subtitleLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *contentView = self.contentView;
    CGRect bounds = contentView.bounds;
    
    NSInteger pageWidth = CGRectGetWidth(bounds) + PULL_THRESHOLD;
    
    _contentView2.frame = bounds;
    _downloadButton.frame = CGRectMake(15, 0, 80, CGRectGetHeight(_contentView2.bounds));
    
    _scrollView.frame = CGRectMake(0, 0, pageWidth, CGRectGetHeight(bounds));
    _scrollView.contentSize = CGSizeMake(pageWidth * 2, CGRectGetHeight(bounds));
    _contentView.frame = [_scrollView convertRect:CGRectMake(10, 0, CGRectGetWidth(bounds) - 2*10, CGRectGetHeight(bounds)) fromView:contentView];
    CGFloat y = 5;
    
    _titleLabel.frame = [_contentView convertRect:CGRectMake(15, y, CGRectGetWidth(_contentView.bounds) - 2*5, 20) fromView:contentView];
    y += CGRectGetHeight(_titleLabel.bounds) + 5;
    _subtitleLabel.frame = [_contentView convertRect:CGRectMake(15, y, CGRectGetWidth(_contentView.bounds) - 2*5, 40) fromView:contentView];
}

- (void)setFeedItem:(ALFeedItem *)feedItem
{
    _feedItem = feedItem;
    
    if (_feedItem) {
        _titleLabel.text = _feedItem.title;
        _subtitleLabel.text = [_feedItem.desc stringByStrippingHTML];
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
    
    NIDPRINT(@"Offset: %f", offset);
    
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
