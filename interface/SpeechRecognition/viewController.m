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
#import "HistoryViewController.h"
#import "TextViewScroll.h"
#import <AVFoundation/AVFoundation.h>
#import "CalculateSoundStrength.h"
#import "PlayAudioWav.h"
#import "EditViewController.h"
#import "TranslateViewController.h"
#import "CheckNetStatus.h"


@interface viewController ()
{
    TextViewScroll *m_textView;
    SoundWaveView *m_soundWaveView;
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
    
    NSString *m_currentFileName;
    PlayAudioWav *_audioPlayer;
    AudioInfo *audioInfo;
}

@end

@implementation viewController

#pragma mark-初始化用到的函数
- (BOOL)displayHistoryButton
{
    UIButton *button = [self createButtonWithImageNamed:kImageHistoryButton
                                                   rect:CGRectMake(0, 0, 70, 29)
                                               delegate:self
                                                 action:@selector(checkHistoryRecord)];
    UIBarButtonItem *barButtontem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtontem;
    return YES;
}

// 创建一个按钮，并添加到self中
- (UIButton *)createButtonWithImageNamed:(NSString *)name
                                    rect:(CGRect)rect
                                delegate:(id)delegate
                                  action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    UIImage *image = [UIImage imageNamed:name];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
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
        
    m_soundWaveView = [[SoundWaveView alloc] initWithFrame:CGRectMake(kFloatZero, kFloatZero, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - kButtonRecogniseHeight)];
    m_textView = [[TextViewScroll alloc] initWithFrame:CGRectMake(kFloatZero,kTextViewY, kTextViewWidth, kTextViewHeight) maxRows:kTextRowNumber];
    
    m_viewAnimation = [[UIViewAnimation alloc]init];
    calculateSoundStrength = [[CalculateSoundStrength alloc]init];
    
    
    layout = [[LayoutMainController alloc]initWithLayoutView:self.view];
    translate = [[TranslateRecognizeResult alloc]initWithData:nil :nil];
    dataProcessing = [[DataProcessing alloc]init];
    sandBoxOperation = [[SandBoxOperation alloc]init];
    [self.view addSubview:m_soundWaveView];
    [self.view addSubview:m_textView];
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
    [historyController setPopViewAction:self :@selector(popHistoryView:)];
    [self.navigationController pushViewController:historyController animated:YES];
}

- (BOOL)googleVoiceSoundStrong:(NSUInteger)soundStrong
{
    [m_soundWaveView addSoundStrong:[calculateSoundStrength voiceStrengthConvertHeight:soundStrong :120]];
    return YES;
}

#pragma mark-按钮的操作

- (BOOL)translateButtonTouch :(UIButton*)sender
{
   
//    if(!filePath)
//    {
//        filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        filePath = [filePath stringByAppendingPathComponent:fileName];
//    }
//     NSString *path = [filePath stringByAppendingString:@".translate"];
    TranslateViewController *translateController = [[TranslateViewController alloc] initWithString:[dataProcessing getStringFromArray] :nil];
   
    //[translateController setSavePath:path];
    [self.navigationController pushViewController:translateController animated:YES];
    return YES;
}

- (BOOL)playButtonTouch :(UIButton*)sender
{
    [switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(playButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(stopPlayButtonTouch:)
                                          withTarget:self];
    _audioPlayer = [[PlayAudioWav alloc]init:1/10.0];
    _audioPlayer.delegate = self;
    
    // 动画
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self beginStartAnimationWithButton:sender completion:^{
        if(!isOffLine)
        {
            [m_textView setSubtitleKey:[dataProcessing getKeySet]];
            [m_textView playInit];
        }
        audioInfo = [_audioPlayer CreateAudioFile:m_currentFileName :@"wav"];
        [_audioPlayer startAudio:audioInfo];
        m_soundWaveView.alpha = 0.f;
        
    }];
    
    buttonStart.enabled = NO;
    buttonTranslate.enabled = NO;
    buttonEdit.enabled = NO;
    buttonPlay.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}

- (BOOL)stopPlayButtonTouch:(UIButton *)sender
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [_audioPlayer stopAudio:audioInfo];
    [_audioPlayer closeAudio:audioInfo];
    [m_textView resetTextViewAlpha];
    
    [m_viewAnimation changeViewLightness:m_soundWaveView alpha:0.f duration:0.f completion:^{}];
    
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
        buttonStart.enabled = YES;
        if(isOffLine)
        {
           buttonEdit.enabled = NO;
           buttonTranslate.enabled = NO;
        }else
        {
            buttonEdit.enabled = YES;
            buttonTranslate.enabled = YES;
        }
        if(isHistoryChecked&&isHistoryCheckedWithoutStr)
        {
            buttonEdit.enabled = NO;
            buttonTranslate.enabled = NO;
        }
       
        
    } withButton:sender];
    return YES;
}

- (BOOL)editButtonTouch:(UIButton *)sender
{
    EditViewController *editViewController = [[EditViewController alloc] initWithData:dataProcessing];
    [editViewController setEditCompleteCallBack:self :@selector(editSave:)];
    NSString *path;
    if(!isHistoryChecked)
       path = [filePath stringByAppendingString:@".data"];
    if(isHistoryChecked)
    {
        path = [sandBoxOperation getDocumentPath];
        path = [path stringByAppendingPathComponent:m_currentFileName];
        path = [path stringByAppendingString:@".data"];
    }
        
    [editViewController setSavePath:path];
    [editViewController setTextViewScroll:m_textView];
    [self.navigationController pushViewController:editViewController animated:YES];    
    
    return YES;
}
- (void)startRecogniseButtonTouch:(UIButton *)sender
{
    CheckNetStatus *checkNetStatus = [[CheckNetStatus alloc]init];
    int back = [checkNetStatus isInWIFI];
    UIAlertView *alertView;
    if(back == NotReachable)
    {
       alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络离线，不能进行语音识别" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    if(back == ReachableViaWWAN)
    {
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络处在3G模式，需要用您的流量" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"允许", nil];
        [alertView show];
    }
    if(!alertView)
    {
        [self startRecognise:sender :YES];
        isOffLine = NO;
    }
        
}
- (BOOL)startRecognise:(UIButton *)sender :(BOOL)isRecognize
{
    
    buttonStart.enabled = NO;
    buttonEdit.enabled = NO;
    buttonPlay.enabled = NO;
    buttonTranslate.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    isHistoryChecked = NO;

    [dataProcessing clearDicData];
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
    
    m_currentFileName = dateTime;
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:dateTime];
    
    [self createRecognization:isRecognize :dateTime];
    m_soundWaveView.alpha = 1.0;
    [m_textView clearLastRecognition];
    [m_textView resetPosition];
    [dataProcessing clearDicData];
    return YES;
}
#pragma mark - 新建一个识别
- (BOOL)createRecognization :(BOOL)isRecognize :(NSString*)dateTime
{
    gooleVoiceRecognizer = [[ASGoogleVoiceRecognizer alloc]init:isRecognize];
    [gooleVoiceRecognizer setDelegate:self];
    [gooleVoiceRecognizer setFilePath:[NSString stringWithFormat:@"%@.wav",dateTime]];
    [gooleVoiceRecognizer startRecording];
    [gooleVoiceRecognizer setController:self andFunction:@selector(speechRecognitionResult:)];
    return YES;
}
- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    buttonStart.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    BOOL isSuccess = [gooleVoiceRecognizer stopRecording];
    [m_textView scrollsToTopWithAnimation];
    [switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(stopRecogniseButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(startRecogniseButtonTouch:)
                                          withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self brightenCDCoverView];
    [self beginStopAnimation:^{
        
        if(!isHistoryBtnDisplay)
            [self displayHistoryButton];
        m_soundWaveView.alpha = 0.0;
        if(isSuccess)
        {
            NSString *dataFilePath = [[NSString stringWithString:filePath] stringByAppendingString:@".data"];
            [dataProcessing saveDicToFile:dataFilePath];
            if(isOffLine)
            {
                buttonEdit.enabled = NO;
                buttonTranslate.enabled = NO;
                 buttonPlay.enabled = YES;
            }else
            {
              buttonPlay.enabled = YES;
              buttonEdit.enabled = YES;
              buttonTranslate.enabled = YES;
            } 
        }else
        {
            if(![sandBoxOperation isContainSpecifiedSuffixFile:@".data"])
                self.navigationItem.rightBarButtonItem.enabled = NO;
            buttonPlay.enabled = NO;
            buttonEdit.enabled = NO;
            buttonTranslate.enabled = NO;
            buttonStart.enabled = YES;
        }
        
    } withButton:sender];
   
    return YES;
}
#pragma mark - 识别结果的返回
- (BOOL)speechRecognitionResult :(NSDictionary*)postBackDic
{
    NSString *str = [postBackDic objectForKey:@"result"];
    NSNumber *number = [postBackDic objectForKey:@"soundSize"];
    
    [self addText:str];
    [dataProcessing recognizedStrTimestamp:str :[number doubleValue]];
    return YES;
}

#pragma mark - 

- (BOOL)addText:(NSString *)text
{
    [m_textView addText:text
          maxLineWidth:kTextMaxLineWidth
              withFont:[UIFont boldSystemFontOfSize:kTextFontSize]
                 color:kTextFontColor
               spacing:kTextRowSpacing];
    return YES;
}
#pragma mark - 播放录音时回调

- (void)receicePlayDataCallBack :(NSDictionary*)soundDataDic
{
    
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
                                duration:kImageCDInnerTransformTime
                              completion:^{}];
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
#pragma mark - 编辑保存按钮的回调
- (void)editSave :(NSMutableDictionary*)newDictionary
{
    [dataProcessing setDictionary:newDictionary];
    [m_textView clearLastRecognition];
    [m_textView resetPosition];
    NSArray *keySet = [dataProcessing getKeySet];
    for (NSString *key in keySet)
    {
        [self addText:[newDictionary objectForKey:key]];
    }
    
}
#pragma mark - 播放录音的委托


- (void)playComplete
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    m_soundWaveView.alpha = 0.f;
    [self stopPlayButtonTouch:buttonPlay];
    [m_textView playComplete];
}
- (void)receivePlayData:(NSDictionary *)voiceData
{
    if(!isOffLine)
        [m_textView receivePlayData];
    
//    NSData *soundData = [voiceData objectForKey:@"soundData"];
//    Byte *soundDataByte = (Byte*)[soundData bytes];
//    short *soundDataShort = (short*)soundDataByte;
//    int size = [soundData length]*sizeof(Byte)/sizeof(short);
//    int soundStrongh = [calculateSoundStrength calculateVoiceStrength:soundDataShort :size :1];
//    int compress = [calculateSoundStrength voiceStrengthConvertHeight:soundStrongh :120];
//    [_soundWaveView addSoundStrong:compress];
    
}
#pragma mark - 历史纪录弹出
- (void)popHistoryView :(NSMutableDictionary*)dic
{
    
    NSArray *recognizedStrArray = [dic objectForKey:@"str"];
    isHistoryChecked = YES;
    if(recognizedStrArray.count == 0)
    {
        buttonPlay.enabled = YES;
        buttonStart.enabled = YES;
        buttonEdit.enabled = NO;
        buttonTranslate.enabled = NO;
        isHistoryCheckedWithoutStr = YES;
    }else
    {
        
        buttonPlay.enabled = YES;
        buttonEdit.enabled = YES;
        buttonTranslate.enabled = YES;
        isHistoryCheckedWithoutStr = NO;
    }
    [m_textView clearLastRecognition];
    [m_textView resetPosition];
    [m_textView playInit];
    for (NSString *str in recognizedStrArray)
    {
        [self addText:str];
    }
    NSString *doc = [sandBoxOperation getDocumentPath];
    NSString *currentFileName = [dic objectForKey:@"fileName"];
    doc = [doc stringByAppendingPathComponent:currentFileName];
    doc = [doc stringByAppendingString:@".data"];
    
    NSLog(@"%@",doc);
    NSMutableDictionary *historyRecordDic = [[NSMutableDictionary alloc]initWithContentsOfFile:doc];
    [dataProcessing setDictionary:historyRecordDic];
    NSMutableArray *noSqueneceKeyset = [[NSMutableArray alloc]init];
    for (NSString *key in [historyRecordDic keyEnumerator])
    {
        [noSqueneceKeyset addObject:key];
    }
    
    NSArray *keySet = [dataProcessing timestampSequence:noSqueneceKeyset];
    [m_textView setSubtitleKey:keySet];
    m_currentFileName = [dic objectForKey:@"fileName"];
}

#pragma mark - alertView的delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self startRecognise:buttonStart :NO];
        isOffLine = YES;
    }
        
    if (buttonIndex == 1)
    {
        [self startRecognise:buttonStart :YES];
        isOffLine = NO;
    }
        
}
@end
