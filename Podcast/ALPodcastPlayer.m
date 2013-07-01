//
//  ALPodcastPlayer.m
//  Podcast
//
//  Created by Mike Tran on 30/6/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALPodcastPlayer.h"
#import "DOUAudioStreamer.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;

@interface ALPodcastPlayer()
- (void)resetAudioStreamer;
- (void)updateStatus;
@end

@implementation ALPodcastPlayer {
    DOUAudioStreamer *_audioStreamer;
}

+ (instancetype)sharedPlayer;
{
    static id sharedPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [[self alloc] init];
    });
    return sharedPlayer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Private methods

- (void)resetAudioStreamer
{
    if (!_audioStreamer) {
        [_audioStreamer pause];
        [_audioStreamer removeObserver:self forKeyPath:@"status"];
        _audioStreamer = nil;
    }
}

- (void)updateStatus
{
    
}

#pragma mark - Public methods

- (void)play
{
    [_audioStreamer play];
}

- (void)pause
{
    [_audioStreamer pause];
}

- (void)playOrPause
{
    if ([_audioStreamer status] == DOUAudioStreamerPaused ||
        [_audioStreamer status] == DOUAudioStreamerIdle) {
        [_audioStreamer play];
    }
    else {
        [_audioStreamer pause];
    }
}


@end
