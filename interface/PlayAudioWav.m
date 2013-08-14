    //
//  playAudio.m
//  ASDisplayWave2
//
//  Created by chenyu on 13-6-1.
//  Copyright (c) 2013年 河北师范大学. All rights reserved.
//

#import "PlayAudioWav.h"
//0X10000 = 65536
#define CALLBACKFROMBUFF 0
#define CALLBACKFROMFILE 1

@implementation PlayAudioWav
@synthesize delegate;

- (id) init : (double) smallestTime
{

    self = [super init];
    if (self) {
        m_smallestTime = smallestTime;
        volumn = 1.0;
        [self AudioSessionInitialize];
        [self UseLoudSpeaker];
        [self UsePlayAndRecord];
    }
    return self;
}

- (void)AudioSessionInitialize
{
    AudioSessionInitialize(NULL, NULL, NULL, (__bridge void *)(self));
}

- (void)UsePlayAndRecord
{
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionCategory_PlayAndRecord, sizeof(sessionCategory), &sessionCategory);
    AudioSessionSetActive(true);
}

- (void)UseLoudSpeaker
{
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
}
- (void)setDelegateTospeechPlayDelegate :(id)target
{
   // m_SongsPlayDelegate = target;
}

-(void)playComplete
{
    [delegate playComplete];
}
//回调函数(Callback)的实现
-(void) AudioCallBack : (AudioInfo*)userInfo : (AudioQueueRef) inAQ : (AudioQueueBufferRef) buffer : (int) type
{
    @autoreleasepool
    {
        PlayAudioWav* player = (PlayAudioWav *)userInfo.playAudio;
        Byte *byteData = (Byte *)[userInfo.audioData bytes];
        int audioDataLength = [userInfo.audioData length];
    
        [player audioQueueOutputWithQueue : userInfo : inAQ     queueBuffer:buffer];
        UInt32 numPacketsToRead;
    
        if (type == CALLBACKFROMBUFF)
        {
            numPacketsToRead = [player readBuffIntoQueue : byteData  + userInfo.nCurrrentOffest : audioDataLength - userInfo.nCurrrentOffest : inAQ :buffer: *userInfo.RecordFormat];
            userInfo.nCurrrentOffest += numPacketsToRead;
        }
        if (type == CALLBACKFROMFILE)
        {
            numPacketsToRead = [player readPacketsIntoBuffer  : userInfo.audioID : buffer  : userInfo.RecordFormat : userInfo.beginPacket];
            userInfo.beginPacket += numPacketsToRead;
        }
    
        if (numPacketsToRead > 0) AudioQueueEnqueueBuffer(inAQ, buffer, 0, nil);
        if(numPacketsToRead == 0 && iscallBack == FALSE) 
        {
            [self performSelectorOnMainThread:@selector(playComplete) withObject:nil waitUntilDone:NO];
            iscallBack = TRUE;
        }
    }
    
}

void AudioCallbackFromBuffer(void *inUserData,AudioQueueRef inAQ,
                        AudioQueueBufferRef buffer)
{
    AudioInfo* userInfo = (__bridge AudioInfo*)inUserData;
    PlayAudioWav* player = (PlayAudioWav *)userInfo.playAudio;
    [player AudioCallBack: userInfo :  inAQ :  buffer : CALLBACKFROMBUFF];
    return;
}


void AudioCallbackFromFile(void *inUserData,AudioQueueRef inAQ,
                              AudioQueueBufferRef buffer)
{
    AudioInfo* userInfo = (__bridge AudioInfo*)inUserData;
    PlayAudioWav* player = (PlayAudioWav *)userInfo.playAudio;
    [player AudioCallBack: userInfo :  inAQ :  buffer : CALLBACKFROMFILE];

    return;
}

-(void)receivePlayData :(NSDictionary*)recordDataDict
{
    [self.delegate receivePlayData:recordDataDict];
}
-(void) audioQueueOutputWithQueue :(AudioInfo*)userInfo : (AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer
{
    
    Byte *sData = audioQueueBuffer->mAudioData;
    NSMutableData *voice_data = [[NSMutableData alloc]initWithBytes:sData length:audioQueueBuffer->mAudioDataByteSize];
    
    NSData *headFileData = [[NSData alloc]initWithBytes:userInfo.RecordFormat length:sizeof(AudioStreamBasicDescription)];
    NSDictionary *playDataDict = [[NSDictionary alloc]initWithObjectsAndKeys:headFileData,@"format",voice_data,@"soundData", nil];

    [self performSelectorOnMainThread:@selector(receivePlayData:) withObject:playDataDict waitUntilDone:NO];
}


- (BOOL) CreateAudioInfoFromFile :(NSString *)strSongName :(NSString *)strSongType : (AudioFileID*) audioFile :(AudioStreamBasicDescription*)RecordFormat
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:strSongName];
    path = [path stringByAppendingString:@".wav"];
    OSStatus status = AudioFileOpenURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], kAudioFileReadPermission, kAudioFileWAVEType, audioFile);
    if (status != noErr) return FALSE;
    
    UInt32 Formatsize = sizeof(AudioStreamBasicDescription);
    
    return AudioFileGetProperty(*audioFile, kAudioFilePropertyDataFormat , &Formatsize, RecordFormat);
}

- (AudioInfo*)CreateAudioFile :(NSString *)strSongName :(NSString *)strSongType 
{

    AudioStreamBasicDescription RecordFormat;
    AudioFileID audioFile;
    
    OSStatus status = [self CreateAudioInfoFromFile : strSongName : strSongType : &audioFile : &RecordFormat];
    if (status != noErr) return nil;
    
    AudioInfo *userInfo = [[AudioInfo alloc]init];
    userInfo.smallestTime = m_smallestTime;
    userInfo.beginPacket = 0;
    
    userInfo.strSongName = [NSString stringWithString : strSongName];
    userInfo.playAudio = self;
    userInfo.audioID = audioFile;
    memcpy(userInfo.RecordFormat, &RecordFormat, sizeof(RecordFormat));
    
    AudioQueueRef audioQueue;
    AudioQueueNewOutput(&RecordFormat, AudioCallbackFromFile, (__bridge void *)(userInfo),
                        nil, nil, 0, &audioQueue);
    
    userInfo.beginPacket = [self createFileIntoQueue:audioFile : audioQueue : 0 : RecordFormat : userInfo.queueBuffers];
    
    Float32 gain=1.0;
    AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, gain);
    userInfo.audioQueue = audioQueue;
    
    return userInfo;
}

-(int) createFileIntoQueue : (AudioFileID) audioFile : (AudioQueueRef) audioQueue : (SInt64) beginPacket : (AudioStreamBasicDescription) RecordFormat : (AudioQueueBufferRef*) queueBuffers
{
    UInt32 numPacketsToRead = RecordFormat.mSampleRate * m_smallestTime;
    UInt32 BufferSizeBytes = numPacketsToRead * RecordFormat.mBytesPerPacket;

    for (int i = 0; i < kNumberBuffers; i ++) {
        AudioQueueAllocateBuffer(audioQueue, BufferSizeBytes, &queueBuffers[i]);
        if ((beginPacket += [self readPacketsIntoBuffer : audioFile  : queueBuffers[i] : &RecordFormat: beginPacket]) == 0) return 0;
        AudioQueueEnqueueBuffer(audioQueue, queueBuffers[i], 0, nil);
    }
    return beginPacket;
}

-(SInt64)readPacketsIntoBuffer : (AudioFileID) audioFile :(AudioQueueBufferRef)buffer :(AudioStreamBasicDescription*) RecordFormat :(SInt64) currentPacket
{
    UInt32 numBytes;
    UInt32 numPacketsToRead = RecordFormat->mSampleRate * m_smallestTime;
    
    AudioFileReadPackets(audioFile, NO, &numBytes, nil, currentPacket, &numPacketsToRead, buffer->mAudioData);
    
    if ( numPacketsToRead >0){
        buffer->mAudioDataByteSize=numBytes;
        return numPacketsToRead;
    }

    return 0;
}


-(int) readBuffIntoQueue : (Byte*) byteData : (int) length  : (AudioQueueRef) audioQueue : (AudioQueueBufferRef) buffer : (AudioStreamBasicDescription) RecordFormat
{
    if (length < 0) return 0;
    
    UInt32 numPacketsToRead = RecordFormat.mSampleRate * m_smallestTime;
    int packetLenght = length < numPacketsToRead*RecordFormat.mBytesPerPacket ? length : numPacketsToRead*RecordFormat.mBytesPerPacket;
    memcpy(buffer->mAudioData, byteData, packetLenght);
    buffer->mAudioDataByteSize = packetLenght;
    return packetLenght;
}

-(int) createBuffIntoQueue : (Byte*) byteData : (int) length : (AudioQueueRef) audioQueue : (AudioStreamBasicDescription) RecordFormat  : (AudioQueueBufferRef*) queueBuffers
{
    if (length < 0 ) return FALSE;
    UInt32 numPacketsToRead = RecordFormat.mSampleRate * m_smallestTime;
   
    Byte* temp = byteData;
    int readBuffLength = 0;
    for (int i = 0; i < kNumberBuffers; i ++)
    {
        AudioQueueAllocateBuffer(audioQueue, numPacketsToRead*RecordFormat.mBytesPerPacket, &queueBuffers[i]);
        int packetLenght = [self readBuffIntoQueue:temp :length + byteData - temp :audioQueue : queueBuffers[i]:RecordFormat];

        AudioQueueEnqueueBuffer(audioQueue, queueBuffers[i], 0, nil);
        readBuffLength += packetLenght;
        if (packetLenght != numPacketsToRead*RecordFormat.mBytesPerPacket) break;
        temp += packetLenght;
    }
    return readBuffLength;
}


- (AudioInfo*)CreateAudioBuffer : (NSData*) nsAudioData : (AudioStreamBasicDescription) RecordFormat
{
    AudioInfo *userInfo = [[AudioInfo alloc]init];

    userInfo.strSongName = nil;
    userInfo.playAudio = self;
    userInfo.audioData = nsAudioData;

    userInfo.nCurrrentOffest = 0;
    memcpy(userInfo.RecordFormat, &RecordFormat, sizeof(RecordFormat));
    AudioQueueRef audioQueue;
    AudioQueueNewOutput(&RecordFormat, AudioCallbackFromBuffer, (__bridge void *)(userInfo),nil, nil, 0, &audioQueue);
    
    int length = [nsAudioData length];
    Byte *byteData = (Byte *)[nsAudioData bytes];

    userInfo.nCurrrentOffest += [self createBuffIntoQueue :  byteData : length : audioQueue : RecordFormat : userInfo.queueBuffers];
    
   AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, volumn);
    userInfo.audioQueue = audioQueue;
    iscallBack = FALSE;
    return userInfo;
}

-(BOOL)setVolumn:(Float32)gain
{
    if(gain >= 0 && gain <=1)
    {
        volumn = gain;
        return YES;
    }
    return NO;
}
-(BOOL) startAudio : (AudioInfo*) audioInfo
{
    
    OSStatus status = AudioQueueStart(audioInfo.audioQueue, NULL);
    if (status != noErr) 
    {
        NSLog(@"AudioQueueStart false");
        iscallBack = FALSE;
        return FALSE;
    }
    return TRUE;
}


-(BOOL) stopAudio : (AudioInfo*) audioInfo
{
    if (AudioQueueStop(audioInfo.audioQueue, TRUE) != noErr) return FALSE;
    return TRUE;
}

-(BOOL) closeAudio : (AudioInfo*) audioInfo
{
    for (int i = 0; i < kNumberBuffers; i++) 
    {
        AudioQueueFreeBuffer(audioInfo.audioQueue, audioInfo.queueBuffers[i]);
    }
    AudioFileClose(audioInfo.audioID);
    
    return TRUE;
}
-(BOOL) pausePlay:(AudioInfo *)audioInfo
{
    if(AudioQueuePause(audioInfo.audioQueue) == noErr)
        return YES;
    return NO;
}
@end
