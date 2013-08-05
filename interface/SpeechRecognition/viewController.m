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

@interface viewController ()
{
    TextView *_textView;
    SoundWaveView *_soundWaveView;
    UIViewAnimation *m_viewAnimation;

    UIImageView *_CDImageView;
    UIView *_CDCoverView;
    UIImageView *_CDInnerImageView;
    
    UIButton *button;
   
}

@end

@implementation viewController

- (UIImageView *)addImageWithName:(NSString *)name frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    [self.view addSubview:imageView];
    return imageView;
}
- (BOOL)createButton
{
    button = [[UIButton alloc] initWithFrame:CGRectMake(kButtonRecogniseX, kButtonRecogniseY,
                                                        kButtonRecogniseWidth, kButtonRecogniseHeight)];
    [button setBackgroundImage:[UIImage imageNamed:kImageRecognise] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startRecogniseButtonTouch:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    return YES;
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
- (id)init
{
    self = [super init];
    if (self)
    {
        CGRect frame = CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight);
        
       
        [self addImageWithName:kImageBackground
                         frame:CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight)];
       
        [self createCDImageView];
        [self createCDCoverView:frame];
        [self createInnerImageView];
        
        
        _soundWaveView = [[SoundWaveView alloc] initWithFrame:frame];
        _textView = [[TextView alloc] initWithFrame:CGRectMake(kTextViewX, kTextViewY, kTextViewWidth, kTextViewHeight)maxRows:kTextRowNumber];
        m_viewAnimation = [[UIViewAnimation alloc]init];
        
        [self.view addSubview:_textView];
        [self.view addSubview:_soundWaveView];
        [self createButton];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)testText
{
    static int number = 0;
    NSArray *array = [NSArray arrayWithObjects:
                      @"google语音识别我阿斯顿发生地df发送到奥迪飞阿斯顿发生地方水电费",
                      @"adflkajdsfhkasdfhkajsdfhjkasdhfkjasdasdfasdf",
                      @"阿士大夫撒旦哈库拉水电费",
                      @"154789123541328947123678969784789", nil];
    [self addText:[array objectAtIndex:(number++ % [array count])]];
}

- (void)testSound
{
    [_soundWaveView addSoundStrong:random() % 500];
}

- (BOOL)switchButton:(UIButton *)parmButton
           oldAction:(SEL)oldAction
          withTarget:(id)oldTarget
           newAction:(SEL)newAction
          withTarget:(id)newTarget
{
    [parmButton removeTarget:oldTarget action:oldAction forControlEvents:UIControlEventTouchDown];
    [parmButton addTarget:newTarget action:newAction forControlEvents:UIControlEventTouchDown];
    return YES;
}
- (BOOL)startRecogniseButtonTouch:(UIButton *)sender
{
    button.enabled = NO;
    [self switchButton:sender
             oldAction:@selector(startRecogniseButtonTouch:)
            withTarget:self
             newAction:@selector(stopRecogniseButtonTouch:)
            withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    [self beginStartAnimation];
   
    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(testText) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(testSound) userInfo:nil repeats:YES];
    NSLog(@"start");
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
                              button.enabled = YES;
                          }];
    return YES;
}
- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
//    [_animationView stopRecogniseAnimation:sender];
//    
    [self switchButton:sender
                      oldAction:@selector(stopRecogniseButtonTouch:)
                     withTarget:self
                      newAction:@selector(startRecogniseButtonTouch:)
                     withTarget:self];
    [m_viewAnimation removeAnimationFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    
    [m_viewAnimation animationWithLayer:_CDCoverView.layer
                          keypath:kAnimationDarknessKeyPath
                        fromValue:(__bridge id)([UIColor colorWithWhite:kFloatZero
                                                                  alpha:kAnimationDarknessAlpha].CGColor)
                          toValue:(__bridge id)[UIColor clearColor].CGColor
                         duration:kAnimationDarknessDuration
                      repeatCount:kAnimationDarknessRepeatCount
                    animationName:kAnimationDarknessName];
    [m_viewAnimation changeViewLightness:_CDInnerImageView alpha:0.f duration:kAnimationDarknessDuration completion:^{
        [m_viewAnimation changeViewFrame:_CDImageView
                                 toFrame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                                    kImageCDBeforeWidth, kImageCDBeforeHeight)
                            withDuration:kImageCDTransformDuration
                              completion:^{}];
        [m_viewAnimation removeAnimationFromLayer:_CDInnerImageView.layer forKey:kAnimationRotationName];
        [button setEnabled:YES];
    }];
     NSLog(@"stop");
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
@end
