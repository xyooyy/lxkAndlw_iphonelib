//
//  TextViewScroll.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-7.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewAnimation.h"
#import "ASPlayDelegate.h"

@interface TextViewScroll : UIScrollView<ASPlayDelegate>
{
    NSMutableArray *_viewArray;
    NSMutableArray *_viewArrayValue;
    NSMutableDictionary *ViewToImageDic;
    NSUInteger _maxRow;
    CGFloat _height;
    UIViewAnimation *_viewAnimation;
    double moveStep;
    int viewCount;
    double _duration;
    id obj;
    SEL action;
    
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
- (BOOL)scrollsSubTitle:(NSDictionary*)StrToTimeDic :(NSInteger)totalLength :(double)duration;

- (BOOL)clearView;
- (BOOL)setPlayCompleteCallBack :(id)parmObj :(SEL)parmAction;

@end
