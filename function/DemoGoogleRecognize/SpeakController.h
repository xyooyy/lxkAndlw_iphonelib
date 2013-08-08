//
//  SpeakController.h
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadControlView.h"
#import "FootTextControlView.h"
#import "BodyContentView.h"
#import "PopupView.h"
#import "EditController.h"
#import "TranslateController.h"
#import "ASGoogleVoiceRecognizer.h"
#import "AudioPlayer.h"
#import "HistorySelectController.h"

@interface SpeakController : UIViewController
{
    HeadControlView *mHeadSpeakControlView;
    FootTextControlView *mFootTextControlView;
    BodyContentView *mBodyContentView;
    PopupView *mPopupView;
    
    //recognizer
    ASGoogleVoiceRecognizer *mRecognizer;
    BOOL isSpeaking;
    
    //player
    AudioPlayer *mPlayer;
    
    //使用历史记录
    NSMutableString *mCurrentFile;
    NSMutableArray *mHistory;
}

-(id)init;
-(void)changeText:(NSString *)aStr;
-(void)addText:(NSString *)aStr;
@end
