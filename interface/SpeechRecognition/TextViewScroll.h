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
    NSUInteger _maxRow;
    CGFloat _height;
    UIViewAnimation *_viewAnimation;
    double moveStep;
    int viewCount;
    double _duration;
    NSArray *keyArray;
    
    UIView *lastView;
    
    BOOL flag;
    int scrollCount;
    int scrollIndex;
    
}
- (id)initWithFrame:(CGRect)frame maxRows:(NSUInteger)number;

- (BOOL)addText:(NSString *)text
   maxLineWidth:(NSUInteger)maxWidth
       withFont:(UIFont *)font
          color:(UIColor *)color
        spacing:(CGFloat)spacing;
- (BOOL)clearLastRecognition;
- (BOOL)resetPosition;
- (BOOL)scrollsToTopWithAnimation;

- (BOOL)setSubtitleKey :(NSArray*)keyArray;
- (BOOL)playInit;
-(void)receivePlayData;
-(void)playComplete;


@end
