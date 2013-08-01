//
//  SpeechRecognitionTextView.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-30.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SpeechRecognitionTextView.h"
#import "SpeechRecognitionAnimation.h"
#import "TextToImage.h"
#import "data.h"

@interface SpeechRecognitionTextView ()
{
    NSMutableArray *_viewArray;
    NSUInteger _maxRow;
}

@end

@implementation SpeechRecognitionTextView

- (id)initWithFrame:(CGRect)frame maxRows:(NSUInteger)number
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewArray = [[NSMutableArray alloc] init];
        _maxRow = number;
        [self setBackgroundColor:[UIColor clearColor]];
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
    [self addViewArray:_viewArray withTextArray:textArray andFont:font color:color spacing:spacing];
    [self animationWithViewArray:_viewArray];
    
    return YES;
}

#pragma mark - 内部函数

// 动画显示出添加好的imageView
- (BOOL)animationWithViewArray:(NSMutableArray *)viewArray
{
    for (int i = 0; i < viewArray.count; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
        
        // 移动动画
        [animation transformView:view
                         toFrame:CGRectMake(view.frame.origin.x,
                                            view.frame.size.height * i,
                                            view.frame.size.width,
                                            view.frame.size.height)
                    withDuration:kTextAnimationMoveTime
                      completion:^{}];
        
        // 渐显动画
        [animation fadeInWithView:view duration:kTextAnimationFadeInTime completion:^{}];
    }
    return YES;
}

// 删除指定的view
- (BOOL)removeViewArray:(NSMutableArray *)viewArray range:(NSRange)range
{
    for (int i = 0; i < range.length; i++)
    {
        UIView *view = [viewArray objectAtIndex:range.location];
        SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
        
        // 移动动画
        [animation transformView:view
                         toFrame:CGRectMake(view.frame.origin.x,
                                            kFloatZero,
                                            view.frame.size.width,
                                            view.frame.size.height)
                    withDuration:kTextAnimationMoveTime
                      completion:^{}];
        
        // 渐隐动画
        [animation fadeOutWithView:view duration:kTextAnimationFadeOutTime completion:^{
            [view removeFromSuperview];
        }];
        
        [viewArray removeObjectAtIndex:range.location];
    }
    return YES;
}

// 根据text生成的image,添加新的imageView
- (BOOL)addViewArray:(NSMutableArray *)viewArray
       withTextArray:(NSArray *)textArray
             andFont:(UIFont *)font
               color:(UIColor *)color
             spacing:(CGFloat)spacing
{
    TextToImage *textToImage = [[TextToImage alloc] init];
    
    for (int i = 0; i < textArray.count; i++)
    {
        UIImage *image = [textToImage imageFromText:[textArray objectAtIndex:i]
                                           withFont:font
                                              color:color
                                         rowSpacing:spacing];
        
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = CGRectMake((self.frame.size.width - view.frame.size.width) / 2.f,
                                self.frame.size.height,
                                view.frame.size.width,
                                view.frame.size.height);
        view.alpha = kFloatZero;
        [viewArray addObject:view];
        [self addSubview:view];
    }
    
    return YES;
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

@end
