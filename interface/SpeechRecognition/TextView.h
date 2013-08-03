//
//  SpeechRecognitionTextView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-30.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UIView

- (id)initWithFrame:(CGRect)frame maxRows:(NSUInteger)number;

- (BOOL)addText:(NSString *)text
   maxLineWidth:(NSUInteger)maxWidth
       withFont:(UIFont *)font
          color:(UIColor *)color
        spacing:(CGFloat)spacing;

@end
