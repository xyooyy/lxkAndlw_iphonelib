//
//  SpeechRecognitionTextView.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-30.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "TextView.h"
#import "TextToImage.h"
#import "Data.h"
#import "UIViewAnimation.h"

@interface TextView ()
{
    NSMutableArray *_viewArray;
    NSUInteger _maxRow;
    CGFloat _height;
    UIViewAnimation *_viewAnimation;
    NSMutableArray *allTextView;
}

@end

@implementation TextView

- (id)initWithFrame:(CGRect)frame maxRows:(NSUInteger)number
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewArray = [[NSMutableArray alloc] init];
        _maxRow = number;
        _viewAnimation = [[UIViewAnimation alloc] init];
        allTextView = [[NSMutableArray alloc]init];
        [self setBackgroundColor:[UIColor clearColor]];
        UISwipeGestureRecognizer *recognizer;
        
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipUp)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self  addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDown)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self  addGestureRecognizer:recognizer];
    }
    return self;
}

- (BOOL)addText:(NSString *)text
   maxLineWidth:(NSUInteger)maxWidth
       withFont:(UIFont *)font
          color:(UIColor *)color
        spacing:(CGFloat)spacing
{
    NSArray *textArray = [self lineBreakWithString:text maxWidth:maxWidth font:font];

    if (textArray.count + _viewArray.count > _maxRow)
    {
        [self removeViewArray:_viewArray
                        range:NSMakeRange(kIntZero, (textArray.count + _viewArray.count) - _maxRow)];
    }
    CGRect rect = [self addViewArray:_viewArray withTextArray:textArray andFont:font color:color spacing:spacing];
    [self animationWithViewArray:_viewArray toRect:rect];
    
    return YES;
}

#pragma mark - 内部函数

// 动画显示出添加好的imageView
- (BOOL)animationWithViewArray:(NSMutableArray *)viewArray toRect:(CGRect)rect
{
    for (int i = 0; i < viewArray.count; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        [_viewAnimation changeViewFrame:view
                                toFrame:CGRectMake(view.frame.origin.x,
                                                   rect.size.height * i,
                                                   view.frame.size.width,
                                                   rect.size.height)
                           withDuration:kTextAnimationMoveTime
                             completion:^{}];
        
        [_viewAnimation changeViewLightness:view
                                      alpha:1.f
                                   duration:kTextAnimationFadeInTime
                                 completion:^{}];
    }
    return YES;
}

// 删除指定的view
- (BOOL)removeViewArray:(NSMutableArray *)viewArray range:(NSRange)range
{

    for (int i = 0; i < range.length; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        
        [_viewAnimation changeViewFrame:view
                                toFrame:CGRectMake((int)self.frame.size.width,
                                                   kFloatZero,
                                                   view.frame.size.width,
                                                   kFloatZero)
                           withDuration:kTextAnimationMoveTime
                             completion:^{}];
             
        [_viewAnimation changeViewLightness:view
                                      alpha:0.f
                                   duration:kTextAnimationFadeOutTime
                                 completion:^{
                                     [view removeFromSuperview];
                                 }];
        
        [viewArray removeObjectAtIndex:i];
    }
    return YES;
}

// 根据text生成的image,添加新的imageView
// 返回的事生成的image的实际大小
- (CGRect)addViewArray:(NSMutableArray *)viewArray
       withTextArray:(NSArray *)textArray
             andFont:(UIFont *)font
               color:(UIColor *)color
             spacing:(CGFloat)spacing
{
    TextToImage *textToImage = [[TextToImage alloc] init];
    CGRect rect;
    for (int i = 0; i < textArray.count; i++)
    {
        UIImage *image = [textToImage imageFromText:[textArray objectAtIndex:i]
                                           withFont:font
                                              color:color
                                         rowSpacing:spacing];
        
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        rect = view.frame;
        view.frame = CGRectMake((self.frame.size.width - view.frame.size.width) / 2.f,
                                self.frame.size.height,
                                view.frame.size.width,
                                kFloatZero);
        view.alpha = kFloatZero;
        [viewArray addObject:view];
        [allTextView addObject:view];
        NSLog(@"allTextView->%d",[allTextView count]);
        [self addSubview:view];
    }
    
    return rect;
}

// 对字符串string根据所给的最大宽度和字体计算折行位置
- (NSArray *)lineBreakWithString:(NSString *)string
                   maxWidth:(NSUInteger)maxWidth
                       font:(UIFont *)font
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
    
    for (int i = 0; i < mutableString.length; ++i)
    {
        if ([[mutableString substringToIndex:i] sizeWithFont:font].width >= maxWidth)
        {
            [mutableArray addObject:[mutableString substringToIndex:i]];
            [mutableString replaceCharactersInRange:NSMakeRange(0, i) withString:@""];
            i = 0;
        }
    }
    
    [mutableArray addObject:mutableString];
    return mutableArray;
}
#pragma mark - swip
- (void)swipDown
{
    NSLog(@"swipDown");
}
- (void)swipUp
{
     NSLog(@"swipUp");
}
@end
