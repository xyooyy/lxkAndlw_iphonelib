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
@interface ASGoogleVoiceRecognizer ()
{
    //header
    WavHeaderFactory *mHeaderFact;
    BOOL shouldRecignize;
}

@end

@implementation ASGoogleVoiceRecognizer

-(id)init :(BOOL)isRecognized;
{
    self = [super init];
    if (self) {
        mRecorder = [[ASRecordWav alloc]initWithData:SAMPLATE_TIME :SAMPLATE_RATE];
        [mRecorder setReceiveDataDelegate:self];
        
        shouldRecignize = isRecognized;
        
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
        
        //[mRequest setValue:@"audio/speex;rate=16000" forHTTPHeaderField:@"Content-Type"];
        [mRequest setValue:@"audio/L16;rate=16000" forHTTPHeaderField:@"Content-Type"];
        [mRequest setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
        [mRequest setHTTPMethod:@"POST"];
        //文件头
        mHeaderFact = new WavHeaderFactory();
        
        //uploadData = [[NSMutableData alloc]init];
        
        uploadQueue = [[NSMutableArray alloc]init];
        
        soundStrengthThreshold = 150;
        
        uploadDataArray = [[NSMutableArray alloc]init];
        sizeCount = 0;
        
        
        
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
    sizeCount = 0;
    recognizeCount = 0;
    //[uploadData setLength:0];
    [uploadDataArray removeAllObjects];
    mRecorderInfo = [mRecorder createRecord];
    isRecognizedSuccess = NO;
    return [mRecorder startRecord:mRecorderInfo];
    
}

- (BOOL)enforcePostBack
{
    for (int i = 0; i != uploadDataArray.count ; i++)
    {
        NSUInteger size = [(NSData*)[uploadDataArray objectAtIndex:i] length];
        sizeCount += size / 3200;
        NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"未识别",@"result",[NSNumber numberWithDouble:sizeCount],@"soundSize",[NSNumber numberWithInt:0],@"isSuccess", nil];
        [mCotroller performSelector:mSetText withObject:parmDic];
    }
    return YES;
}
-(BOOL)stopRecording
{
    [mRecorder pauseRecord:mRecorderInfo];
    isRecording = NO;
    //if(shouldRecignize)
     //   [self enforcePostBack];
    NSData *uploadData = [self getUplodaData];
    [uploadDataArray removeAllObjects];
    if([uploadData length] > 0)
    {
        [self saveWav:uploadData :fileName];
    }else
    {
        return NO;
    }
    
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


- (void)receiveRecordData:(NSDictionary *)voiceData
{
    NSData *soundData = [voiceData objectForKey:@"soundData"];
    Byte *soundDataByte = (Byte*)[soundData bytes];
    short *soundDataShort = (short*)soundDataByte;
    int size = [soundData length]*sizeof(Byte)/sizeof(short);
    CalculateSoundStrength *counter = [[CalculateSoundStrength alloc]init];
    int soundStrongh = [counter calculateVoiceStrength:soundDataShort :size :1];
      [_delegate googleVoiceSoundStrong:soundStrongh];
    if(!shouldRecignize)
    {
        [uploadDataArray addObject:[voiceData objectForKey:@"soundData"]];
        return;
    }
    static int count = 0;
    
   if (soundStrongh > soundStrengthThreshold)
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
        //[uploadData appendData:data];
        [mRecord setLength:0];
        [self upLoadWAV:data];
        count = 0;
    }
    
    if(count >= WAIT_TIME)
        count = 0;
    
    
  
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

-(BOOL)upLoadWAV:(NSData *)aDataWav
{
    [uploadQueue addObject:aDataWav];
    if([uploadQueue count] == 1 && !isBeginRecgnise)
    {
        isBeginRecgnise = YES;
       // NSData *speexData = [convertSpeex convertToSpeex:[uploadQueue objectAtIndex:0]];
        [mRequest setHTTPBody:[[NSData alloc]initWithData:[uploadQueue objectAtIndex:0]]];
        [uploadDataArray addObject:[uploadQueue objectAtIndex:0]];
        [uploadQueue removeObjectAtIndex:0];
        [NSURLConnection connectionWithRequest:mRequest delegate:self];
        NSLog(@"开始请求..");
    }
    
    return YES;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"已经得到完整的数据");
    [currentUpLoad setLength:0];
    [connection cancel];
    [self transResult:^{
    
        if([uploadQueue count] >= 1)
        {
            //NSData *speexData = [convertSpeex convertToSpeex:[uploadQueue objectAtIndex:0]];
            [mRequest setHTTPBody:[[NSData alloc]initWithData:[uploadQueue objectAtIndex:0]]];
            [uploadDataArray addObject:[uploadQueue objectAtIndex:0]];
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

#pragma mark - 识别返回
-(void)transResult :(void(^)(void))finish
{
    if(!isRecording)return;
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: [parser objectWithData:mRecivedData]];
    NSUInteger size = [(NSData*)[uploadDataArray lastObject] length];
    sizeCount += size / 3200;
    recognizeCount++;
    
    
    
    //判断是否能识别出结果
    if ([[dic objectForKey:@"hypotheses"] count]!=0)
    {
        
        NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:[[[dic objectForKey:@"hypotheses"] objectAtIndex:0] objectForKey:@"utterance"],@"result",[NSNumber numberWithDouble:sizeCount],@"soundSize",[NSNumber numberWithInt:1],@"isSuccess", nil];
        [mCotroller performSelector:mSetText withObject:parmDic];
        isRecognizedSuccess = YES;
    }
    else
    {
        NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"--",@"result",[NSNumber numberWithDouble:sizeCount],@"soundSize",[NSNumber numberWithInt:0],@"isSuccess", nil];
        [mCotroller performSelector:mSetText withObject:parmDic];
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

- (NSData*)getUplodaData
{
    NSMutableData *uploadData = [[NSMutableData alloc]init];
    for (NSData *data in uploadDataArray)
    {
        [uploadData appendData:data];
    }
    return uploadData;
}
-(NSData *)currentAudioData
{
    return [self getUplodaData];
}

@end
