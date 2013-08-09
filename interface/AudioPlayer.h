//
//  AudioPlayer.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-8.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate>

- (id)initWithFile:(NSString *)path;

- (BOOL)play;
- (BOOL)pause;
- (BOOL)stop;

// 跳转到指定的时间
- (BOOL)jumpToTime:(NSTimeInterval)time;

// 设置播放音量(0.0~1.0)  
- (BOOL)setVolume:(float)volume;

// 播放次数(默认为1)
- (BOOL)setPlayLoops:(NSInteger)loops;

// 设置播放完成后的回调block
- (BOOL)playCompletion:(void(^)(void))completion;

@end
