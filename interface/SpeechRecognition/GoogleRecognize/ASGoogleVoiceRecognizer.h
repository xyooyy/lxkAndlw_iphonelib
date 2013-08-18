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
    
    ASRecordWav *mRecorder;
    RecordInfo *mRecorderInfo;
    
    NSMutableData *mRecord;
    NSMutableData *mRecivedData;
    
    NSMutableArray *uploadDataArray;
    NSMutableArray *uploadQueue;
    
    NSMutableString *fileName;

    id mCotroller;
    SEL mSetText;
    
    id<GoogleVoiveDelegate> _delegate;
    
    int soundStrengthThreshold;
    int sizeCount;
    int receiveCount;

    BOOL isRecognize;
    BOOL isRecording;
    BOOL canRecgnise;
    BOOL isBeginRecgnise;
}

-(id)init :(BOOL)isRecognized;
-(void)setFilePath:(NSString *)aPath;
-(BOOL)startRecording;
-(BOOL)stopRecording;


-(void)recognizedSuccessCallBack:(id)aCon andFunction:(SEL)aSEL;

-(BOOL)setDelegate:(id)delegate;

-(NSData *)currentAudioData;


@end
