//
//  ASGoogleVoiceRecognizer.m
//  DemoVoiceRecognize
//
//  Created by xyooyy on 13-7-19.
//  Copyright (c) 2013年 xyooyy. All rights reserved.
//

#import "WavHeaderFactory.h"
#import "ASGoogleVoiceRecognizer.h"
#import "SBJson.h"

@interface ASGoogleVoiceRecognizer ()
{
    //header
    WavHeaderFactory *mHeaderFact;
}

@end

@implementation ASGoogleVoiceRecognizer

-(id)init
{
    self = [super init];
    if (self) {
        mRecorder = [[ASRecordWav alloc]initWithData:1/32.0 :16000];
        [mRecorder setReceiveDataDelegate:self];
        mRecorderInfo = [mRecorder createRecord];
        //测试格式
        AudioStreamBasicDescription m =  *(mRecorderInfo.mRecordFormat);
       // NSData * data = [[NSData alloc]initWithBytes:m length:40];
        //
        //初始化http请求
        mRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]];
        
        [mRequest setValue:@"audio/L16;rate=16000" forHTTPHeaderField:@"Content-Type"];
        
        [mRequest setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
        [mRequest setHTTPMethod:@"POST"];
        
        //初始化数据接收容器
        mRecivedData = [[NSMutableData alloc]init];
        mRecord = [[NSMutableData alloc]init];
        
        //播放标志
        isPlaying = NO;
        
        //luyin
        isRecording = NO;
        
        //
        mHeaderFact = new WavHeaderFactory();
        
        mFullRecord = [[NSMutableData alloc]init];
        
        //player
        mPlayer = [[PlayAudioWav alloc]init:1/32.0];
    }
    return self;
}


-(BOOL)startRecording
{
   //开始录音
    isRecording = YES;
    return [mRecorder startRecord:mRecorderInfo];
}

-(void)setSaveFile:(NSURL *)aFilePath
{
    //mRecordedFile = aFilePath;
}
-(BOOL)stopRecording
{
    isRecording = NO;
    [mRecorder pauseRecord:mRecorderInfo];
    int DataSize = [mRecord length];//*sizeof(Byte)/sizeof(short);
    WAVE_HEAD * head = mHeaderFact->getHeader();
    mHeaderFact->setDataSize(DataSize);
    int FileSize = DataSize + sizeof(WAVE_HEAD);//* sizeof(Byte)/sizeof(short);
    mHeaderFact->setFileSize(FileSize);
    [mFullRecord appendBytes:head length:sizeof(WAVE_HEAD)];
    [mFullRecord appendData:mRecord];
    [self startPlaying:mFullRecord];
    //[self upLoadWAV:mFullRecord];
    return YES;
}

-(BOOL)pauseRecording
{
    isRecording = NO;
    [mRecorder pauseRecord:mRecorderInfo];
    return YES;
}

-(BOOL)recogniseVoice
{
    return YES;
}

-(BOOL)upLoadWAV:(NSData *)mDataWav
{
    [mRequest setHTTPBody:mDataWav];
    [NSURLConnection connectionWithRequest:mRequest delegate:self];
    return YES;
}

-(void)receiveRecordData:(NSDictionary *)voiceData
{
    NSData *soundData = [voiceData objectForKey:@"soundData"];
    
    mFormat =(AudioStreamBasicDescription*) [voiceData objectForKey:@"format"];
    
    Byte *soundDataByte = (Byte*)[soundData bytes];
    short *soundDataShort = (short*)soundDataByte;
    int size = [soundData length]*sizeof(Byte)/sizeof(short);
    CalculateSoundStrength *counter = [[CalculateSoundStrength alloc]init];
    int soundStrongh = [counter calculateVoiceStrength:soundDataShort :size :2];
    NSLog(@"%d",soundStrongh);
    [mRecord appendData:[voiceData objectForKey:@"soundData"]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"服务器已经响应");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"服务器正在返回数据");
    [mRecivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"已经得到完整的数据");
    [self transResult];
}

-(void)startPlaying:(NSData *)aWavData
{
    if (!isPlaying)
    {
        mPlayInfo = [mPlayer CreateAudioBuffer:mFullRecord :*(mRecorderInfo.mRecordFormat)];
        [mPlayer startAudio:mPlayInfo];
        isPlaying = YES;
    }
    
}

-(void)setController:(id)aCon andFunction:(SEL)aSEL
{
    mCotroller = aCon;
    mSetText = aSEL;
}

//结果处理
-(void)transResult
{
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: [parser objectWithData:mRecivedData]] ;
    
    [mCotroller performSelector:mSetText withObject:[[[dic objectForKey:@"hypotheses"] objectAtIndex:0] objectForKey:@"utterance"]];
    [dic release];
    [parser release];
    
}

@end
