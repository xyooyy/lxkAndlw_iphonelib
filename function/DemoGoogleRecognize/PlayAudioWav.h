//
//  playAudio.h
//  ASDisplayWave2
//
//  Created by chenyu on 13-6-1.
//  Copyright (c) 2013年 河北师范大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import "AudioInfo.h"
#import "ASPlayDelegate.h"

@interface PlayAudioWav : NSObject
{
    double m_smallestTime;
    
    float volumn;
    
    NSString *m_strSongName;
    BOOL iscallBack;
}
@property(atomic,assign) id<ASPlayDelegate> delegate;
- (id) init : (double) smallestTime ;
- (AudioInfo*)CreateAudioFile :(NSString *)strSongName :(NSString *)strSongType ;
- (AudioInfo*)CreateAudioBuffer : (NSData*) arrayData : (AudioStreamBasicDescription) RecordFormat;
-(BOOL) startAudio : (AudioInfo*) audioQueue;
-(BOOL) stopAudio : (AudioInfo*) audioQueue;
-(BOOL) closeAudio : (AudioInfo*) audioInfo;

-(BOOL) pausePlay :(AudioInfo*)audioInfo;

-(BOOL)setVolumn :(Float32)gain;
@end
