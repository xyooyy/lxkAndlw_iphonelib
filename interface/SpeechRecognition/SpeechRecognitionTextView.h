//
//  SpeechRecognitionTextView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-30.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechRecognitionTextView : UIView

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font numberOfRow:(NSUInteger)number;
- (BOOL)addText:(NSString *)text maxLineWidth:(NSUInteger)maxWidth;

@end
