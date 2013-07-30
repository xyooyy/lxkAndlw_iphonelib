//
//  data.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//


// -------- 图片名称 --------
#pragma mark - 图片名称

#define kImageBackground    @"background.png"
#define kImageCDInner       @"CD-inner.png"
#define kImageCD            @"CD.png"
#define kImageEdit          @"edit.png"
#define kImageHistoryButton @"history-button.png"
#define kImageLogoMiddle    @"logo-middle.png"
#define kImageNavBackground @"navbar-bg.png"
#define kImagePlay          @"play.png"
#define kImageRecognise     @"recognise.png"
#define kImageTranslate     @"translate.png"

#pragma mark - 常用大小

#define kFloatZero              0.f
#define kIntZero                0
#define kButtonMargin           2.f
#define kNavigationBarHeight    44.f
#define kStatusBarHeight        20.f
#define kAbsoluteScreenHeight   480.f

#define kScreenWidth    [UIScreen mainScreen].applicationFrame.size.width
#define kScreenHeight   [UIScreen mainScreen].applicationFrame.size.height
#define kScreenSize     [UIScreen mainScreen].applicationFrame.size
#define kScreenFrame    [UIScreen mainScreen].applicationFrame  

// -------- 按钮 --------
#pragma mark - 按钮

// 开始/结束语音识别按钮
#define kButtonRecogniseWidth  78.f
#define kButtonRecogniseHeight 42.f
#define kButtonRecogniseX      1.f
#define kButtonRecogniseY      (kScreenHeight - kNavigationBarHeight - kButtonRecogniseHeight)
#define kButtonStartRecogniseTitle  @"开始识别"
#define kButtonStopRecogniseTitle   @"停止识别"

#define kImageRecogniseWidth    28.f
#define kImageRecogniseHeight   21.f
#define kImageRecogniseX        ((kButtonRecogniseWidth - kImageRecogniseWidth) / 2.f)
#define kImageRecogniseY        3.f

#define kLabelRecogniseWidth    kButtonRecogniseWidth
#define kLabelRecogniseHeight   (kButtonRecogniseHeight - kImageRecogniseHeight)
#define kLabelRecogniseX        0.f
#define kLabelRecogniseY        kImageRecogniseHeight

// 编辑按钮
#define kButtonEditWidth    kButtonRecogniseWidth
#define kButtonEditHeight   kButtonRecogniseHeight
#define kButtonEditX        (kButtonRecogniseX + kButtonRecogniseWidth + kButtonMargin)
#define kButtonEditY        kButtonRecogniseY
#define kButtonEditTitle    @"编辑"

// 播放按钮
#define kButtonPlayWidth    kButtonRecogniseWidth
#define kButtonPlayHeight   kButtonRecogniseHeight
#define kButtonPlayX        (kButtonEditX + kButtonRecogniseWidth + kButtonMargin)
#define kButtonPlayY        kButtonRecogniseY
#define kButtonPlayTitle    @"播放"

// 翻译按钮
#define kButtonTranslateWidth   kButtonRecogniseWidth
#define kButtonTranslateHeight  kButtonRecogniseHeight
#define kButtonTranslateX       (kButtonPlayX + kButtonRecogniseWidth + kButtonMargin)
#define kButtonTranslateY       kButtonRecogniseY
#define kButtonTranslateTitle   @"中英翻译"

// 查看历史按钮
#define kButtonHistoryWidth     70.f
#define kButtonHistoryHeight    29.f
#define kButtonHistoryX         240.f
#define kButtonHistoryY         8.f
#define kButtonHisrotyTitle     @"查看历史"

// -------- 普通图片 --------
#pragma mark - 普通图片

// CD图片
#define kImageCDBeforeWidth  350.f
#define kImageCDBeforeHeight kImageCDBeforeWidth
#define kImageCDBeforeX      -125.f
#define kImageCDBeforeY      -93.f

#define kImageCDAfterWidth   380.f
#define kImageCDAfterHeight  kImageCDAfterWidth
#define kImageCDAfterX       -95.f
#define kImageCDAfterY       -115.f

// CD-inner图片
#define kImageCDInnerTransformTime  3.f
#define kImageCDInnerOpacity        1.f
#define kImageCDInnerRotationalSpeed 10.f

#define kImageCDInnerWidth      112.f
#define kImageCDInnerHeight     kImageCDInnerWidth
#define kImageCDInnerCenterX    95.f
#define kImageCDInnerCenterY    75.f

// -------- 动画 --------
#pragma mark - 动画

// 移动
#define kImageCDTransformDuration       1.f

// 旋转
#define k2PI                            (2.f * M_PI)
#define kAnimationRotationKeyPath       @"transform.rotation.z"
#define kAnimationRotationName          @"rotationAnimation"
#define kAnimationRotationSpeed         2.f     // 转一圈所需的时间
#define kAnimationRotationRepeatCount   1000.f  // 一次最多转得圈数

#define kAnimationDarknessKeyPath       @"backgroundColor"
#define kAnimationDarknessName          @"darkness"
#define kAnimationDarknessDuration      1.f
#define kAnimationDarknessRepeatCount   1.f
#define kAnimationDarknessAlpha         0.4f

// -------- tag标记 --------
enum ViewTag
{
    kImageViewCDTag = 1,
    kImageViewCDInnerTag,
    kViewCDCoverTag
};