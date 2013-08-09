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
#import "Data.h"

#define SOUNDSTRONGTH_THRESHOLD 150
#define WAIT_TIME 8

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
        mRecorder = [[ASRecordWav alloc]initWithData:1/10.f :16000];
        [mRecorder setReceiveDataDelegate:self];
        
        //初始化数据接收容器
        mRecord = [[NSMutableData alloc]init];
        mRecivedData = [[NSMutableData alloc]init];
        currentUpLoad = [[NSMutableData alloc]init];
        fileName = [[NSMutableString alloc]init];
        //录音
        isRecording = NO;
        canRecgnise = NO;
        //canRecord = YES;
        
        
        mRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]];
        [mRequest setValue:@"audio/L16;rate=16000" forHTTPHeaderField:@"Content-Type"];
        [mRequest setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
        [mRequest setHTTPMethod:@"POST"];
        //文件头
        mHeaderFact = new WavHeaderFactory();
        
        uploadData = [[NSMutableData alloc]init];
        
        uploadQueue = [[NSMutableArray alloc]init];
        
        soundStrengthThreshold = 150;
        
    }
    return self;
}


-(void)dealloc
{
    [mRecorder stopRecord:mRecorderInfo];
    delete(mHeaderFact);
}

-(void)setFilePath:(NSString *)aPath
{
    [fileName setString:aPath];
}

-(BOOL)startRecording
{
   //开始录音
    isRecording = YES;
    canRecgnise = NO;
    upLoadStart = 0;
    upLoadEnd = 0;
    mDataEnd = 0;
    [uploadData setLength:0];
    mRecorderInfo = [mRecorder createRecord];
    return [mRecorder startRecord:mRecorderInfo];
}

-(BOOL)stopRecording
{
    [mRecorder pauseRecord:mRecorderInfo];
    [self saveWav:uploadData :fileName];
//    if (upLoadEnd != upLoadStart  && canRecgnise) {
//        canRecgnise = NO;
//        NSRange range = NSMakeRange(upLoadStart, (upLoadEnd - upLoadStart));
//        [currentUpLoad appendData:[mRecord subdataWithRange:range]];
//        [self upLoadWAV:currentUpLoad];
//    }
    [uploadData setLength:0];
    isRecording = NO;
    return YES;
}

-(void)saveWav :(NSData*)data :(NSString*)parmFileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:parmFileName];
    WAVE_HEAD *header = mHeaderFact->getHeader();
    mHeaderFact->setFileSize([data length]+sizeof(WAVE_HEAD));
    mHeaderFact->setDataSize([data length]);
    NSMutableData *saveData = [[NSMutableData alloc]initWithBytes:header length:sizeof(WAVE_HEAD)];
    [saveData appendData:data];
    [saveData writeToFile:path atomically:YES];
}
-(BOOL)upLoadWAV:(NSData *)aDataWav
{
    [uploadQueue addObject:aDataWav];
    if([uploadQueue count] == 1 && !isBeginRecgnise)
    {
        isBeginRecgnise = YES;
        [mRequest setHTTPBody:[[NSData alloc]initWithData:[uploadQueue objectAtIndex:0]]];
        [uploadQueue removeObjectAtIndex:0];
        [NSURLConnection connectionWithRequest:mRequest delegate:self];
        NSLog(@"开始请求..");
    }
    
    return YES;
}

- (void)receiveRecordData:(NSDictionary *)voiceData
{
    static int count = 0;
    NSData *soundData = [voiceData objectForKey:@"soundData"];
    Byte *soundDataByte = (Byte*)[soundData bytes];
    short *soundDataShort = (short*)soundDataByte;
    int size = [soundData length]*sizeof(Byte)/sizeof(short);
    CalculateSoundStrength *counter = [[CalculateSoundStrength alloc]init];
    int soundStrongh = [counter calculateVoiceStrength:soundDataShort :size :1];

    if (soundStrongh > 40/*soundStrengthThreshold*/)
    {
        //soundStrengthThreshold -= 1;
        canRecgnise = YES;
        count = 0;
    }
    if(canRecgnise)
    {
        [mRecord appendData:soundData];
        mDataEnd = [mRecord length];
    }
    
    count++;
    if(count == WAIT_TIME && canRecgnise)
    {
        canRecgnise = NO;
        NSData *data = [[NSData alloc]initWithData:mRecord];
        [uploadData appendData:data];
        [mRecord setLength:0];
        [self upLoadWAV:data];
        count = 0;
    }
    
    if(count >= WAIT_TIME)
        count = 0;
    
    [_delegate googleVoiceSoundStrong:soundStrongh];
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
    [currentUpLoad setLength:0];
    [connection cancel];
    [self transResult:^{
    
        if([uploadQueue count] >= 1)
        {
            [mRequest setHTTPBody:[[NSData alloc]initWithData:[uploadQueue objectAtIndex:0]]];
            [uploadQueue removeObjectAtIndex:0];
            [NSURLConnection connectionWithRequest:mRequest delegate:self];
            NSLog(@"开始请求..");
        }
        isBeginRecgnise = NO;
    }];
}

-(void)setController:(id)aCon andFunction:(SEL)aSEL
{
    mCotroller = aCon;
    mSetText = aSEL;
}

//识别结果处理
-(void)transResult :(void(^)(void))finish
{
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: [parser objectWithData:mRecivedData]];
    
    //判断是否能识别出结果
    if ([[dic objectForKey:@"hypotheses"] count]!=0) {
        [mCotroller performSelector:mSetText withObject:[[[dic objectForKey:@"hypotheses"] objectAtIndex:0] objectForKey:@"utterance"]];
    }
    else
    {
        NSLog(@"没有识别");
    }
    finish();
    [mRecivedData setLength:0];
}

-(BOOL)setDelegate:(id<GoogleVoiveDelegate>)delegate
{
    _delegate = delegate;
    return YES;
}

-(RecordInfo *)recordInfo
{
    return mRecorderInfo;
}

-(NSData *)currentAudioData
{
    return uploadData;
}

@end
