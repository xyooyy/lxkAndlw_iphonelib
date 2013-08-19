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

-(BOOL)createRequest
{
    mRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]];
    [mRequest setValue:@"audio/L16;rate=16000" forHTTPHeaderField:@"Content-Type"];
    [mRequest setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
    [mRequest setHTTPMethod:@"POST"];
    return YES;
}

-(id)init :(BOOL)isRecognized;
{
    self = [super init];
    if (self) {
        
        mRecorder = [[ASRecordWav alloc]initWithData:SAMPLATE_TIME :SAMPLATE_RATE];
        [mRecorder setReceiveDataDelegate:self];
        
        shouldRecignize = isRecognized;
        isRecording = NO;
        canRecgnise = NO;
        
        mRecord = [[NSMutableData alloc]init];
        mRecivedData = [[NSMutableData alloc]init];
        fileName = [[NSMutableString alloc]init];
        
        [self createRequest];
        
        mHeaderFact = new WavHeaderFactory();
        
        uploadQueue = [[NSMutableArray alloc]init];
        soundStrengthThreshold = 150;
        uploadDataArray = [[NSMutableArray alloc]init];
        sizeCount = 0;
        receiveCount = 0;
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
    sizeCount = 0;
    [uploadDataArray removeAllObjects];
    [uploadQueue removeAllObjects];
    mRecorderInfo = [mRecorder createRecord];
    return [mRecorder startRecord:mRecorderInfo];
    
}

/*- (BOOL)enforcePostBack
{
    for (int i = 0; i != uploadDataArray.count ; i++)
    {
        NSUInteger size = [(NSData*)[uploadDataArray objectAtIndex:i] length];
        sizeCount += size / RECORD_BUFFER_SIZE;
        NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"未识别",@"result",[NSNumber numberWithDouble:sizeCount],@"soundSize",[NSNumber numberWithInt:0],@"isSuccess", nil];
        [mCotroller performSelector:mSetText withObject:parmDic];
    }
    return YES;
}*/
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

- (int )displayWave :(NSData*)soundData
{
    Byte *soundDataByte = (Byte*)[soundData bytes];
    short *soundDataShort = (short*)soundDataByte;
    int size = [soundData length]*sizeof(Byte)/sizeof(short);
    CalculateSoundStrength *counter = [[CalculateSoundStrength alloc]init];
    int soundStrongh = [counter calculateVoiceStrength:soundDataShort :size :1];
    [_delegate googleVoiceSoundStrong:soundStrongh];
    return soundStrongh;
}
- (BOOL)dataAccumulation :(int)soundStrongh :(NSData*)soundData
{
    if (soundStrongh > soundStrengthThreshold)
    {
        canRecgnise = YES;
        [mRecord appendData:soundData];
        receiveCount = 0;
    }
    receiveCount++;
    if(receiveCount == WAIT_TIME && canRecgnise)
    {
        canRecgnise = NO;
        NSData *data = [[NSData alloc]initWithData:mRecord];
        [mRecord setLength:0];
        [self addToUpLoadQueue:data];
        receiveCount = 0;
    }
    if(receiveCount >= WAIT_TIME)
        receiveCount = 0;
    return YES;
}
- (void)receiveRecordData:(NSDictionary *)voiceData
{
    NSData *soundData = [voiceData objectForKey:@"soundData"];
    int soundStrongh = [self displayWave:soundData];
    if(!shouldRecignize)
    {
        [uploadDataArray addObject:[voiceData objectForKey:@"soundData"]];
        return;
    }
    [self dataAccumulation:soundStrongh :soundData];
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

- (BOOL)upLoad
{
    [mRequest setHTTPBody:[[NSData alloc]initWithData:[uploadQueue objectAtIndex:0]]];
    [uploadDataArray addObject:[uploadQueue objectAtIndex:0]];
    [uploadQueue removeObjectAtIndex:0];
    [NSURLConnection connectionWithRequest:mRequest delegate:self];
    NSLog(@"开始请求..");
    return YES;
}
-(BOOL)addToUpLoadQueue:(NSData *)aDataWav
{
    [uploadQueue addObject:aDataWav];
    if([uploadQueue count] == 1 && !isBeginRecgnise)
    {
        isBeginRecgnise = YES;
        [self upLoad];
    }
    
    return YES;
}
- (void)recognizedComplete
{
    if([uploadQueue count] >= 1)
    {
        [self upLoad];
    }else
    {
        isBeginRecgnise = NO;
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"已经得到完整的数据");
    [connection cancel];
    [self recognize:^{
        [self recognizedComplete];
    }];
}

-(void)recognizedSuccessCallBack:(id)aCon andFunction:(SEL)aSEL
{
    mCotroller = aCon;
    mSetText = aSEL;
}

#pragma mark - 识别返回

- (BOOL)recognizedResultPost :(NSDictionary*)dic
{
    
    if ([[dic objectForKey:@"hypotheses"] count]!=0)
    {
        NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:[[[dic objectForKey:@"hypotheses"] objectAtIndex:0] objectForKey:@"utterance"],@"result",[NSNumber numberWithDouble:sizeCount],@"soundSize",[NSNumber numberWithInt:1],@"isSuccess", nil];
        [mCotroller performSelector:mSetText withObject:parmDic];
        
    }
    else
    {
//        NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"--",@"result",[NSNumber numberWithDouble:sizeCount],@"soundSize",[NSNumber numberWithInt:0],@"isSuccess", nil];
//        [mCotroller performSelector:mSetText withObject:parmDic];
    }
    return YES;
}

-(void)recognize :(void(^)(void))finish
{
    if(!isRecording)return;
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: [parser objectWithData:mRecivedData]];
    
    NSUInteger size = [(NSData*)[uploadDataArray lastObject] length];
    int bufferSize = RECORD_BUFFER_SIZE;
    sizeCount += size / bufferSize;
    
    [self recognizedResultPost:dic];
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
