//
//  AudioUserInfo.h
//  SoundMatchDemo
//
//  Created by xyooyy on 13-6-23.
//  Copyright (c) 2013年 chenyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#define kNumberBuffers 3

@interface AudioInfo : NSObject

@property (atomic,retain) NSString *strSongName;
@property (atomic,retain) NSObject *playAudio;
@property (atomic,retain) NSData   *audioData;

@property (atomic) double smallestTime;
@property (atomic) int nCurrrentOffest;
@property (atomic) SInt64 beginPacket;

@property (atomic) AudioFileID audioID;
@property (atomic) AudioStreamBasicDescription* RecordFormat;
@property (atomic) AudioQueueBufferRef* queueBuffers;
@property (atomic) AudioQueueRef audioQueue;


@end
