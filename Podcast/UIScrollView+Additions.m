//
//  UIScrollView+Additions.m
//  Podcast
//
//  Created by Mike Tran on 7/7/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "UIScrollView+Additions.h"
#import <objc/runtime.h>

NSString const *kALPullingKey = @"my.very.unique.key";

@implementation UIScrollView (Additions)

- (void)setPulling:(BOOL)pulling
{
     objc_setAssociatedObject(self, &kALPullingKey, [NSNumber numberWithBool:pulling], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPulling
{
     return [objc_getAssociatedObject(self, &kALPullingKey) boolValue];
}

@end
