//
//  ALPodcastItemDetailCell.m
//  Podcast
//
//  Created by Mike Tran on 7/8/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastItemDetailCell.h"
#import "UIImage+Additions.h"

#define BUTTON_THRESHOLD 80

@interface ALPodcastItemDetailCell()
@property (nonatomic, readonly, strong) UIButton *deleteButton;
@property (nonatomic, readonly, strong) UIButton *moreButton;

- (void)initializer;
@end

@implementation ALPodcastItemDetailCell
@synthesize deleteButton = _deleteButton;
@synthesize moreButton = _moreButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializer];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializer];
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

#pragma mark - Private properties

- (UIButton*)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:[UIImage buttonImageWithColor:[UIColor redColor] cornerRadius:0 shadowColor:[UIColor clearColor] shadowInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
        [_deleteButton setFrame:CGRectMake(CGRectGetMaxX(self.frame) - BUTTON_THRESHOLD, 0, BUTTON_THRESHOLD, CGRectGetHeight(self.contentView.frame))];
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    return _deleteButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setBackgroundImage:[UIImage buttonImageWithColor:[UIColor lightGrayColor] cornerRadius:0 shadowColor:[UIColor clearColor] shadowInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_moreButton setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
        [_moreButton setFrame:CGRectMake(CGRectGetMaxX(self.frame) - 2*BUTTON_THRESHOLD, 0, BUTTON_THRESHOLD, CGRectGetHeight(self.contentView.frame))];
        [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    return _moreButton;
}


#pragma mark - Private methods

- (void)initializer
{
    self.backViewbackgroundColor = [UIColor whiteColor];
    self.detailTextLabel.numberOfLines = 2;
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
    self.animationType = RMSwipeTableViewCellAnimationTypeEaseOut;
    self.panElasticityStartingPoint = 2*BUTTON_THRESHOLD;
    
}

- (void)cleanupBackView
{
    [super cleanupBackView];
    [_deleteButton removeFromSuperview];
    [_moreButton removeFromSuperview];
    _deleteButton = nil;
    _moreButton = nil;
}


-(void)deleteAction
{
}

- (void)moreAction
{
    
}

#pragma mark - 

- (void)didStartSwiping
{
    [super didStartSwiping];
    [self.backView addSubview:self.deleteButton];
    [self.backView addSubview:self.moreButton];
}


#pragma mark - 

- (void)resetContentView
{
    [UIView animateWithDuration:0.15f
                     animations:^{
                         self.contentView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
                     }
                     completion:^(BOOL finished) {
                         self.shouldAnimateCellReset = YES;
                         [self cleanupBackView];
                     }];
}

@end
