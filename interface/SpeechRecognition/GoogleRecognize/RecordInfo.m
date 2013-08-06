//
//  RecordInfo.m
//  CyRecord
//
//  Created by 于 硕 on 13-6-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RecordInfo.h"

@implementation RecordInfo
@synthesize mQueue,mAudioFile,mCurrentPacket,mBuffers,mIsRunning,mRecordFormat,bufferByteSize,recorder,mSeconds,sampleRate,m_test;
-(id)init
{
    self = [super init];
    if(self)
    {
        mRecordFormat = malloc(sizeof(AudioStreamBasicDescription));
        mQueue = malloc(sizeof(AudioQueueRef));
        mBuffers = malloc(sizeof(AudioQueueBufferRef)*kNumberBuffers);
        mAudioFile = malloc(sizeof(AudioFileID));
    }
    return self;
}

-(void)dealloc
{
    recorder = nil;
    free(mRecordFormat);
    free(mBuffers);
    free(mAudioFile);
    free(mQueue);
}
@end
