//
//  MainView.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-1.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "ControlsView.h"
#import "Data.h"

@implementation ControlsView

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 语音识别按钮
        [self addButtonWithTitle:kButtonStartRecogniseTitle
                      imageNamed:kImageRecognise
                            rect:CGRectMake(kButtonRecogniseX, kButtonRecogniseY,
                                            kButtonRecogniseWidth, kButtonRecogniseHeight)
                        delegate:delegate
                          action:@selector(startRecogniseButtonTouch:)];
    }
    return self;
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

#pragma mark - 内部函数

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


@end
