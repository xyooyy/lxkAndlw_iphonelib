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
    NSMutableArray *_currentViewArray;
    UIFont *_font;
    NSUInteger _maxRow;
    
    UIImageView *_imageView;
}

@end

@implementation SpeechRecognitionTextView

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font numberOfRow:(NSUInteger)number
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _currentViewArray = [[NSMutableArray alloc] init];
        _font = font;
        _maxRow = number;
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor redColor];
        [self addSubview:_imageView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

 - (BOOL)addText:(NSString *)text maxLineWidth:(NSUInteger)maxWidth
{
    NSArray *textArray = [self lineBreakWithString:text maxWidth:maxWidth font:_font];

    if (textArray.count + _currentViewArray.count > _maxRow)
    {
        [self removeViewArray:_currentViewArray
                        range:NSMakeRange(kIntZero, (textArray.count + _currentViewArray.count) - _maxRow)];
    }
    [self addViewArray:_currentViewArray withTextArray:textArray];
    [self animationWithViewArray:_currentViewArray];
    [self setNeedsDisplay];
    
    return YES;
}

#pragma mark - 内部函数

- (BOOL)animationWithViewArray:(NSMutableArray *)viewArray
{
    for (int i = 0; i < viewArray.count; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
        [animation transformView:view
                         toFrame:CGRectMake(view.frame.origin.x,
                                            view.frame.size.height * i,
                                            view.frame.size.width,
                                            view.frame.size.height)
                    withDuration:kTextAnimationMoveTime
                      completion:^{}];
        
        [animation fadeInWithView:view duration:kTextAnimationFadeInTime completion:^{}];
    }
    return YES;
}

// 删除指定的view
- (BOOL)removeViewArray:(NSMutableArray *)viewArray range:(NSRange)range
{
    NSUInteger end = MIN(range.location + range.length, viewArray.count);
    for (int i = range.location; i < end; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        
        SpeechRecognitionAnimation *animation = [[SpeechRecognitionAnimation alloc] init];
        [animation fadeOutWithView:view duration:kTextAnimationFadeOutTime completion:^{
            [view removeFromSuperview];
        }];
        [viewArray removeObjectAtIndex:i];
    }
    return YES;
}

- (BOOL)addViewArray:(NSMutableArray *)viewArray withTextArray:(NSArray *)textArray
{
    TextToImage *textToImage = [[TextToImage alloc] init];
    
    for (int i = 0; i < textArray.count; i++)
    {
        UIImage *image = [textToImage imageFromText:[textArray objectAtIndex:i]
                                           withFont:_font
                                              color:[UIColor whiteColor]
                                         rowSpacing:kTextRowSpacing];
        
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
