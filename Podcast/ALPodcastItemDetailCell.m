//
//  ALPodcastItemDetailCell.m
//  Podcast
//
//  Created by Mike Tran on 7/8/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastItemDetailCell.h"

static CGFloat const kMCStop1 = 0.20; // Percentage limit to trigger the first action
static CGFloat const kMCStop2 = 0.75; // Percentage limit to trigger the second action
static CGFloat const kMCBounceAmplitude = 20.0; // Maximum bounce amplitude when using the MCSwipeTableViewCellModeSwitch mode
static NSTimeInterval const kMCBounceDuration1 = 0.2; // Duration of the first part of the bounce animation
static NSTimeInterval const kMCBounceDuration2 = 0.1; // Duration of the second part of the bounce animation
static NSTimeInterval const kMCDurationLowLimit = 0.25; // Lowest duration when swipping the cell because we try to simulate velocity
static NSTimeInterval const kMCDurationHightLimit = 0.1; // Highest duration when swipping the cell because we try to simulate velocity


@interface ALPodcastItemDetailCell() <UIGestureRecognizerDelegate>
- (void)initializer;
@end

@implementation ALPodcastItemDetailCell {
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    BOOL _isDragging;
    BOOL _shouldDrag;
}

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


#pragma mark - Private methods

- (void)initializer
{
    self.backgroundColor = [UIColor redColor];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    [_panGestureRecognizer setDelegate:self];
    
    _isDragging = NO;
    
    // By default the cells are draggable
    _shouldDrag = YES;
}

- (CGFloat)offsetWithPercentage:(CGFloat)percentage relativeToWidth:(CGFloat)width
{
    CGFloat offset = percentage * width;
    
    if (offset < -width) offset = -width;
    else if (offset > width) offset = width;
    
    return offset;
}

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width
{
    CGFloat percentage = offset / width;
    
    if (percentage < -1.0) percentage = -1.0;
    else if (percentage > 1.0) percentage = 1.0;
    
    return percentage;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity
{
    CGFloat width = CGRectGetWidth(self.bounds);
    NSTimeInterval animationDurationDiff = kMCDurationHightLimit - kMCDurationLowLimit;
    CGFloat horizontalVelocity = velocity.x;
    
    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;
    
    return (kMCDurationHightLimit + kMCDurationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}

- (void)animateWithOffset:(CGFloat)offset {
}


#pragma mark - UITableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // clearing the dragging flag
    _isDragging = NO;
    
    // Before reuse we need to reset it's state
    _shouldDrag = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Handle Gestures

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    // The user do not want you to be dragged!
    //if (!_shouldDrag) return;
    
    UIGestureRecognizerState state = [gesture state];
    CGPoint translation = [gesture translationInView:self];
    CGPoint velocity = [gesture velocityInView:self];
    
    CGFloat percentage = [self percentageWithOffset:CGRectGetMinX(self.contentView.frame) relativeToWidth:CGRectGetWidth(self.bounds)];
    NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        _isDragging = YES;
        
        CGPoint center = {self.contentView.center.x + translation.x, self.contentView.center.y};
        [self.contentView setCenter:center];
        //[self animateWithOffset:CGRectGetMinX(self.contentView.frame)];
        [gesture setTranslation:CGPointZero inView:self];
    } if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        _isDragging = NO;
    }

}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        UIPanGestureRecognizer *g = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [g velocityInView:self];
        if (fabsf(point.x) > fabsf(point.y) ) {
            return YES;
        }
    }
    return NO;
}

@end
