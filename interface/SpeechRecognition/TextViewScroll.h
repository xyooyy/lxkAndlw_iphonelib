//
//  TextViewScroll.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-7.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewAnimation.h"

@interface TextViewScroll : UIScrollView
{
    NSMutableArray *_viewArray;
    NSUInteger _maxRow;
    CGFloat _height;
    UIViewAnimation *_viewAnimation;
    double moveStep;
    int viewCount;
    NSTimer *moveTimer;
}
- (id)initWithFrame:(CGRect)frame maxRows:(NSUInteger)number;

- (BOOL)addText:(NSString *)text
   maxLineWidth:(NSUInteger)maxWidth
       withFont:(UIFont *)font
          color:(UIColor *)color
        spacing:(CGFloat)spacing;
- (BOOL)clearLastRecognition;
- (BOOL)resetPosition;
- (BOOL)clearData;
- (BOOL)scrollsToTopWithAnimation;
- (BOOL)scrollsSubTitle :(double)duration;

@end
