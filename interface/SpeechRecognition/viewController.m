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

@interface viewController ()
{
    TextView *_textView;
    SoundWaveView *_soundWaveView;
    UIViewAnimation *m_viewAnimation;
    
    ASGoogleVoiceRecognizer *gooleVoiceRecognizer;
    
    LayoutMainController *layout;

    UIImageView *_CDImageView;
    UIView *_CDCoverView;
    UIImageView *_CDInnerImageView;
    
    UIButton *buttonStart;
   
}

@end

@implementation viewController

#pragma mark-初始化用到的函数
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
- (BOOL)createStartButton
{
    buttonStart = [[UIButton alloc]initWithFrame:CGRectMake(kButtonRecogniseX, kButtonRecogniseY,
                                                            kButtonRecogniseWidth, kButtonRecogniseHeight)];
    [buttonStart setBackgroundImage:[UIImage imageNamed:kImageRecognise] forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(startRecogniseButtonTouch:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:buttonStart];
    return YES;
}
#pragma mark-init函数

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight);
    
    
    [self addImageWithName:kImageBackground
                     frame:CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight)];
    
    [self createCDImageView];
    [self createCDCoverView:frame];
    [self createInnerImageView];
    [self createSwitchButtonTouchActionMember];
    
    
    _soundWaveView = [[SoundWaveView alloc] initWithFrame:frame];

    _textView = [[TextView alloc] initWithFrame:CGRectMake(kTextViewX, kTextViewY, kTextViewWidth, kTextViewHeight)
                                        maxRows:kTextRowNumber];
    m_viewAnimation = [[UIViewAnimation alloc]init];
    
    gooleVoiceRecognizer = [[ASGoogleVoiceRecognizer alloc]init];
    [gooleVoiceRecognizer setDelegate:self];
    layout = [[LayoutMainController alloc]initWithLayoutView:self.view];
    translate = [[TranslateRecognizeResult alloc]initWithData:nil :nil];
    dataProcessing = [[DataProcessing alloc]init];
    
    [self.view addSubview:_textView];
    [self.view addSubview:_soundWaveView];
    [self createStartButton];
}

#pragma mark- 查看历史纪录

-(void)checkHistoryRecord
{
    HistoryViewController *historyController = [[HistoryViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:historyController animated:YES];
}

- (BOOL)googleVoiceSoundStrong:(NSUInteger)soundStrong
{
    [_soundWaveView addSoundStrong:soundStrong];
    return YES;
}

- (BOOL)startRecogniseButtonTouch:(UIButton *)sender
{
    buttonStart.enabled = NO;
    self.navigationItem.rightBarButtonItem = nil;
    [switchButtonTouchAction switchButtonTouchAction:sender
             oldAction:@selector(startRecogniseButtonTouch:)
            withTarget:self
             newAction:@selector(stopRecogniseButtonTouch:)
            withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self beginStartAnimation];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:dateTime];
    filePath = [filePath stringByAppendingFormat:@".data"];
    
    [gooleVoiceRecognizer setFilePath:[NSString stringWithFormat:@"%@.wav",dateTime]];
    [gooleVoiceRecognizer startRecording];
    [gooleVoiceRecognizer setController:self andFunction:@selector(speechRecognitionResult:)];
    return YES;
}
- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    [switchButtonTouchAction switchButtonTouchAction:sender
                                           oldAction:@selector(stopRecogniseButtonTouch:)
                                          withTarget:self
                                           newAction:@selector(startRecogniseButtonTouch:)
                                          withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self brightenCDCoverView];
    [self beginStopAnimation:^{
        NSArray *copyData = [NSArray arrayWithArray:[dataProcessing getRecognizedData]];
        [copyData writeToFile:filePath atomically:YES];
        [[dataProcessing getRecognizedData] removeAllObjects];
        UIBarButtonItem *barButtontem = [[UIBarButtonItem alloc]initWithTitle:@"历史纪录" style:UIBarButtonItemStyleBordered target:self action:@selector(checkHistoryRecord)];
        self.navigationItem.rightBarButtonItem = barButtontem;
        //CurrentDataViewController *dataViewController = [[CurrentDataViewController alloc]initWithData:copyData];
        //[self.navigationController pushViewController:dataViewController animated:YES];
    }];
   
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
- (BOOL)beginStopAnimation:(void(^)(void)) finish
{
    [m_viewAnimation changeViewLightness:_CDInnerImageView alpha:0.f duration:kAnimationDarknessDuration completion:^{
        [m_viewAnimation changeViewFrame:_CDImageView
                                 toFrame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                                    kImageCDBeforeWidth, kImageCDBeforeHeight)
                            withDuration:kImageCDTransformDuration
                              completion:^{}];
        [m_viewAnimation removeAnimationFromLayer:_CDInnerImageView.layer forKey:kAnimationRotationName];
        [gooleVoiceRecognizer stopRecording];
        finish();
        [buttonStart setEnabled:YES];
    }];
    return YES;
}
- (BOOL)beginStartAnimation
{
    [m_viewAnimation changeViewFrame:_CDImageView
                             toFrame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                                kImageCDAfterWidth, kImageCDAfterHeight)
                        withDuration:kImageCDTransformDuration
                          completion:^{
                              [self darkenCDCoverView];
                              [self brightenCDInnerImageView];
                              [self rotateCDInnerImageView];
                              buttonStart.enabled = YES;
                          }];
    return YES;
}
@end
