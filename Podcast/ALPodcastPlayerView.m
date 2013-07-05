//
//  PodcastPlayerView.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "ALPodcastPlayerView.h"
#import "ALPodcastItemCell.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFRXMLRequestOperation.h"
#import "ALDynamicCollectionViewFlowLayout.h"
#import "NimbusNetworkImage.h"
#import "DOUAudioStreamer.h"
#import "SVPullToRefresh.h"
#import "ALFeedItem+Additions.h"

#define PULL_THRESHOLD 20
#define kALDefaultContentInset 400.0f
#define kALDefaultContentOffset 50

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static NSString *const kALPodcastItemCellIdentifier = @"ALPodcastItemCell";

@interface ALPodcastPlayerView() <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIWebViewDelegate, ALPodcastItemCellDelegate>
@property (nonatomic, readwrite, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView2;
@property (nonatomic, weak) IBOutlet UIView *contentView2;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet NINetworkImageView *feedInfoImageView;
@property (nonatomic, weak) IBOutlet UILabel *feedInfoTitleLabel;
@property (nonatomic, weak) IBOutlet UISlider *sliderProgress;
@property (nonatomic, weak) IBOutlet UIButton *buttonPlayPause;
@property (nonatomic, weak) IBOutlet UILabel  *labelTimePlayed;
@property (nonatomic, weak) IBOutlet UILabel  *labelDuration;
@property (nonatomic, weak) IBOutlet UILabel  *labelTitle;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UILabel *totalFeedItemsLabel;

@property (nonatomic, strong) ALDynamicCollectionViewFlowLayout *dynamicLayout;
@property (nonatomic, strong) NSArray *feedItems;
@property (nonatomic, strong) ALFeedInfo *feedInfo;

- (void)scrollingEnded;
- (void)setupHintForAudioStreamer;
- (void)resetAudioStreamer;
- (void)updateStatus;
- (void)updateFeedInfoUI;

- (IBAction)actionPlayPause:(id)sender;
- (IBAction)actionNext:(id)sender;
- (IBAction)actionSliderProgress:(id)sender;

@end

@implementation ALPodcastPlayerView {
    DOUAudioStreamer *_audioStreamer;
    NSUInteger _currentIndex;
    BOOL _pulling;
}
@synthesize scrollView = _scrollView;

+ (instancetype)view
{
    return [[[UINib nibWithNibName:@"ALPodcastPlayerView" bundle:nil]
             instantiateWithOwner:self
             options:nil] objectAtIndex:0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _currentIndex = 0;
    
    self.feedItems = [[ALPodcastStore sharedStore] fetchFeedItems];
    self.feedInfo = [[ALPodcastStore sharedStore] fetchFeedInfo];
    
    [_scrollView addSubview:_contentView];
    _scrollView.contentInset = UIEdgeInsetsMake(kALDefaultContentInset, 0, 0, 0);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds));
    _scrollView.contentOffset =  CGPointMake(0, -kALDefaultContentOffset);
    
    [_scrollView2 addSubview:_contentView2];
    _scrollView2.contentSize = CGSizeMake(CGRectGetWidth(_contentView2.bounds), CGRectGetHeight(_contentView2.bounds));
    
    ALDynamicCollectionViewFlowLayout *dynamicLayout = [[ALDynamicCollectionViewFlowLayout alloc] init];
    [_collectionView setCollectionViewLayout:dynamicLayout];
    self.dynamicLayout = dynamicLayout;
    [_collectionView registerClass:[ALPodcastItemCell class] forCellWithReuseIdentifier:kALPodcastItemCellIdentifier];
    
    [self updateFeedInfoUI];
    
    [_scrollView addPullToRefreshWithActionHandler:^{
                                                     }];
    
    __weak ALPodcastPlayerView *weakSelf = self;
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.eslpod.com/feed.xml"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
    AFRXMLRequestOperation *operation = [AFRXMLRequestOperation RXMLRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
                                                                                            
                                                                                            RXMLElement *channel = [XMLElement child:@"channel"];
                                                                                            
                                                                                            ALFeedInfo *feedInfo = (ALFeedInfo *)[[ALPodcastStore sharedStore] fetchObjectForEntityForName:@"FeedInfo" predicateWithFormat:@"link = %@" argumentArray:@[ [channel child:@"link"].text ]];
                                                                                            
                                                                                            if (feedInfo == nil) {
                                                                                                feedInfo = [[ALPodcastStore sharedStore] newFeedInfo];
                                                                                                feedInfo.link = [channel child:@"link"].text;
                                                                                                feedInfo.title = [channel child:@"title"].text;
                                                                                                feedInfo.copyright = [channel child:@"copyright"].text;
                                                                                                feedInfo.imageUrl = [[channel child:@"image"] child:@"url"].text;
                                                                                                
                                                                                                weakSelf.feedInfo = feedInfo;
                                                                                            }
                                                                                            
                                                                                            
                                                                                            [channel iterate:@"item" usingBlock: ^(RXMLElement *el){
                                                                                                ALFeedItem *feedItem = (ALFeedItem *)[[ALPodcastStore sharedStore] fetchObjectForEntityForName:@"FeedItem" predicateWithFormat:@"link = %@" argumentArray:@[ [el child:@"link"].text ]];

                                                                                                
                                                                                                if (feedItem == nil) {
                                                                                                    feedItem = [[ALPodcastStore sharedStore] newFeedItem];
                                                                                                    
                                                                                                    feedItem.title = [el child:@"title"].text;
                                                                                                    feedItem.link = [el child:@"link"].text;
                                                                                                    feedItem.desc = [el child:@"description"].text;
                                                                                                    feedItem.mediaUrl = [[el child:@"enclosure"] attribute:@"url"];
                                                                                                    feedItem.mediaType = [[el child:@"enclosure"] attribute:@"type"];
                                                                                                    
                                                                                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                                                    
                                                                                                    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
                                                                                                    [formatter setLocale:local];
                                                                                                    [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                                                                                                    
                                                                                                    feedItem.pubDate = [formatter dateFromString:[el child:@"pubDate"].text];
                                                                                                }
 
                                                                                            }];
                                                                                            
                                                                                            
                                                                                            [[ALPodcastStore sharedStore] saveChanges];
                                                                                            
                                                                                            weakSelf.feedItems =  [[ALPodcastStore sharedStore] reloadFetchFeedItems];
                                                                                            [weakSelf.dynamicLayout removeAllBehaviors];
                                                                                            [weakSelf.collectionView reloadData];
                                                                                            [self updateFeedInfoUI];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement){
                                                                                            NIDPRINT(@"Failure: %@", [error localizedDescription]);
                                                                                        }];
    [operation start];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

#pragma mark - Private methods

- (void)updateFeedInfoUI
{
    if (_feedInfoImageView != nil) {
        _feedInfoTitleLabel.text = _feedInfo.title;
        [_feedInfoImageView setPathToNetworkImage:_feedInfo.imageUrl];
    }
    
    if (_feedItems != nil) {
        _totalFeedItemsLabel.text = [NSString stringWithFormat:@"%d episodes", [_feedItems count]];
    }
}

- (void)setupHintForAudioStreamer
{
    NSUInteger nextIndex = _currentIndex + 1;
    if (nextIndex >= [_feedItems count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:_feedItems[nextIndex]];
}


- (void)resetAudioStreamer
{
    if (_audioStreamer) {
        [_audioStreamer pause];
        [_audioStreamer removeObserver:self forKeyPath:@"status" context:kStatusKVOKey];
        [_audioStreamer removeObserver:self forKeyPath:@"duration" context:kDurationKVOKey];
        _audioStreamer = nil;
    }
    
    ALFeedItem *feedItem = _feedItems[_currentIndex];
    
    _labelTitle.text = feedItem.title;
    [_webView loadHTMLString:feedItem.desc baseURL:nil];
    
    NSMutableDictionary *nowPlayingInfo = [[NSMutableDictionary alloc] init];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_feedInfo.imageUrl]]]];
    
    [nowPlayingInfo setObject:feedItem.title forKey:MPMediaItemPropertyTitle];
    [nowPlayingInfo setObject:_feedInfo.copyright forKey:MPMediaItemPropertyAlbumArtist];
    [nowPlayingInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
    
    _audioStreamer = [DOUAudioStreamer streamerWithAudioFile:feedItem];
    [_audioStreamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_audioStreamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    
    [_audioStreamer play];
    [self setupHintForAudioStreamer];
}

- (void)updateStatus
{
    switch ([_audioStreamer status]) {
        case DOUAudioStreamerPlaying:
            [_buttonPlayPause setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerPaused:
        case DOUAudioStreamerIdle:
        case DOUAudioStreamerError:
            [_buttonPlayPause  setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerFinished:
           [self actionNext:nil];
            break;
            
        case DOUAudioStreamerBuffering:
            NIDPRINT(@"Buffering");
            break;
    }
}

- (void)timerAction:(id)timer
{
    if ([_audioStreamer duration] == 0.0) {
        [_sliderProgress setValue:0.0f animated:NO];
    }
    else {
        NSTimeInterval currentTime = [_audioStreamer currentTime];
        NSTimeInterval duration = [_audioStreamer duration];
        NSTimeInterval currentDuration = duration - currentTime;
        
        [_sliderProgress setEnabled:YES];
        [_sliderProgress setValue:currentTime / duration animated:YES];
        
        NSInteger hh = floor(currentTime/3600);
        NSInteger mm = floor(((NSInteger)currentTime%3600)/60);
        NSInteger ss = floor((NSInteger)currentTime%60);
        
        if (hh > 0) {
            self.labelTimePlayed.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hh, mm, ss];
        } else {
            self.labelTimePlayed.text = [NSString stringWithFormat:@"%.2d:%.2d", mm, ss];
        }
        
        hh = floor(currentDuration/3600);
        mm = floor(((NSInteger)currentDuration%3600)/60);
        ss = floor((NSInteger)currentDuration%60);
        
        if (hh > 0) {
            self.labelDuration.text = [NSString stringWithFormat:@"-%.2d:%.2d:%.2d", hh, mm, ss];
        } else {
            self.labelDuration.text = [NSString stringWithFormat:@"-%.2d:%.2d", mm, ss];
        }

    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - 

- (UIScrollView *)scrollView
{
    return _scrollView;
}

#pragma mark - IBActions

- (IBAction)actionPlayPause:(id)sender
{
    if ([_audioStreamer status] == DOUAudioStreamerPaused ||
        [_audioStreamer status] == DOUAudioStreamerIdle) {
        [_audioStreamer play];
    }
    else {
        [_audioStreamer pause];
    }
}

- (IBAction)actionNext:(id)sender
{
    if (++_currentIndex >= [_feedItems count]) {
        _currentIndex = 0;
    }
    
    [self resetAudioStreamer];
}

- (IBAction)actionSliderProgress:(id)sender
{
    [_audioStreamer setCurrentTime:[_audioStreamer duration] * [_sliderProgress value]];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollingEnded
{
    [_delegate podcastPlayerViewDidEndPulling:self];
    _pulling = NO;
    
    CGFloat offset =  _scrollView.contentOffset.y;
    
    if (offset > -kALDefaultContentInset) {
        offset = fabs(kALDefaultContentInset + offset);
        
        if (offset > PULL_THRESHOLD*5) {
            if (offset < kALDefaultContentInset) {
                _scrollView.contentOffset =  CGPointMake(0, -kALDefaultContentOffset);
            }
            
        } else {
            _scrollView.contentOffset = CGPointMake(0, -kALDefaultContentInset);
        }
        
    }
    
    _scrollView.transform = CGAffineTransformIdentity;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset =  scrollView.contentOffset.y;
    
    if (scrollView == _scrollView) {
        
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
    } else if (scrollView == _collectionView) {
        if (_scrollView.contentOffset.y == -kALDefaultContentOffset) return;
        if (offset < -PULL_THRESHOLD*2) {
            _scrollView.contentOffset = CGPointMake(0, -kALDefaultContentOffset);
        }
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
    return [_feedItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALPodcastItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kALPodcastItemCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.feedItem = _feedItems[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndex = indexPath.row;
    [self resetAudioStreamer];
}

#pragma mark - ALPodcastItemCellDelegate

- (void)podcastItemCellDidBeginPulling:(ALPodcastItemCell *)cell
{
    [_webView loadHTMLString:cell.feedItem.desc baseURL:nil];
    [_scrollView2 setScrollEnabled:NO];
}

- (void)podcastItemCell:(ALPodcastItemCell *)cell didChangePullOffset:(CGFloat)offset
{
    [_scrollView2 setContentOffset:CGPointMake(offset, 0)];
}

- (void)podcastItemCellDidEndPulling:(ALPodcastItemCell *)cell
{
    [_scrollView2 setScrollEnabled:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.fontSize = '17px'"];
    [webView stringByEvaluatingJavaScriptFromString: @"document.body.style.fontFamily = 'Helvetica Neue'"];
}

@end
