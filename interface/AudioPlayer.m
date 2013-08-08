//
//  AudioPlayer.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-8.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "AudioPlayer.h"

@interface AudioPlayer ()
{
    AVAudioPlayer *_audioPlayer;
    
    // 播放完成的回调
    void (^_playCompletion) (void);
}

@end

@implementation AudioPlayer

- (id)initWithFile:(NSString *)path
{
    self = [super init];
    if (self)
    {
        NSString *path_ = [NSHomeDirectory() stringByAppendingPathComponent:@"test.wav"];
        NSLog(@"%@", path_);
        NSURL *url = [NSURL fileURLWithPath:path_];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        _audioPlayer.numberOfLoops = -1;
        if (nil == _audioPlayer)
            NSLog(@"AudioPlayer Error :%@", error.description);
    }
    return self;
}

- (BOOL)play
{
    [_audioPlayer play];
    return YES;
}

- (BOOL)pause
{
    [_audioPlayer pause];
    return YES;
}

- (BOOL)stop
{
    [_audioPlayer stop];
    return YES;
}

- (BOOL)jumpToTime:(NSTimeInterval)time
{
    _audioPlayer.currentTime = time;
    return YES;
}

- (BOOL)setVolume:(float)volume
{
    _audioPlayer.volume = volume;
    return YES;
}

- (BOOL)setPlayLoops:(NSInteger)loops
{
    _audioPlayer.numberOfLoops = loops;
    return YES;
}

- (BOOL)playCompletion:(void(^)(void))completion
{
    _playCompletion  = completion;
    return YES;
}

#pragma mark - delegate

// 播放结束时执行的动作
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    _playCompletion();
    NSLog(@"play finished...");
}

@end

