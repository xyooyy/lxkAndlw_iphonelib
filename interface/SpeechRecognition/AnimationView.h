//
//  RootView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView

// 开始和停止识别的动画
- (BOOL)startRecogniseAnimation:(UIButton *)button;
- (BOOL)stopRecogniseAnimation:(UIButton *)button;

@end
