//
//  RootView.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//
#import "SpeechRecognitionView.h"
#import "SpeechRecognitionAnimation.h"
#import "RecogniseButton.h"
#import "SpeechRecognitionTextView.h"
#import "data.h"

@interface SpeechRecognitionView ()
{
    // 大的CD图片的view
    UIImageView *_CDImageView;
    
    // 覆盖在CD图片上的view
    UIView *_CDCoverView;
    
    // 小的CD图片（旋转）
    UIImageView *_CDInnerImageView;
    
    // 文字显示
    SpeechRecognitionTextView *_textView;
}

@end

@implementation SpeechRecognitionView

- (id)initWithFrame:(CGRect)frame delegate:(id)target
{
    self = [super initWithFrame:frame];
    if (self)
    {                
        [self addImageWithName:kImageBackground
                         frame:CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight)];
        
        _CDImageView = [self addImageWithName:kImageCD
                                        frame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                                         kImageCDBeforeWidth, kImageCDBeforeHeight)];
        // 语音识别按钮
        [self addButtonWithTitle:kButtonStartRecogniseTitle
                      imageNamed:kImageRecognise
                            rect:CGRectMake(kButtonRecogniseX, kButtonRecogniseY,
                                            kButtonRecogniseWidth, kButtonRecogniseHeight)
                        delegate:target
                          action:@selector(startRecogniseButtonTouch:)];
    }
    return self;
}

#pragma mark - 变暗动画

- (BOOL)animationBrightnessDark
{

    if (!_CDCoverView)
    {
        _CDCoverView = [[UIView alloc] initWithFrame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                                                kImageCDAfterWidth, kImageCDAfterHeight)];
        _CDCoverView.backgroundColor = [UIColor colorWithWhite:kFloatZero alpha:kFloatZero];
        [self addSubview:_CDCoverView];
    }
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationWithLayer:_CDCoverView.layer
                          keypath:kAnimationDarknessKeyPath
                        fromValue:(__bridge id)(_CDCoverView.backgroundColor.CGColor)
                          toValue:(__bridge id)([UIColor colorWithWhite:kFloatZero
                                                                  alpha:kAnimationDarknessAlpha].CGColor)
                         duration:kAnimationDarknessDuration
                      repeatCount:kAnimationDarknessRepeatCount
                    animationName:kAnimationDarknessName];
    return YES;
}

- (BOOL)animationBrightnessLight
{
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationWithLayer:_CDCoverView.layer
                          keypath:kAnimationDarknessKeyPath
                        fromValue:(__bridge id)([UIColor colorWithWhite:kFloatZero
                                                                  alpha:kAnimationDarknessAlpha].CGColor)
                          toValue:(__bridge id)[UIColor clearColor].CGColor
                         duration:kAnimationDarknessDuration
                      repeatCount:kAnimationDarknessRepeatCount
                    animationName:kAnimationDarknessName];
    return YES;
}

#pragma mark - 渐显和旋转动画

- (BOOL)animtionCDInnerRotation
{
    if (!_CDInnerImageView)
    {
        _CDInnerImageView = [self addImageWithName:kImageCDInner
                                frame:CGRectMake(kFloatZero, kFloatZero,
                                                 kImageCDInnerWidth, kImageCDInnerHeight)];
        _CDInnerImageView.alpha = kFloatZero;
        _CDInnerImageView.center = CGPointMake(kImageCDInnerCenterX, kImageCDInnerCenterY);
    }
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
        
    // 逐渐出现动画
    [animation fadeInWithView:_CDInnerImageView
                     duration:kImageCDInnerTransformTime
                   completion:^{}];
        
    // 旋转动画
    [animation animationWithLayer:_CDInnerImageView.layer
                          keypath:kAnimationRotationKeyPath
                        fromValue:[NSNumber numberWithFloat:kFloatZero]
                          toValue:[NSNumber numberWithFloat:k2PI]
                         duration:kAnimationRotationSpeed
                      repeatCount:kAnimationRotationRepeatCount
                    animationName:kAnimationRotationName];
    return YES;
}

#pragma mark - 移动动画

- (BOOL)animationTransformAfterCompletion:(void(^)(void))completion
{
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation transformView:_CDImageView
                     toFrame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                        kImageCDAfterWidth, kImageCDAfterHeight)
                withDuration:kImageCDTransformDuration
                  completion:^{
                      completion();
                  }];
    return YES;
}

- (BOOL)animationTransformBefore
{
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation transformView:_CDImageView
                     toFrame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY,
                                        kImageCDBeforeWidth, kImageCDBeforeHeight)
                withDuration:kImageCDTransformDuration
                  completion:^{}];
    return YES;
}

#pragma mark - 私有方法

// 用指定rect创建imageView，并向其中添加指定图片，并添加到self中
- (UIImageView *)addImageWithName:(NSString *)name frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    [self addSubview:imageView];
    return imageView;
}

// 创建一个按钮，并添加到self中
- (UIButton *) addButtonWithTitle:(NSString *)title
                       imageNamed:(NSString *)name
                             rect:(CGRect)rect
                         delegate:(id)delegate
                           action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    
    return button;
}

#pragma mark - 公开方法

- (BOOL)startRecogniseButtonTouchAnimation:(UIButton *)button
{
    [button setEnabled:NO];
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationRemoveFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    
    [self animationTransformAfterCompletion:^{
        [self animationBrightnessDark];
        [self animtionCDInnerRotation];
        [button setEnabled:YES];
    }];
    return YES;
}

- (BOOL)stopRecogniseButtonTouchAnimation:(UIButton *)button
{
    [button setEnabled:NO];
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationRemoveFromLayer:_CDCoverView.layer forKey:kAnimationDarknessName];
    
    [self animationBrightnessLight];
    [animation fadeOutWithView:_CDInnerImageView duration:kAnimationDarknessDuration completion:^{
        [self animationTransformBefore];
        [animation animationRemoveFromLayer:_CDInnerImageView.layer forKey:kAnimationRotationName];
        [button setEnabled:YES];
    }];
    
    return YES;
}

- (BOOL)addText:(NSString *)text
{
    if (!_textView)
    {
        CGRect frame = CGRectMake(kTextViewX, kTextViewY, kTextViewWidth, kTextViewHeight);
        _textView = [[SpeechRecognitionTextView alloc] initWithFrame:frame
                                                             maxRows:kTextRowNumber];
        [self addSubview:_textView];
    }
    [_textView addText:text
          maxLineWidth:kTextMaxLineWidth
              withFont:[UIFont boldSystemFontOfSize:kTextFontSize]
                 color:kTextFontColor
               spacing:kTextRowSpacing];
    return YES;
}

- (BOOL)switchButton:(UIButton *)button
           oldAction:(SEL)oldAction
          withTarget:(id)oldTarget
           newAction:(SEL)newAction
          withTarget:(id)newTarget
{
    [button removeTarget:oldTarget action:oldAction forControlEvents:UIControlEventTouchDown];
    [button addTarget:newTarget action:newAction forControlEvents:UIControlEventTouchDown];
    return YES;
}

@end
