//
//  RootViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "viewController.h"
#import "AnimationView.h"
#import "TextView.h"
#import "SoundWaveView.h"
#import "ControlsView.h"
#import "Data.h"

@interface viewController ()
{
    // 文字显示层
    TextView *_textView;
    
    // 声波显示层
    SoundWaveView *_soundWaveView;
    
    // 动画显示层
    AnimationView *_animationView;
    
    // 控件层
    ControlsView *_controlsView;
}

@end

@implementation viewController

- (id)init
{
    self = [super init];
    if (self)
    {
        CGRect frame = CGRectMake(kFloatZero, kFloatZero, kScreenWidth, kScreenHeight);
        
        _animationView = [[AnimationView alloc] initWithFrame:frame];
        _soundWaveView = [[SoundWaveView alloc] initWithFrame:frame];
        _controlsView = [[ControlsView alloc] initWithFrame:frame andDelegate:self];
        _textView = [[TextView alloc] initWithFrame:CGRectMake(kTextViewX, kTextViewY, kTextViewWidth, kTextViewHeight)
                                            maxRows:kTextRowNumber];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:_animationView];
    [self.view addSubview:_textView];
    [self.view addSubview:_soundWaveView];
    [self.view addSubview:_controlsView];
}

- (BOOL)startRecogniseButtonTouch:(UIButton *)sender
{
    [_animationView startRecogniseAnimation:sender];
    
    [_controlsView switchButton:sender
                      oldAction:@selector(startRecogniseButtonTouch:)
                     withTarget:self
                      newAction:@selector(stopRecogniseButtonTouch:)
                     withTarget:self];
    
    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(testText) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(testSound) userInfo:nil repeats:YES];
    return YES;
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

- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    [_animationView stopRecogniseAnimation:sender];
    
    [_controlsView switchButton:sender
                      oldAction:@selector(stopRecogniseButtonTouch:)
                     withTarget:self
                      newAction:@selector(startRecogniseButtonTouch:)
                     withTarget:self];
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

@end
