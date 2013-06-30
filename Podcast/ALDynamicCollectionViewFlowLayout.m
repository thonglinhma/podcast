//
//  ALDynamicCollectionViewFlowLayout.m
//  Podcast
//
//  Created by Mike Tran on 6/28/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALDynamicCollectionViewFlowLayout.h"

@implementation ALDynamicCollectionViewFlowLayout {
    UIDynamicAnimator *_dynamicAnimator;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = (CGSize){290, 50};
        self.sectionInset = UIEdgeInsetsMake(4, 10, 14, 10);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = (CGSize){290, 50};
    self.sectionInset = UIEdgeInsetsMake(4, 10, 14, 10);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        CGSize contentSize = [self collectionViewContentSize];
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for (UICollectionViewLayoutAttributes *item in items) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:[item center]];
            spring.length = 0;
            spring.damping = 0.5;
            spring.frequency = 0.8;
            
            [_dynamicAnimator addBehavior:spring];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    for (UIAttachmentBehavior *spring in _dynamicAnimator.behaviors) {
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / 500;
        
        UICollectionViewLayoutAttributes *item = [spring.items firstObject];
        CGPoint center = item.center;
        center.y +=  MIN(scrollDelta, scrollDelta * scrollResistance);
        item.center = center;
        
        [_dynamicAnimator updateItemFromCurrentState:item];
    }
    
    return NO;
}

@end
