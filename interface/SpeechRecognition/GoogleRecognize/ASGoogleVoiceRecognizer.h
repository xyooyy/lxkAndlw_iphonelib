//
//  ASGoogleVoiceRecognizer.h
//  DemoVoiceRecognize
//
//  Created by xyooyy on 13-7-19.
//  Copyright (c) 2013年 xyooyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateSoundStrength.h"
#import "ASRecordWav.h"
#import "ASRecordDelegate.h"
#import "RecordInfo.h"

#define RequestURL @"http://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=zh-CN&maxresults=1"

@protocol GoogleVoiveDelegate <NSObject>

- (BOOL)googleVoiceSoundStrong:(NSUInteger)soundStrong;

@end

@interface ASGoogleVoiceRecognizer : NSObject <NSURLConnectionDataDelegate,ASRecordDelegate>
{
    //http请求
    NSMutableURLRequest *mRequest;
    NSMutableData *mRecivedData;
    
    //标志位
    BOOL isRecording;
    BOOL canRecgnise;
    BOOL isBeginRecgnise;

    //录音
    ASRecordWav *mRecorder;
    RecordInfo *mRecorderInfo;
    NSMutableData *mRecord;
    NSMutableData *mFullRecord;
    NSMutableData *currentUpLoad;
    
    //NSMutableData *uploadData;
    NSMutableArray *uploadDataArray;
    
    NSMutableString *fileName;

    //识别成功的回调
    id mCotroller;
    SEL mSetText;
    
    //文件大小
    int upLoadStart;
    int upLoadEnd;
    int mDataEnd;
    
    // 音强代理
    id<GoogleVoiveDelegate> _delegate;

    NSMutableArray *uploadQueue;
    
    int soundStrengthThreshold;
    NSMutableArray *soundStrengthArray;
    

}

-(id)init;
-(void)setFilePath:(NSString *)aPath;
-(BOOL)startRecording;
-(BOOL)stopRecording;

-(BOOL)upLoadWAV:(NSData *)aDataWav;
-(void)setController:(id)aCon andFunction:(SEL)aSEL;

-(BOOL)setDelegate:(id)delegate;
-(RecordInfo *)recordInfo;
-(NSData *)currentAudioData;

@end
