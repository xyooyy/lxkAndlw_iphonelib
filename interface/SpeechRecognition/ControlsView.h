//
//  MainView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-1.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlsView : UIView

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

// 切换按钮的响应方法
- (BOOL)switchButton:(UIButton *)button
           oldAction:(SEL)oldAction
          withTarget:(id)oldTarget
           newAction:(SEL)newAction
          withTarget:(id)newTarget;

@end
