//
//  RootViewController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchButtonTouchAction.h"
#import "DataProcessing.h"
#import "SandBoxOperation.h"
#import "GoogleRecognize/ASGoogleVoiceRecognizer.h"
#import "ASPlayDelegate.h"
#import "UIViewAnimation.h"
#import "TextViewScroll.h"
#import "PlayAudioWav.h"
#import "SoundWaveView.h"

@interface viewController : UIViewController <GoogleVoiveDelegate,ASPlayDelegate,UIAlertViewDelegate>
{
    SwitchButtonTouchAction *m_switchButtonTouchAction;
    DataProcessing *m_dataProcessing;
    SandBoxOperation *sandBoxOperation;
    TextViewScroll *m_textView;
    SoundWaveView *m_soundWaveView;
    UIViewAnimation *m_viewAnimation;
    ASGoogleVoiceRecognizer *m_gooleVoiceRecognizer;
    CalculateSoundStrength *m_calculateSoundStrength;
    PlayAudioWav *m_audioPlayer;
    AudioInfo *m_audioInfo;
    
    UIView *m_CDCoverView;
    UIImageView *m_CDImageView;
    UIImageView *m_CDInnerImageView;
    
    UIButton *m_buttonStart;
    UIButton *m_buttonEdit;
    UIButton *m_buttonPlay;
    UIButton *m_buttonTranslate;
    
    NSString *m_currentFileName;
    NSString *m_filePath;
    
    BOOL isHistoryBtnDisplay;
    BOOL isHistoryChecked;
    BOOL isOffLine;
    BOOL isHistoryCheckedWithoutStr;
    
}
@end
