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
#define kImageNavBackground @"navbar-bg.png"
#define kImagePlay          @"play.png"
#define kImageRecognise     @"recognise.png"
#define kImageTranslate     @"translate.png"

#define kImageCompletionButton  @"completion-button.png"
#define kImageCopyButton        @"copy-button.png"
#define kImageSaveButton        @"save-button.png"
#define kImageReturnButton      @"return-button.png"

#define kImageRedCopyButton @"redcopy-button.png"
#define kImageEditButton    @"edit-button.png"
#define kImageBigSaveButton @"big-save-button.png"

#pragma mark - 常用

#define kFloatZero              0.f
#define kIntZero                0
#define kButtonMargin           36.f
#define kNavigationBarHeight    44.f
#define kStatusBarHeight        20.f
#define kAbsoluteScreenHeight   480.f

#define kScreenWidth    [UIScreen mainScreen].applicationFrame.size.width
#define kScreenHeight   [UIScreen mainScreen].applicationFrame.size.height
#define kScreenSize     [UIScreen mainScreen].applicationFrame.size
#define kScreenFrame    [UIScreen mainScreen].applicationFrame  

#define RGBA(r, g, b, a) ([UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a])

// -------- 按钮 --------
#pragma mark - 按钮

// 开始/结束语音识别按钮
#define kButtonRecogniseWidth  50 /*78.f*/
#define kButtonRecogniseHeight 42.f
#define kButtonRecogniseX      1.f
#define kButtonRecogniseY      (kScreenHeight - kNavigationBarHeight - kButtonRecogniseHeight)
#define kButtonStartRecogniseTitle  @"开始识别"
#define kButtonStopRecogniseTitle   @"停止识别"

//#define kImageRecogniseWidth    28.f
//#define kImageRecogniseHeight   21.f
//#define kImageRecogniseX        ((kButtonRecogniseWidth - kImageRecogniseWidth) / 2.f)
//#define kImageRecogniseY        3.f
//
//#define kLabelRecogniseWidth    kButtonRecogniseWidth
//#define kLabelRecogniseHeight   (kButtonRecogniseHeight - kImageRecogniseHeight)
//#define kLabelRecogniseX        0.f
//#define kLabelRecogniseY        kImageRecogniseHeight

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
#define kImageCDInnerTransformTime      3.f
#define kImageCDInnerOpacity            1.f
#define kImageCDInnerRotationalSpeed    10.f

#define kImageCDInnerWidth      112.f
#define kImageCDInnerHeight     kImageCDInnerWidth
#define kImageCDInnerCenterX    95.f
#define kImageCDInnerCenterY    75.f

// -------- 显示识别文字 --------
#pragma mark - 显示识别文字

#define kTextViewWidth          320.f
#define kTextViewHeight         160.f
#define kTextViewX              0.f
#define kTextViewY              120.f

#define kTextFontSize           13.f
#define kTextFontColor          RGBA(255.f, 245.f, 205.f, 1.f)
#define kTextRowNumber          7       // 行数
#define kTextMaxLineWidth       240.f   // 行最大长度
#define kTextRowSpacing         6.f     // 行距
#define kTextAnimationFadeOutTime   1.f
#define kTextAnimationFadeInTime    1.f
#define kTextAnimationMoveTime      1.f

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

#define kSoundWaveStartCGColor    RGBA(153.f, 47.f, 41.f, 1.0f).CGColor
#define kSoundWaveEndCGColor      RGBA(153.f, 47.f, 41.f, 0.0f).CGColor

#pragma mark - 关于录音和播放录音

#define SOUNDSTRONGTH_THRESHOLD 150
#define WAIT_TIME 4
#define SAMPLATE_TIME 1/10.f
#define SAMPLATE_RATE 16000
#define RECORD_BUFFER_SIZE SAMPLATE_TIME*SAMPLATE_RATE*2

#pragma mark - 文件相关操作

static NSString *recognizedResultDicResult = @"result";
static NSString *recognizedResultDicSoundSize = @"soundSize";
static NSString *popHistoryViewDicStrArray = @"str";
static NSString *popHistoryViewDicFileName = @"fileName";
static NSString *dataFileExtension = @".data";

#pragma mark - 编辑页面的布局
#define IPHONE4_SCREEN_HEIGHT 480
#define TABLEVIEW_HEIGHT 350
#define TABLEVIEW_ORG_X 15
#define TABLEVIEW_ORG_Y 15
#define TABLEVIEW_WIDTH 290
#define OPERATON_BTN_ORG_Y 375

#define OPERATION_COPYBTN_ORG_X 15
#define OPERATION_COPYBTN_WIDTH 135
#define OPERATION_COPYBTN_HEIGHT 30

#define OPERATION_SAVEBTN_ORG_X 170
#define OPERATION_SAVEBTN_WIDTH 135
#define OPERATION_SAVEBTN_HEIGHT 30

#define NAVIGATION_BTN_WIDTH 70
#define NAVIGATION_BTN_HEIGHT 29

#pragma mark - 翻页页面按钮布局

#define TEXTVIEW_HRIGHT 350

#pragma mark - 编辑翻译页面布局
#define TEXTVIEW_WIDTH 290
#define TEXTVIEW_ORG_X 15
#define TEXTVIEW_ORG_Y 15
#define COLOR_R 27.f
#define COLOR_G 26.f
#define COLOR_B 24.f
#define COLOR_A 1.f
#define SAVE_BTN_HEIGHT 34



