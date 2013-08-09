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
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        NSLog(@"%@", path);
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (nil == _audioPlayer) {
            NSLog(@"audio player Error :%@", error.description);
        }
        _audioPlayer.delegate = self;
    }
    return self;
}

- (BOOL)play
{
    [_audioPlayer prepareToPlay];
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
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _playCompletion();
}

//解码错误执行的动作
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"audio player decode error :%@", error.description);
}

//处理中断
- (void)audioPlayerBeginInteruption:(AVAudioPlayer *)player {
    NSLog(@"audio player beign interuption");
}

//处理中断结束
- (void)audioPlayerEndInteruption:(AVAudioPlayer *)player {
    NSLog(@"audio player end interuption");
}


@end

