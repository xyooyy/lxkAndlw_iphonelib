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
#import "data.h"

@interface SpeechRecognitionView ()
{
    // 大的CD图片的view
    UIImageView *_imageViewCD;
    
    // 覆盖在CD图片上的view
    UIView *_viewCDCover;
    
    // 小的CD图片（旋转）
    UIImageView *_imageViewCDInner;
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
        
        _imageViewCD = [self addImageWithName:kImageCD
                                        frame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY, kImageCDBeforeWidth, kImageCDBeforeHeight)];
        
        // 语音识别按钮
        [self addButtonWithTitle:kButtonStartRecogniseTitle
                      imageNamed:kImageRecognise
                            rect:CGRectMake(kButtonRecogniseX, kButtonRecogniseY, kButtonRecogniseWidth, kButtonRecogniseHeight)
                        delegate:target
                          action:@selector(startRecogniseButtonTouch:)];
    }
    return self;
}

#pragma mark - 变暗动画

- (BOOL)animationBrightnessDark
{

    if (!_viewCDCover)
    {
        _viewCDCover = [[UIView alloc] initWithFrame:CGRectMake(kImageCDAfterX, kImageCDAfterY, kImageCDAfterWidth, kImageCDAfterHeight)];
        _viewCDCover.backgroundColor = [UIColor colorWithWhite:kFloatZero alpha:kFloatZero];
        [self addSubview:_viewCDCover];
    }
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationWithLayer:_viewCDCover.layer
                          keypath:kAnimationDarknessKeyPath
                        fromValue:(__bridge id)(_viewCDCover.backgroundColor.CGColor)
                          toValue:(__bridge id)([UIColor colorWithWhite:kFloatZero alpha:kAnimationDarknessAlpha].CGColor)
                         duration:kAnimationDarknessDuration
                      repeatCount:kAnimationDarknessRepeatCount
                    animationName:kAnimationDarknessName];
    
    return YES;
}

- (BOOL)animationBrightnessLight
{
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationWithLayer:_viewCDCover.layer
                          keypath:kAnimationDarknessKeyPath
                        fromValue:(__bridge id)([UIColor colorWithWhite:kFloatZero alpha:kAnimationDarknessAlpha].CGColor)
                          toValue:(__bridge id)[UIColor clearColor].CGColor
                         duration:kAnimationDarknessDuration
                      repeatCount:kAnimationDarknessRepeatCount
                    animationName:kAnimationDarknessName];
    return YES;
}

//- (BOOL)animation

#pragma mark - 渐显和旋转动画

- (BOOL)animtionCDInnerRotation
{
    if (!_imageViewCDInner)
    {
        _imageViewCDInner = [self addImageWithName:kImageCDInner
                                frame:CGRectMake(kFloatZero, kFloatZero, kImageCDInnerWidth, kImageCDInnerHeight)];
        _imageViewCDInner.alpha = kFloatZero;
        _imageViewCDInner.center = CGPointMake(kImageCDInnerCenterX, kImageCDInnerCenterY);
    }
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
        
    // 逐渐出现动画
    [animation fadeInWithView:_imageViewCDInner
                     duration:kImageCDInnerTransformTime
                   completion:^{}];
        
    // 旋转动画
    [animation animationWithLayer:_imageViewCDInner.layer
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
    [animation transformView:_imageViewCD
                     toFrame:CGRectMake(kImageCDAfterX, kImageCDAfterY, kImageCDAfterWidth, kImageCDAfterHeight)
                withDuration:kImageCDTransformDuration
                  completion:^{
                      completion();
                  }];
    return YES;
}

- (BOOL)animationTransformBefore
{
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation transformView:_imageViewCD
                     toFrame:CGRectMake(kImageCDBeforeX, kImageCDBeforeY, kImageCDBeforeWidth, kImageCDBeforeHeight)
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
//    RecogniseButton *button = [[RecogniseButton alloc] initWithFrame:rect];
    RecogniseButton *button = [[RecogniseButton alloc] initWithFrame:rect title:title imageName:name];
//    [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    
    return button;
}

#pragma mark - 公开方法

- (BOOL)startRecogniseButtonTouchAnimation:(UIButton *)button
{
    [button setEnabled:NO];
    
    SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
    [animation animationRemoveFromLayer:_viewCDCover.layer forKey:kAnimationDarknessName];
    
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
    [animation animationRemoveFromLayer:_viewCDCover.layer forKey:kAnimationDarknessName];
    
    [self animationBrightnessLight];
    [animation fadeOutWithView:_imageViewCDInner duration:kAnimationDarknessDuration completion:^{
        [self animationTransformBefore];
        [animation animationRemoveFromLayer:_imageViewCDInner.layer forKey:kAnimationRotationName];
        [button setEnabled:YES];
    }];
    return YES;
}

@end
