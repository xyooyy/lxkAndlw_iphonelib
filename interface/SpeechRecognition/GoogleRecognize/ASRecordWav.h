//
//  ASRecord.h
//  ASDisplayWave2
//
//  Created by on 13-5-28.
//  Copyright (c) 2013年 河北师范大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "RecordInfo.h"

#define BUFFER_SIZE_BYTES 65536
#define kNumberBuffers	 3 //内存分3块
#define BITS_PER_SAMPLE 16
#define CHANNELS 2
#define kBufferDurationSeconds 0.25
#define totalTime 30
#import "ASRecordDelegate.h"


@interface ASRecordWav : NSObject
{
    int m_BitsPerChannel;
    int m_ChannelsPerFrame;
    double m_minTime;
    float mSeconds;
    int mFramesPerSecond;
    int m_sampleRate;
    
   // NSMutableData *recordData;
    NSMutableDictionary *recordDatadict;
    NSTimer *timer;
    BOOL isSave;
    BOOL isInitTimer;
    int bufferSize;
}

@property(nonatomic,assign) id<ASRecordDelegate> receiveDataDelegate;
- (id)initWithData :(float)parmSeconds :(int)parmMSampleRate;

-(RecordInfo *) createRecord;
-(BOOL) startRecord:(RecordInfo *) recordInfo;
-(BOOL) stopRecord:(RecordInfo *) recordInfo;
-(BOOL) pauseRecord :(RecordInfo*)recordInfo;
-(BOOL)closeRecord :(RecordInfo*)recordInfo;



@end
