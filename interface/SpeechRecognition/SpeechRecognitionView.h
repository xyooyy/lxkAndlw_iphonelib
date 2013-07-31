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

- (BOOL)startRecogniseButtonTouchAnimation:(UIButton *)button;
- (BOOL)stopRecogniseButtonTouchAnimation:(UIButton *)button;

- (BOOL)addText:(NSString *)text;

@end
