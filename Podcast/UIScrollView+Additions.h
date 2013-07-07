//
//  UIScrollView+Additions.h
//  Podcast
//
//  Created by Mike Tran on 7/7/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Additions)
@property(nonatomic, readwrite, getter=isPulling) BOOL pulling;
@end
