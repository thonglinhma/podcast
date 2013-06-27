//
//  PodcastPlayerView.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastPlayerView.h"

@implementation ALPodcastPlayerView

+ (instancetype)view
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[UINib nibWithNibName:@"ALPodcastPlayerView" bundle:nil]
                           instantiateWithOwner:self
                           options:nil] objectAtIndex:0];;
    });
    
    return sharedInstance;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
