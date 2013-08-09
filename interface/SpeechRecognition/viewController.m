//
//  RootViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "viewController.h"
#import "TextView.h"
#import "SoundWaveView.h"
#import "Data.h"
#import "UIViewAnimation.h"
#import "ASGoogleVoiceRecognizer.h"
#import "LayoutMainController.h"
#import "CurrentDataViewController.h"
#import "HistoryViewController.h"
#import "TextViewScroll.h"
#import <AVFoundation/AVFoundation.h>
#import "CalculateSoundStrength.h"
#import "AudioPlayer.h"

@interface viewController ()
{
    //TextView *_textView;
    TextViewScroll *_textView;
    SoundWaveView *_soundWaveView;
    UIViewAnimation *m_viewAnimation;
    
    ASGoogleVoiceRecognizer *gooleVoiceRecognizer;
    
    LayoutMainController *layout;

    UIImageView *_CDImageView;
    UIView *_CDCoverView;
    UIImageView *_CDInnerImageView;
    
    UIButton *buttonStart;
    UIButton *buttonEdit;
    UIButton *buttonPlay;
    UIButton *buttonTranslate;
    
    CalculateSoundStrength *calculateSoundStrength;
    AudioPlayer *_audioPlayer;
}

@end

@implementation viewController

#pragma mark-初始化用到的函数
- (BOOL)displayHistoryButton
{
    UIBarButtonItem *barButtontem = [[UIBarButtonItem alloc]initWithTitle:@"历史纪录" style:UIBarButtonItemStyleBordered target:self action:@selector(checkHistoryRecord)];
    self.navigationItem.rightBarButtonItem = barButtontem;
    return YES;
}
- (UIImageView *)addImageWithName:(NSString *)name frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    [self.view addSubview:imageView];
    return imageView;
}

- (BOOL)createCDImageView
{
    _CDImageView = [self addImageWithName:kImageCD
                                    frame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                                     kImageCDBeforeWidth, kImageCDBeforeHeight)];
    return YES;
}
- (BOOL)createCDCoverView :(CGRect)frame
{
    _CDCoverView = [[UIView alloc] initWithFrame:frame];
    _CDCoverView.backgroundColor = [UIColor colorWithWhite:kFloatZero alpha:kFloatZero];
    [self.view addSubview:_CDCoverView];
    return YES;
}
- (BOOL)createInnerImageView
{
    _CDInnerImageView = [self addImageWithName:kImageCDInner frame:CGRectMake(kFloatZero, kFloatZero,kImageCDInnerWidth, kImageCDInnerHeight)];
    _CDInnerImageView.alpha = kFloatZero;
    _CDInnerImageView.center = CGPointMake(kImageCDInnerCenterX, kImageCDInnerCenterY);
    return YES;
}
- (BOOL)createSwitchButtonTouchActionMember
{
    switchButtonTouchAction = [[SwitchButtonTouchAction alloc]init];
    return YES;
}
- (UIButton*)createButton :(CGRect)frame :(NSString*)imageName :(SEL)action :(id)obj
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:obj action:action forControlEvents:UIControlEventTouchDown];
    button.enabled = NO;
    [self.view addSubview:button];
    return button;
}
- (BOOL)createTranslateButton
{
   buttonTranslate = [self createButton
                      :CGRectMake(kButtonTranslateX, kButtonRecogniseY,kButtonRecogniseWidth,kButtonRecogniseHeight)
                      :kImageTranslate
                      :@selector(translateButtonTouch:)
                      :self];
    return YES;
}
- (BOOL)createPlayButton
{
   buttonPlay = [self createButton
                      :CGRectMake(kButtonPlayX, kButtonRecogniseY,kButtonRecogniseWidth,kButtonRecogniseHeight)
                      :kImagePlay
                      :@selector(playButtonTouch:)
                      :self];
    return YES;
}
- (BOOL)createEditButton
{
   buttonEdit = [self createButton
                      :CGRectMake(kButtonEditX, kButtonRecogniseY,kButtonRecogniseWidth,kButtonRecogniseHeight)
                      :kImageEdit
                      :@selector(editButtonTouch:)
                      :self];
    return YES;
}
- (BOOL)createStartButton
{
   buttonStart = [self createButton
                      :CGRectMake(kButtonRecogniseX, kButtonRecogniseY,kButtonRecogniseWidth, kButtonRecogniseHeight)
                      :kImageRecognise
                      :@selector(startRecogniseButtonTouch:)
                      :self];
    return YES;
}
#pragma mark-init函数

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    CGRect frame = CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight);
    
    
    [self addImageWithName:kImageBackground frame:frame];
    
    [self createCDImageView];
    [self createCDCoverView:frame];
    [self createInnerImageView];
    [self createSwitchButtonTouchActionMember];
        
    _soundWaveView = [[SoundWaveView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _textView = [[TextViewScroll alloc] initWithFrame:CGRectMake(/*kTextViewX*/0, /*kTextViewY*/120, kTextViewWidth, /*kTextViewHeight*/160) maxRows:kTextRowNumber];
    
    m_viewAnimation = [[UIViewAnimation alloc]init];
    calculateSoundStrength = [[CalculateSoundStrength alloc]init];
    
    gooleVoiceRecognizer = [[ASGoogleVoiceRecognizer alloc]init];
    [gooleVoiceRecognizer setDelegate:self];
    layout = [[LayoutMainController alloc]initWithLayoutView:self.view];
    translate = [[TranslateRecognizeResult alloc]initWithData:nil :nil];
    dataProcessing = [[DataProcessing alloc]init];
    sandBoxOperation = [[SandBoxOperation alloc]init];
    
    [self.view addSubview:_soundWaveView];
    [self.view addSubview:_textView];
    [self createStartButton];
    [self createEditButton];
    [self createPlayButton];
    [self createTranslateButton];
    buttonStart.enabled = YES;
    
    if([sandBoxOperation isContainSpecifiedSuffixFile:@".data"])
    {
        [self displayHistoryButton];
        isHistoryBtnDisplay = YES;
    }
    
}

#pragma mark- 查看历史纪录

-(void)checkHistoryRecord
{
    HistoryViewController *historyController = [[HistoryViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:historyController animated:YES];
}

- (BOOL)googleVoiceSoundStrong:(NSUInteger)soundStrong
{
    [_soundWaveView addSoundStrong:[calculateSoundStrength voiceStrengthConvertHeight:soundStrong :120]];
    return YES;
}

#pragma mark-按钮的操作

- (BOOL)translateButtonTouch :(UIButton*)sender
{
    NSLog(@"translateButtonTouch");
    return YES;
}
- (BOOL)playButtonTouch :(UIButton*)sender
{
    [switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(playButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(stopPlayButtonTouch:)
                                          withTarget:self];

    NSString *soundPath = [[NSString stringWithString:filePath] stringByAppendingString:@".wav"];
    _audioPlayer = [[AudioPlayer alloc] initWithFile:soundPath];
    [_audioPlayer playCompletion:^{
        buttonPlay.enabled = YES;
        [self stopPlayButtonTouch:sender];
    }];
    
    // 动画
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self beginStartAnimationWithButton:sender completion:^{
        [_audioPlayer play];
    }];
    
    buttonStart.enabled = NO;
    buttonEdit.enabled = NO;
    buttonPlay.enabled = NO;
    buttonTranslate.enabled = NO;

    return YES;
}

- (BOOL)stopPlayButtonTouch:(UIButton *)sender
{
    [_audioPlayer stop];
    buttonPlay.enabled = NO;
    [switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(stopPlayButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(playButtonTouch:)
                                          withTarget:self];

    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self brightenCDCoverView];

    [self beginStopAnimation:^{
        buttonPlay.enabled = YES;
        buttonEdit.enabled = YES;
        buttonStart.enabled = YES;
        buttonTranslate.enabled = YES;
    } withButton:sender];
    return YES;
}

- (BOOL)editButtonTouch:(UIButton *)sender
{
    NSLog(@"editButtonTouch");
    for (NSString *str in [dataProcessing getRecognizedData])
    {
        NSLog(@"%@",str);
    }
    return YES;
}
- (BOOL)startRecogniseButtonTouch:(UIButton *)sender
{
    buttonStart.enabled = NO;
    buttonEdit.enabled = NO;
    buttonPlay.enabled = NO;
    buttonTranslate.enabled = NO;
    [[dataProcessing getRecognizedData] removeAllObjects];
    [switchButtonTouchAction switchButtonTouchAction:sender
             oldAction:@selector(startRecogniseButtonTouch:)
            withTarget:self
             newAction:@selector(stopRecogniseButtonTouch:)
            withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self beginStartAnimationWithButton:sender completion:^{}];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:dateTime];

    [gooleVoiceRecognizer setFilePath:[NSString stringWithFormat:@"%@.wav",dateTime]];
    [gooleVoiceRecognizer startRecording];
    [gooleVoiceRecognizer setController:self andFunction:@selector(speechRecognitionResult:)];
    [_textView clearLastRecognition];
    _soundWaveView.alpha = 1.0;
    [_textView resetPosition];
    [_textView clearData];
    return YES;
}
- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    buttonStart.enabled = NO;
    [gooleVoiceRecognizer stopRecording];
    [_textView scrollsToTopWithAnimation];
    [switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(stopRecogniseButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(startRecogniseButtonTouch:)
                                          withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self brightenCDCoverView];
    [self beginStopAnimation:^{
        NSArray *copyData = [NSArray arrayWithArray:[dataProcessing getRecognizedData]];
        NSString *dataFilePath = [[NSString stringWithString:filePath] stringByAppendingString:@".data"];
        [copyData writeToFile:dataFilePath atomically:YES];

       
        if(!isHistoryBtnDisplay)
            [self displayHistoryButton];
        _soundWaveView.alpha = 0.0;
        buttonEdit.enabled = YES;
        buttonPlay.enabled = YES;
        buttonTranslate.enabled = YES;
    } withButton:sender];
   
    return YES;
}
- (BOOL)speechRecognitionResult :(NSString*)str
{
    [self addText:str];
    [dataProcessing recordRecognizedStr:str];
    return YES;
}

#pragma mark - 

- (BOOL)addText:(NSString *)text
{
    [_textView addText:text
          maxLineWidth:kTextMaxLineWidth
              withFont:[UIFont boldSystemFontOfSize:kTextFontSize]
                 color:kTextFontColor
               spacing:kTextRowSpacing];
    return YES;
}

#pragma mark - 封装动画函数

- (BOOL)rotateCDInnerImageView
{
    [m_viewAnimation animationWithLayer:_CDInnerImageView.layer
                                keypath:kAnimationRotationKeyPath
                              fromValue:[NSNumber numberWithFloat:kFloatZero]
                                toValue:[NSNumber numberWithFloat:k2PI]
                               duration:kAnimationRotationSpeed
                            repeatCount:kAnimationRotationRepeatCount
                          animationName:kAnimationRotationName];
    return YES;
}
- (void)brightenCDInnerImageView
{
    [m_viewAnimation changeViewLightness:_CDInnerImageView alpha:1.0f
                                duration:kImageCDInnerTransformTime                           completion:^{}];
}
- (void)brightenCDCoverView
{
    [m_viewAnimation animationWithLayer:_CDCoverView.layer
                                keypath:kAnimationDarknessKeyPath
                              fromValue:(__bridge id)([UIColor colorWithWhite:kFloatZero
                                                                        alpha:kAnimationDarknessAlpha].CGColor)
                                toValue:(__bridge id)[UIColor clearColor].CGColor
                               duration:kAnimationDarknessDuration
                            repeatCount:kAnimationDarknessRepeatCount
                          animationName:kAnimationDarknessName];
}
- (void)darkenCDCoverView
{
    
    [m_viewAnimation animationWithLayer:_CDCoverView.layer
                                keypath:kAnimationDarknessKeyPath
                              fromValue:(__bridge id)(_CDCoverView.backgroundColor.CGColor)
                                toValue:(__bridge id)([UIColor colorWithWhite:kFloatZero
                                                                        alpha:kAnimationDarknessAlpha].CGColor)
                               duration:kAnimationDarknessDuration
                            repeatCount:kAnimationDarknessRepeatCount
                          animationName:kAnimationDarknessName];
}
- (BOOL)beginStopAnimation:(void(^)(void)) finish withButton:(UIButton *)button
{
    [m_viewAnimation changeViewLightness:_CDInnerImageView alpha:0.f duration:kAnimationDarknessDuration completion:^{
        [m_viewAnimation changeViewFrame:_CDImageView
                                 toFrame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                                    kImageCDBeforeWidth, kImageCDBeforeHeight)
                            withDuration:kImageCDTransformDuration
                              completion:^{}];
        [m_viewAnimation removeAnimationFromLayer:_CDInnerImageView.layer forKey:kAnimationRotationName];

        finish();
        button.enabled = YES;
    }];
    return YES;
}
- (BOOL)beginStartAnimationWithButton:(UIButton *)button completion:(void(^)(void))completion
{
    [m_viewAnimation changeViewFrame:_CDImageView
                             toFrame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                                kImageCDAfterWidth, kImageCDAfterHeight)
                        withDuration:kImageCDTransformDuration
                          completion:^{
                              [self darkenCDCoverView];
                              [self brightenCDInnerImageView];
                              [self rotateCDInnerImageView];
                              button.enabled = YES;
                              completion();
                          }];
    return YES;
}
@end
