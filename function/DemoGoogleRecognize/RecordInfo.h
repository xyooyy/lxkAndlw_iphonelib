//
//  RecordInfo.h
//  CyRecord
//
//  Created by 于 硕 on 13-6-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define kNumberBuffers	 3 //内存分3块

@interface RecordInfo : NSObject

@property (atomic,retain) NSObject *recorder;


@property(atomic) AudioStreamBasicDescription *mRecordFormat;
@property(atomic) AudioQueueRef *mQueue;
@property(atomic) AudioQueueBufferRef *mBuffers;
@property(atomic) AudioFileID *mAudioFile;


@property(atomic) UInt32 bufferByteSize;
@property(atomic) SInt64 mCurrentPacket;


@property(atomic) BOOL mIsRunning;
@property(atomic) float mSeconds;
@property(atomic) int sampleRate;

@property(atomic) int m_test;

@end
