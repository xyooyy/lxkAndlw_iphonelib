//
//  AudioUserInfo.m
//  SoundMatchDemo
//
//  Created by xyooyy on 13-6-23.
//  Copyright (c) 2013年 chenyu. All rights reserved.
//

#import "AudioInfo.h"

@implementation AudioInfo
@synthesize strSongName,playAudio,audioData,smallestTime,nCurrrentOffest,beginPacket,audioID,RecordFormat,queueBuffers,audioQueue;

-(id) init
{
    self = [super init];
    if (self)
    {
        RecordFormat = malloc(sizeof(AudioStreamBasicDescription));
        queueBuffers = malloc(sizeof(AudioQueueBufferRef)*kNumberBuffers);
    }
    return self;
}


@end
