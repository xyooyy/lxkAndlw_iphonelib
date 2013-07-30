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

@interface SpeakController : UIViewController
{
    HeadControlView *mHeadSpeakControlView;
    FootTextControlView *mFootTextControlView;
    BodyContentView *mBodyContentView;
    PopupView *mPopupView;
    
    //recognizer
    ASGoogleVoiceRecognizer *mRecognizer;
    
    BOOL isSpeaking;
    
    NSMutableString *mResult;
    
    NSURL *mFilePath;
}

-(id)init;
-(void)changeResult:(NSMutableString *)aStr;

@end
