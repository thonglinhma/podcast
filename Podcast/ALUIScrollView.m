//
//  ALUIScrollView.m
//  Podcast
//
//  Created by Mike Tran on 30/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALUIScrollView.h"

@implementation ALUIScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    NIDPRINT(@"Touch view = %@", [[touch view].class description]);
    
    [self.superview touchesBegan:touches withEvent:event]; // or 1 nextResponder, depends
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( !self.dragging ) [self.nextResponder.nextResponder touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}


@end
