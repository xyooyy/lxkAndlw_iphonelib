
//
//  ASRecord.m
//  ASDisplayWave2
//
//  Created by on 13-5-28.
//  Copyright (c) 2013年 河北师范大学. All rights reserved.
//

#import "ASRecordWav.h"

@implementation ASRecordWav

@synthesize receiveDataDelegate;

-(id)initWithData:(float)parmSeconds :(int)parmMSampleRate
{
    self = [super init];
    if (self) 
    {
        m_sampleRate = parmMSampleRate;
        m_BitsPerChannel = 16;
        m_ChannelsPerFrame = 1;
        mSeconds = parmSeconds;
        
        AudioSessionInitialize(NULL, NULL, NULL, (__bridge void *)(self));
        UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        bufferSize = parmMSampleRate*parmSeconds;
        AudioSessionSetActive(true);
        recordDatadict = [[NSMutableDictionary alloc]init];
        
        return self;
    }
    return nil;
}


-(BOOL) setSampleRate : (int)sampleRate
{
    m_sampleRate = sampleRate;
    return TRUE;
}

-(BOOL) setMinTime : (double) minTime
{
    mSeconds = minTime;
    return TRUE;
}
-(BOOL) setBitsPerChannel : (double) BitsPerChannel
{
    m_BitsPerChannel = BitsPerChannel;
    return TRUE;
}

-(BOOL) setChannelsPerFrame : (int) ChannelsPerFrame
{
    m_ChannelsPerFrame = ChannelsPerFrame;
    return TRUE;
}

-(BOOL) startRecord : (RecordInfo *) recorderState
{
    recorderState.mIsRunning = YES;
    OSStatus status = AudioQueueStart((*recorderState.mQueue),nil);
    if (status != noErr)  return FALSE;
    return TRUE;
}//开始录音

-(BOOL)closeRecord:(RecordInfo *)audioInfo
{
    for (int i = 0; i < kNumberBuffers; i++) 
    {
        AudioQueueFreeBuffer(*(audioInfo.mQueue), audioInfo.mBuffers[i]);
    }
    AudioFileClose(*(audioInfo.mAudioFile));
    return YES;
}
-(BOOL) pauseRecord:(RecordInfo *)recorderState
{
    if(recorderState)
    {
        recorderState.mIsRunning = NO;
        OSStatus status = AudioQueuePause(*recorderState.mQueue);
        //isInvalidate = TRUE;
        if (status != noErr) return FALSE;
        isInitTimer = FALSE;
        [recordDatadict removeAllObjects];
        isSave = FALSE;
         
        return TRUE;
    }
    return NO;
}

-(BOOL) stopRecord : (RecordInfo *) recorderState
{
    recorderState.mIsRunning = NO;
    OSStatus status = AudioQueueStop((*recorderState.mQueue), YES);
    if (status != noErr) return FALSE;
    [self closeRecord:recorderState];
    //[timer invalidate];
    isInitTimer = FALSE;
    
    return TRUE;
}//结束录音

-(RecordInfo*) createRecord
{
    int i;
    UInt32 size;

    RecordInfo *tmpRecordState = [[RecordInfo alloc]init];
    tmpRecordState.mSeconds = mSeconds;
    tmpRecordState.sampleRate = m_sampleRate;
    tmpRecordState.recorder = self;
    //AudioStreamBasicDescription *format =
    if(*tmpRecordState.mQueue)
    {
        AudioQueueDispose(*tmpRecordState.mQueue, TRUE);//处理已有队列
        *tmpRecordState.mQueue = NULL;
    }

    memset(tmpRecordState.mRecordFormat, 0, sizeof(*tmpRecordState.mRecordFormat));
    [self SetupAudioFormat:tmpRecordState];
    
   
    
    AudioQueueNewInput(tmpRecordState.mRecordFormat,
                       customAudioQueueInputCallback,
                       (__bridge void *)(tmpRecordState),NULL, NULL,0 ,tmpRecordState.mQueue);
    tmpRecordState.mCurrentPacket = 0;
    size = sizeof(*tmpRecordState.mRecordFormat);
    AudioQueueGetProperty(
                          *tmpRecordState.mQueue,
                          kAudioQueueProperty_StreamDescription,
                          tmpRecordState.mRecordFormat,
                          &size);
    
    //待定
    tmpRecordState.bufferByteSize = computeRecordBufferSize(tmpRecordState.mRecordFormat,
                                                            tmpRecordState);
    //kNumberBuffers
    for (i = 0; i != kNumberBuffers; i ++)
    {
        AudioQueueAllocateBuffer(*tmpRecordState.mQueue, tmpRecordState.bufferByteSize, &tmpRecordState.mBuffers[i]);
        AudioQueueEnqueueBuffer(*tmpRecordState.mQueue, tmpRecordState.mBuffers[i], 0, NULL);
    }
    
    return tmpRecordState;
}



-(void) SetupAudioFormat :(RecordInfo *)recorderState
{
    //一个packet可包含一个或多个frame,一个frame可包含一个或多个channel
    
    UInt32 size = sizeof((*recorderState.mRecordFormat).mSampleRate);

    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,&size,&(*recorderState.mRecordFormat).mSampleRate);
    size = sizeof((*recorderState.mRecordFormat).mChannelsPerFrame);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                            &size,
                            &(*recorderState.mRecordFormat).mChannelsPerFrame);//1:单声道；2:立体声

    (*recorderState.mRecordFormat).mFormatID = kAudioFormatLinearPCM;
    (*recorderState.mRecordFormat).mSampleRate = m_sampleRate;
    (*recorderState.mRecordFormat).mBitsPerChannel = m_BitsPerChannel;
    (*recorderState.mRecordFormat).mChannelsPerFrame = m_ChannelsPerFrame;
    (*recorderState.mRecordFormat).mFramesPerPacket = 1;
    (*recorderState.mRecordFormat).mBytesPerFrame = ((*recorderState.mRecordFormat).mBitsPerChannel / 8) *  (*recorderState.mRecordFormat).mChannelsPerFrame;
    (*recorderState.mRecordFormat).mBytesPerPacket = (*recorderState.mRecordFormat).mBytesPerFrame * (*recorderState.mRecordFormat).mFramesPerPacket;
    
    (*recorderState.mRecordFormat).mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
}
void customAudioQueueInputCallback( void  *inUserData,
                                      AudioQueueRef inAQ,
                                      AudioQueueBufferRef inBuffer,
                                      const AudioTimeStamp *inStartTime,
                                      UInt32 inNumberPacketDescriptions,
                                      const AudioStreamPacketDescription *inPacketDescs)
{
    @autoreleasepool
    {
        
   
        RecordInfo *recorderState = (__bridge RecordInfo *) inUserData;
        //NSLog(@"customAudioQueueInputCallback begin %d", recorderState.m_test);
        ASRecordWav* recorder = (ASRecordWav*)recorderState.recorder;

        if (inNumberPacketDescriptions > 0)
        {

            NSData *fileData =  [[NSData alloc] initWithBytes:recorderState.mRecordFormat length:sizeof  (AudioStreamBasicDescription)];
            NSData *voice_data = [[NSData alloc] initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
            
             NSDictionary *recordDataDict = [[NSDictionary alloc]initWithObjectsAndKeys:fileData,@"format",voice_data,@"soundData", nil];
            
           // [recorder performSelectorOnMainThread:@selector(fillBuffer:) withObject:recordDataDict waitUntilDone:NO];
            
           
         [recorder performSelectorOnMainThread:@selector(reportReceiveData:) withObject:recordDataDict waitUntilDone:NO];
        recorderState.mCurrentPacket += inNumberPacketDescriptions;
        recorderState.m_test++;
        }   
        
        if(recorderState.mIsRunning == YES)
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    
    }
    
    
}

-(void)reportReceiveData:(NSDictionary*)voiceData
{
    [self.receiveDataDelegate receiveRecordData:voiceData];
}
int computeRecordBufferSize(const AudioStreamBasicDescription *format,RecordInfo *recorderState)
{
	int frames, bytes = 0;
    frames = (int)ceil(recorderState.mSeconds * recorderState.sampleRate);
	
    bytes = frames * format->mBytesPerFrame;
    
    
    return bytes;
}//设置每个buff的容量
-(void)dealloc
{
    self.receiveDataDelegate = nil;
}
@end
