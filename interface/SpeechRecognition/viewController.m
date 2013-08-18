//
//  RootViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "Data.h"
#import "viewController.h"
#import "UIViewAnimation.h"
#import "ASGoogleVoiceRecognizer.h"
#import "HistoryViewController.h"
#import "CalculateSoundStrength.h"
#import "EditViewController.h"
#import "TranslateViewController.h"
#import "CheckNetStatus.h"


@implementation viewController

#pragma mark-布局函数
- (BOOL)displayHistoryButton
{
    UIButton *button = [self createButtonWithImageNamed:kImageHistoryButton
                                                   rect:CGRectMake(kFloatZero,kFloatZero, kButtonHistoryWidth,kButtonHistoryHeight)
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
    m_CDImageView = [self addImageWithName:kImageCD frame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,kImageCDBeforeWidth, kImageCDBeforeHeight)];
    return YES;
}
- (BOOL)createCDCoverView :(CGRect)frame
{
    m_CDCoverView = [[UIView alloc] initWithFrame:frame];
    m_CDCoverView.backgroundColor = [UIColor colorWithWhite:kFloatZero alpha:kFloatZero];
    [self.view addSubview:m_CDCoverView];
    return YES;
}
- (BOOL)createInnerImageView
{
    m_CDInnerImageView = [self addImageWithName:kImageCDInner frame:CGRectMake(kFloatZero, kFloatZero,kImageCDInnerWidth, kImageCDInnerHeight)];
    m_CDInnerImageView.alpha = kFloatZero;
    m_CDInnerImageView.center = CGPointMake(kImageCDInnerCenterX, kImageCDInnerCenterY);
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
   m_buttonTranslate = [self createButton:CGRectMake(kButtonTranslateX, kButtonRecogniseY,kButtonRecogniseWidth,kButtonRecogniseHeight):kImageTranslate:@selector(translateButtonTouch:):self];
    return YES;
}
- (BOOL)createPlayButton
{
   m_buttonPlay = [self createButton:CGRectMake(kButtonPlayX, kButtonRecogniseY,kButtonRecogniseWidth,kButtonRecogniseHeight):kImagePlay:@selector(playButtonTouch:):self];
    return YES;
}
- (BOOL)createEditButton
{
   m_buttonEdit = [self createButton:CGRectMake(kButtonEditX, kButtonRecogniseY,kButtonRecogniseWidth,kButtonRecogniseHeight):kImageEdit:@selector(editButtonTouch:):self];
    return YES;
}
- (BOOL)createStartButton
{
   m_buttonStart = [self createButton:CGRectMake(kButtonRecogniseX, kButtonRecogniseY,kButtonRecogniseWidth, kButtonRecogniseHeight):kImageRecognise:@selector(startRecogniseButtonTouch:):self];
    return YES;
}
#pragma mark-init函数

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutBackGround];
        
    m_soundWaveView = [[SoundWaveView alloc] initWithFrame:CGRectMake(kFloatZero, kFloatZero, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - kButtonRecogniseHeight)];
    m_textView = [[TextViewScroll alloc] initWithFrame:CGRectMake(kFloatZero,kTextViewY, kTextViewWidth, kTextViewHeight) maxRows:kTextRowNumber];
    
    m_viewAnimation = [[UIViewAnimation alloc]init];
    m_calculateSoundStrength = [[CalculateSoundStrength alloc]init];
    m_switchButtonTouchAction = [[SwitchButtonTouchAction alloc]init];
    
    m_dataProcessing = [[DataProcessing alloc]init];
    sandBoxOperation = [[SandBoxOperation alloc]init];
    [self.view addSubview:m_soundWaveView];
    [self.view addSubview:m_textView];
    [self createStartButton];
    [self createEditButton];
    [self createPlayButton];
    [self createTranslateButton];
    m_buttonStart.enabled = YES;
    
    if([sandBoxOperation isContainSpecifiedSuffixFile:@".data"])
    {
        [self displayHistoryButton];
        isHistoryBtnDisplay = YES;
    }
}


#pragma mark - 背景布局

-(BOOL)layoutBackGround
{
    CGRect frame = CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight);
    [self addImageWithName:kImageBackground frame:frame];
    [self createCDImageView];
    [self createCDCoverView:frame];
    [self createInnerImageView];
    return YES;
}

#pragma mark- 查看历史纪录

-(void)checkHistoryRecord
{
    HistoryViewController *historyController = [[HistoryViewController alloc]initWithStyle:UITableViewStylePlain];
    [historyController setPopViewAction:self :@selector(popHistoryView:)];
    [self.navigationController pushViewController:historyController animated:YES];
}

#pragma mark - 录音回调，用于展示音强
- (BOOL)googleVoiceSoundStrong:(NSUInteger)soundStrong
{
    [m_soundWaveView addSoundStrong:[m_calculateSoundStrength voiceStrengthConvertHeight:soundStrong :480]];
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
    TranslateViewController *translateController = [[TranslateViewController alloc] initWithString:[m_dataProcessing getStringFromArray] :nil];
   
    //[translateController setSavePath:path];
    [self.navigationController pushViewController:translateController animated:YES];
    return YES;
}

#pragma mark - 和playButton按钮相关的操作
- (BOOL)playButtonTouchButtonEnabled
{
    m_buttonStart.enabled = NO;
    m_buttonTranslate.enabled = NO;
    m_buttonEdit.enabled = NO;
    m_buttonPlay.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}
- (BOOL)playButtonTouchAnimationComplete
{
    if(!isOffLine)
    {
        [m_textView setSubtitleKey:[m_dataProcessing getKeySet]];
        [m_textView playInit];
    }
    m_audioInfo = [m_audioPlayer CreateAudioFile:m_currentFileName :@"wav"];
    [m_audioPlayer startAudio:m_audioInfo];
    m_soundWaveView.alpha = 0.f;
    return YES;
}
- (BOOL)playButtonTouch :(UIButton*)sender
{
    [m_switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(playButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(stopPlayButtonTouch:)
                                          withTarget:self];
    m_audioPlayer = [[PlayAudioWav alloc]init:SAMPLATE_TIME];
    m_audioPlayer.delegate = self;
    
    // 动画
    [m_viewAnimation removeAnimationFromLayer:m_CDCoverView.layer forKey:kAnimationDarknessName];
    [self changeCDImageViewFrame:sender completion:^{
        [self playButtonTouchAnimationComplete]; 
    }];
    
    [self playButtonTouchButtonEnabled];
    return YES;
}

#pragma mark - 和stopPlayButton安妮相关的操作

- (BOOL)offLineButtonsEnabled
{
    if(isOffLine)
    {
        m_buttonEdit.enabled = NO;
        m_buttonTranslate.enabled = NO;
    }
    else
    {
        m_buttonEdit.enabled = YES;
        m_buttonTranslate.enabled = YES;
    }
    return YES;
}
- (BOOL)stopPlayButtonTouchButtonEnabled
{
    m_buttonPlay.enabled = YES;
    m_buttonStart.enabled = YES;
    [self offLineButtonsEnabled];
    if(isHistoryChecked&&isHistoryCheckedWithoutStr)
    {
        m_buttonEdit.enabled = NO;
        m_buttonTranslate.enabled = NO;
    }
    return YES;
}
- (BOOL)stopPlayButtonTouch:(UIButton *)sender
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [m_audioPlayer stopAudio:m_audioInfo];
    [m_audioPlayer closeAudio:m_audioInfo];
    [m_textView resetTextViewAlpha];
    [m_viewAnimation changeViewLightness:m_soundWaveView alpha:0.f duration:0.f completion:^{}];
    
    m_buttonPlay.enabled = NO;
    [m_switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(stopPlayButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(playButtonTouch:)
                                          withTarget:self];

    [m_viewAnimation removeAnimationFromLayer:m_CDCoverView.layer forKey:kAnimationDarknessName];
    [self brightenCDCoverView];

    [self darkenCDInnerImageViewLightness: ^{
        [self stopPlayButtonTouchButtonEnabled];
    } withButton:sender];
    return YES;
}

#pragma mark - 编辑按钮相关操作

- (NSString*)getEditFilePath
{
    NSString *path;
    if(!isHistoryChecked)
        path = [m_filePath stringByAppendingString:@".data"];
    if(isHistoryChecked)
    {
        path = [sandBoxOperation getDocumentPath];
        path = [path stringByAppendingPathComponent:m_currentFileName];
        path = [path stringByAppendingString:@".data"];
    }
    return path;
}
- (BOOL)editButtonTouch:(UIButton *)sender
{
    EditViewController *editViewController = [[EditViewController alloc] initWithData:m_dataProcessing];
    [editViewController setEditCompleteCallBack:self :@selector(editSave:)];
    NSString *path = [self getEditFilePath];
    [editViewController setSavePath:path];
    [editViewController setTextViewScroll:m_textView];
    [self.navigationController pushViewController:editViewController animated:YES];    
    return YES;
}

#pragma mark - 开始识别按钮操作
- (BOOL)createAlertView :(NSString*)title :(NSString*)message :(id)delegate :(NSString*)cancelBtnTitle :(NSString*)otherBtnTitle
{
   UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelBtnTitle otherButtonTitles:otherBtnTitle, nil];
    [alertView show];
    return YES;
}
- (void)startRecogniseButtonTouch:(UIButton *)sender
{
    //isOffLine = YES;
    CheckNetStatus *checkNetStatus = [[CheckNetStatus alloc]init];
    int backCode = [checkNetStatus isInWIFI];
    if(backCode == NotReachable)
        [self createAlertView:@"提示" :@"当前网络离线，不能进行语音识别" :self :nil :@"确定"];
    if(backCode == ReachableViaWWAN)
        [self createAlertView:@"提示" :@"当前网络处在3G模式，需要用您的流量" :self :@"不允许" :@"允许"];
    if(backCode == ReachableViaWiFi)
    {
        [self createAlertView:@"提示" :@"当前网络处在WIFI模式，允许识别么？" :self :@"不允许" :@"允许"];
//        [self startRecognise:sender :YES];
//        isOffLine = NO;
    }
        
}
- (BOOL)startRecognizeButtonsEnabled
{
    m_buttonStart.enabled = NO;
    m_buttonEdit.enabled = NO;
    m_buttonPlay.enabled = NO;
    m_buttonTranslate.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}
- (NSString*)createCurrentDateTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
- (BOOL)startRecognise:(UIButton *)sender :(BOOL)isRecognize
{
    [self startRecognizeButtonsEnabled];
    isHistoryChecked = NO;
    [m_dataProcessing clearDicData];
    [self senderActionSwitch:sender :@selector(startRecogniseButtonTouch:) :@selector(stopRecogniseButtonTouch:)];
    
    [m_viewAnimation removeAnimationFromLayer:m_CDCoverView.layer forKey:kAnimationDarknessName];
    [self changeCDImageViewFrame:sender completion:^{}];
    NSString *dateTime = [self createCurrentDateTimeString];
    m_currentFileName = dateTime;
    
    m_filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    m_filePath = [m_filePath stringByAppendingPathComponent:dateTime];
    
    [self createRecognization:isRecognize :dateTime];
    m_soundWaveView.alpha = 1.0;
    [m_textView clearLastRecognition];
    [m_textView resetPosition];
    [m_dataProcessing clearDicData];
    return YES;
}
#pragma mark - 新建一个识别
- (BOOL)createRecognization :(BOOL)isRecognize :(NSString*)dateTime
{
    m_gooleVoiceRecognizer = [[ASGoogleVoiceRecognizer alloc]init:isRecognize];
    [m_gooleVoiceRecognizer setDelegate:self];
    [m_gooleVoiceRecognizer setFilePath:[NSString stringWithFormat:@"%@.wav",dateTime]];
    [m_gooleVoiceRecognizer startRecording];
    [m_gooleVoiceRecognizer recognizedSuccessCallBack:self andFunction:@selector(speechRecognitionResult:)];
    return YES;
}
#pragma mark - 按钮的Action切换
- (BOOL)senderActionSwitch :(UIButton*)sender :(SEL)oldAction :(SEL)newAction
{
    [m_switchButtonTouchAction switchButtonTouchAction:sender
                                             oldAction:oldAction
                                            withTarget:self
                                             newAction:newAction
                                            withTarget:self];
    return YES;
}

#pragma mark - 停止识别操作

- (BOOL)saveRecognizedStr
{
    NSString *dataFilePath = [[NSString stringWithString:m_filePath] stringByAppendingString:@".data"];
    [m_dataProcessing saveDicToFile:dataFilePath];
    return YES;
}
- (BOOL)recognizedSuccessButtonsEnabled
{
    if(isOffLine)
    {
        m_buttonEdit.enabled = NO;
        m_buttonTranslate.enabled = NO;
        m_buttonPlay.enabled = YES;
    }else
    {
        m_buttonPlay.enabled = YES;
        m_buttonEdit.enabled = YES;
        m_buttonTranslate.enabled = YES;
    }
    return YES;
}
- (BOOL)recognizedUnSuccessButtonsEnabled
{
    if(![sandBoxOperation isContainSpecifiedSuffixFile:@".data"])
        self.navigationItem.rightBarButtonItem.enabled = NO;
    m_buttonPlay.enabled = NO;
    m_buttonEdit.enabled = NO;
    m_buttonTranslate.enabled = NO;
    m_buttonStart.enabled = YES;
    return YES;
}
- (BOOL)darkenCDInnerImageViewComplete :(BOOL)isSuccess
{
    if(!isHistoryBtnDisplay)
        [self displayHistoryButton];
    m_soundWaveView.alpha = 0.0;
    if(isSuccess)
    {
        [self saveRecognizedStr];
        [self recognizedSuccessButtonsEnabled];
    }else
    {
        [self recognizedUnSuccessButtonsEnabled];
    }
    return YES;
}
- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    m_buttonStart.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    BOOL isSuccess = [m_gooleVoiceRecognizer stopRecording];
    [m_textView scrollsToTopWithAnimation];
    [self senderActionSwitch:sender :@selector(stopRecogniseButtonTouch:) :@selector(startRecogniseButtonTouch:)];
    [m_viewAnimation removeAnimationFromLayer:m_CDCoverView.layer forKey:kAnimationDarknessName];
    [self brightenCDCoverView];
    [self darkenCDInnerImageViewLightness:^{
        
        [self darkenCDInnerImageViewComplete:isSuccess];
        
    } withButton:sender];
   
    return YES;
}
#pragma mark - 识别结果的返回
- (BOOL)speechRecognitionResult :(NSDictionary*)postBackDic
{
    NSString *str = [postBackDic objectForKey:recognizedResultDicResult];
    NSNumber *number = [postBackDic objectForKey:recognizedResultDicSoundSize];
    [self addText:str];
    [m_dataProcessing recognizedStrTimestamp:str :[number doubleValue]];
    return YES;
}

#pragma mark - 添加字幕

- (BOOL)addText:(NSString *)text
{
    [m_textView addText:text
          maxLineWidth:kTextMaxLineWidth
              withFont:[UIFont boldSystemFontOfSize:kTextFontSize]
                 color:kTextFontColor
               spacing:kTextRowSpacing];
    return YES;
}

#pragma mark - 封装动画函数

- (BOOL)rotateCDInnerImageView
{
    [m_viewAnimation animationWithLayer:m_CDInnerImageView.layer
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
    [m_viewAnimation changeViewLightness:m_CDInnerImageView alpha:1.0f
                                duration:kImageCDInnerTransformTime
                              completion:^{}];
}
- (void)brightenCDCoverView
{
    [m_viewAnimation animationWithLayer:m_CDCoverView.layer
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
    
    [m_viewAnimation animationWithLayer:m_CDCoverView.layer
                                keypath:kAnimationDarknessKeyPath
                              fromValue:(__bridge id)(m_CDCoverView.backgroundColor.CGColor)
                                toValue:(__bridge id)([UIColor colorWithWhite:kFloatZero
                                                                        alpha:kAnimationDarknessAlpha].CGColor)
                               duration:kAnimationDarknessDuration
                            repeatCount:kAnimationDarknessRepeatCount
                          animationName:kAnimationDarknessName];
}
- (BOOL)darkenCDInnerImageViewLightness:(void(^)(void))finish withButton:(UIButton *)button
{
    [m_viewAnimation changeViewLightness:m_CDInnerImageView alpha:0.f duration:kAnimationDarknessDuration completion:^{
        [m_viewAnimation changeViewFrame:m_CDImageView
                                 toFrame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                                    kImageCDBeforeWidth, kImageCDBeforeHeight)
                            withDuration:kImageCDTransformDuration
                              completion:^{}];
        [m_viewAnimation removeAnimationFromLayer:m_CDInnerImageView.layer forKey:kAnimationRotationName];
        finish();
        button.enabled = YES;
    }];
    return YES;
}
- (BOOL)changeCDImageViewFrame:(UIButton *)button completion:(void(^)(void))completion
{
    [m_viewAnimation changeViewFrame:m_CDImageView
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
    [m_dataProcessing setDictionary:newDictionary];
    [m_textView clearLastRecognition];
    [m_textView resetPosition];
    NSArray *keySet = [m_dataProcessing getKeySet];
    for (NSString *key in keySet)
        [self addText:[newDictionary objectForKey:key]];
}
#pragma mark - 播放录音的委托
- (void)playComplete
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    m_soundWaveView.alpha = 0.f;
    [self stopPlayButtonTouch:m_buttonPlay];
    [m_textView playComplete];
}
- (void)receivePlayData:(NSDictionary *)voiceData
{
    if(!isOffLine)
        [m_textView receivePlayData];
}
#pragma mark - 历史纪录弹出
- (BOOL)popHistoryViewButtonsEnabled :(NSArray*)recognizedStrArray
{
    if(recognizedStrArray.count == 0)
    {
        m_buttonPlay.enabled = YES;
        m_buttonStart.enabled = YES;
        m_buttonEdit.enabled = NO;
        m_buttonTranslate.enabled = NO;
        isHistoryCheckedWithoutStr = YES;
    }else
    {
        
        m_buttonPlay.enabled = YES;
        m_buttonEdit.enabled = YES;
        m_buttonTranslate.enabled = YES;
        isHistoryCheckedWithoutStr = NO;
    }
    return YES;
}
- (BOOL)clearTextView
{
    [m_textView clearLastRecognition];
    [m_textView resetPosition];
    [m_textView playInit];
    return YES;
}
- (BOOL)addStrToTextView :(NSArray*)recognizedStrArray
{
    for (NSString *str in recognizedStrArray)
    {
        [self addText:str];
    }
    return YES;
}
- (NSString*)getPopHistoryViewFilePath :(NSDictionary*)dic
{
    NSString *doc = [sandBoxOperation getDocumentPath];
    NSString *currentFileName = [dic objectForKey:popHistoryViewDicFileName];
    doc = [doc stringByAppendingPathComponent:currentFileName];
    doc = [doc stringByAppendingString:dataFileExtension];
    return doc;
}
- (NSMutableArray*)getRecordKeySet :(NSDictionary*)historyRecordDic
{
    NSMutableArray *noSqueneceKeyset = [[NSMutableArray alloc]init];
    for (NSString *key in [historyRecordDic keyEnumerator])
        [noSqueneceKeyset addObject:key];
    return noSqueneceKeyset;
}
- (void)popHistoryView :(NSMutableDictionary*)dic
{
    NSArray *recognizedStrArray = [dic objectForKey:popHistoryViewDicStrArray];
    isHistoryChecked = YES;
    [self popHistoryViewButtonsEnabled:recognizedStrArray];
    [self clearTextView];
    [self addStrToTextView:recognizedStrArray];
    NSString *doc =[self getPopHistoryViewFilePath:dic];
    NSMutableDictionary *historyRecordDic = [[NSMutableDictionary alloc]initWithContentsOfFile:doc];
    [m_dataProcessing setDictionary:historyRecordDic];
    NSMutableArray *noSqueneceKeyset = [self getRecordKeySet:historyRecordDic];
    NSArray *squeneceKeySet = [m_dataProcessing timestampSequence:noSqueneceKeyset];
    [m_textView setSubtitleKey:squeneceKeySet];
    m_currentFileName = [dic objectForKey:popHistoryViewDicFileName];
}

#pragma mark - alertView的delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self startRecognise:m_buttonStart :NO];
        isOffLine = YES;
    }
        
    if (buttonIndex == 1)
    {
        [self startRecognise:m_buttonStart :YES];
        isOffLine = NO;
    }
        
}
@end
