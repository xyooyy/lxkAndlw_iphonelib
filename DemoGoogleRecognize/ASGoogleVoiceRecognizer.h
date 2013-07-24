//
//  ASGoogleVoiceRecognizer.h
//  DemoVoiceRecognize
//
//  Created by xyooyy on 13-7-19.
//  Copyright (c) 2013年 xyooyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateSoundStrength.h"
#import "PlayAudioWav.h"
#import "ASPlayDelegate.h"
#import "ASRecordWav.h"
#import "ASRecordDelegate.h"
#import "RecordInfo.h"

#define RequestURL @"http://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=zh-CN&maxresults=9"

@interface ASGoogleVoiceRecognizer : NSObject <NSURLConnectionDataDelegate,ASRecordDelegate,ASPlayDelegate>
{
    NSMutableURLRequest *mRequest;
    
    
    NSMutableData *mRecivedData;
    
    
    
    NSError *error;
    BOOL isPlaying;
    BOOL isRecording;
    
    //录音监测
    ASRecordWav *mRecorder;
    RecordInfo *mRecorderInfo;
    
    id mCotroller;
    SEL mSetText;
    
    NSMutableData *mRecord;
    
    //播放器
    PlayAudioWav *mPlayer;
    AudioInfo *mPlayInfo;
    
    NSMutableData *mFullRecord;
    
    AudioStreamBasicDescription * mFormat;
}

-(id)init;
-(BOOL)startRecording;
-(BOOL)stopRecording;
-(BOOL)upLoadWAV:(NSData *)mDataWav;
-(void)startPlaying:(NSData *)aWavData;
-(void)playSelf;
-(void)setSaveFile:(NSURL *)aFilePath;
-(void)setController:(id)aCon andFunction:(SEL)aSEL;
@end
