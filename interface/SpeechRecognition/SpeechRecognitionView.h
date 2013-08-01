//
//  RootView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechRecognitionView : UIView

- (id)initWithFrame:(CGRect)frame delegate:(id)target;

// 开始和停止识别的动画
- (BOOL)startRecogniseButtonTouchAnimation:(UIButton *)button;
- (BOOL)stopRecogniseButtonTouchAnimation:(UIButton *)button;

// 添加要显示的文本
- (BOOL)addText:(NSString *)text;

// 切换按钮的响应方法
- (BOOL)switchButton:(UIButton *)button
           oldAction:(SEL)oldAction
          withTarget:(id)oldTarget
           newAction:(SEL)newAction
          withTarget:(id)newTarget;

@end
