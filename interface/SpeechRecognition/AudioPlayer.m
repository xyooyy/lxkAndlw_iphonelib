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
    NSUInteger fileDataLength;
}

@end

@implementation AudioPlayer



- (id)initWithFile:(NSString *)path
{
    self = [super init];
    if (self)
    {
        NSLog(@"-->%@",path);
       // NSURL *url = [NSURL fileURLWithPath:path];
        NSData *soundData = [[NSData alloc]initWithContentsOfFile:path];
        fileDataLength = [soundData length];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        if (nil == _audioPlayer) {
            NSLog(@"audio player Error :%@", error.description);
        }
        _audioPlayer.delegate = self;
    }
    return self;
}

- (double)play
{
    NSLog(@"%f",_audioPlayer.duration);
    [_audioPlayer prepareToPlay];
    double duration = _audioPlayer.duration;
    [_audioPlayer play];
    return duration;
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

- (NSUInteger)getFileLength
{
    return fileDataLength;
}

#pragma mark - AVAudioPlayerDelegate

// 播放结束时执行的动作
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _playCompletion();
}

//解码错误执行的动作
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"audio player decode error :%@", error.description);
}

@end

