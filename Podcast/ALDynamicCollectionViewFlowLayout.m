//
//  ALDynamicCollectionViewFlowLayout.m
//  Podcast
//
//  Created by Mike Tran on 6/28/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALDynamicCollectionViewFlowLayout.h"

@implementation ALDynamicCollectionViewFlowLayout

- (void)prepareLayout
{
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGFloat delta = newBounds.origin.y - self.collectionView.bounds.origin.y;
    
    return YES;
}

@end
