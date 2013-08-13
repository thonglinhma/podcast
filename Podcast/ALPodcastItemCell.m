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
#import "ALDownloadButton.h"

#define PULL_THRESHOLD 60

@interface ALPodcastItemCell()<UIScrollViewDelegate, ALDownloadButtonDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) ALDownloadButton *downloadButton;

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
        _contentView.backgroundColor = RGBCOLOR(250, 250, 250);
        
        
        _scrollView = [[ALUIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
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
        
        self.downloadButton = [[ALDownloadButton alloc] initWithFrame:CGRectMake(275, 20, 30, 30)];
        _downloadButton.delegate = self;
        [_contentView addSubview:_downloadButton];
        
        
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
    _contentView.frame = [_scrollView convertRect:CGRectMake(5, 0, CGRectGetWidth(bounds) - 2*5, CGRectGetHeight(bounds)) fromView:contentView];
    CGFloat y = 5;

    if (_downloadButton.hidden) {
        _titleLabel.frame = [_contentView convertRect:CGRectMake(15, y, CGRectGetWidth(_contentView.bounds) - 2*5, 20) fromView:contentView];
        y += CGRectGetHeight(_titleLabel.bounds) + 5;
        _subtitleLabel.frame = [_contentView convertRect:CGRectMake(15, y, CGRectGetWidth(_contentView.bounds) - 2*5, 40) fromView:contentView];
    } else {
        _titleLabel.frame = [_contentView convertRect:CGRectMake(15, y, CGRectGetWidth(_contentView.bounds) - (4*5 + CGRectGetWidth(_downloadButton.frame)), 20) fromView:contentView];
        y += CGRectGetHeight(_titleLabel.bounds) + 5;
        _subtitleLabel.frame = [_contentView convertRect:CGRectMake(15, y, CGRectGetWidth(_contentView.bounds) - (4*5 + CGRectGetWidth(_downloadButton.frame)), 40) fromView:contentView];
    }

}

- (void)setFeedItem:(ALFeedItem *)feedItem
{
    _feedItem = feedItem;
    
    if (_feedItem) {
        _titleLabel.text = _feedItem.title;
        _subtitleLabel.text = [_feedItem.desc stringByStrippingHTML];
        _downloadButton.pathToDownload = _feedItem.mediaUrl;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_feedItem.filePath]) {
            _downloadButton.hidden = YES;
        } else {
            _downloadButton.hidden = NO;
        }
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

#pragma mark - ALDownloadButtonDelegate

- (void)downloadButton:(ALDownloadButton *)downloadButton didDownloadFile:(NSString *)filePath
{
    if (filePath) {
        self.downloadButton.hidden = YES;
        self.feedItem.filePath = filePath;
        [[ALPodcastStore sharedStore] saveChanges];
        [self setNeedsDisplay];
    }
}

@end
