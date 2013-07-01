//
//  ALPodcastItemCell.h
//  Podcast
//
//  Created by Mike Tran on 6/28/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALFeedItem;

@protocol ALPodcastItemCellDelegate;

@interface ALPodcastItemCell : UICollectionViewCell
@property (nonatomic, weak) id<ALPodcastItemCellDelegate> delegate;
@property (nonatomic, strong) ALFeedItem *feedItem;
@end

@protocol ALPodcastItemCellDelegate <NSObject>
- (void)podcastItemCellDidBeginPulling:(ALPodcastItemCell *)cell;
- (void)podcastItemCell:(ALPodcastItemCell *)cell didChangePullOffset:(CGFloat)offset;
- (void)podcastItemCellDidEndPulling:(ALPodcastItemCell *)cell;
@end