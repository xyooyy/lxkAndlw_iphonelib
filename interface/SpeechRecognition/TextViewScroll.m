//
//  TextViewScroll.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-7.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TextViewScroll.h"
#import "TextToImage.h"
#import "Data.h"

@implementation TextViewScroll

- (id)initWithFrame:(CGRect)frame maxRows:(NSUInteger)number
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewArray = [[NSMutableArray alloc] init];
        _viewArrayKey = [[NSMutableArray alloc]init];
        _maxRow = number;
        _viewAnimation = [[UIViewAnimation alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = CGSizeMake(0, 1);
        ViewToImageDic = [[NSMutableDictionary alloc]init];
        viewCount = 0;
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
    
    if (textArray.count + viewCount > _maxRow)
    {
        [self removeViewArray:_viewArray
                        range:NSMakeRange(kIntZero, (textArray.count + viewCount) - _maxRow)];
    }
    NSMutableArray *drawViewArray = [[NSMutableArray alloc]initWithCapacity:2];
    CGRect rect = [self addViewArray:_viewArray withTextArray:textArray andFont:font color:color spacing:spacing needDrawViewArray:drawViewArray];
    [self animationWithViewArray:drawViewArray toRect:rect];
    
    return YES;
}

#pragma mark - 内部函数

// 动画显示出添加好的imageView
- (BOOL)animationWithViewArray:(NSArray *)viewArray toRect:(CGRect)rect
{
    for (int i = 0; i < viewArray.count; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        CGSize size = self.contentSize;
        size.height += rect.size.height;
        self.contentSize = size;
        [_viewAnimation changeViewFrame:view
                                toFrame:CGRectMake(view.frame.origin.x,
                                                   rect.size.height * viewCount,
                                                   view.frame.size.width,
                                                   rect.size.height)
                           withDuration:kTextAnimationMoveTime
                             completion:^{
                                 viewCount++;
                             }];
        
        [_viewAnimation changeViewLightness:view
                                      alpha:1.f
                                   duration:kTextAnimationFadeInTime
                                 completion:^{}];
    }
   // [viewArray removeAllObjects];
    return YES;
}

// 删除指定的view
- (BOOL)removeViewArray:(NSMutableArray *)viewArray range:(NSRange)range
{
    
    for (int i = 0; i < range.length; i++)
    {
        UIView *view = [viewArray objectAtIndex:i];
        
//        [_viewAnimation changeViewFrame:view
//                                toFrame:CGRectMake((int)self.frame.size.width,
//                                                   kFloatZero,
//                                                   view.frame.size.width,
//                                                   kFloatZero)
//                           withDuration:kTextAnimationMoveTime
//                             completion:^{}];
//        
//        [_viewAnimation changeViewLightness:view
//                                      alpha:0.f
//                                   duration:kTextAnimationFadeOutTime
//                                 completion:^{
//                                     [view removeFromSuperview];
//                                 }];
        CGPoint offset = self.contentOffset;
        offset.y += view.frame.size.height;
        [self setContentOffset:offset animated:YES];
        
        //[viewArray removeObjectAtIndex:i];
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
     needDrawViewArray:(NSMutableArray*)drawViewArray
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
        view.frame = CGRectMake((int)((self.frame.size.width - view.frame.size.width) / 2.f),
                                (int)(self.frame.size.height),
                                view.frame.size.width,
                                kFloatZero);
        view.alpha = kFloatZero;
        [viewArray addObject:view];
        [_viewArrayKey addObject:[textArray objectAtIndex:i]];
        //[ViewToImageDic setValue:view forKey:[textArray objectAtIndex:i]];
        [drawViewArray addObject:view];
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
#pragma mark - 清屏
- (BOOL)clearLastRecognition
{
    NSArray *subViews = [self subviews];
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    return YES;
}
- (BOOL)resetPosition
{
    [self scrollsToTop];
    viewCount = 0;
    [_viewArray removeAllObjects];
    [ViewToImageDic removeAllObjects];
    [self setContentSize:CGSizeMake(0, 1)];
    return YES;
}
- (BOOL)clearData
{
    [_viewArray removeAllObjects];
    [ViewToImageDic removeAllObjects];
    return YES;
}

- (BOOL)scrollsToTopWithAnimation
{
    CGPoint offset = self.contentOffset;
    offset.y = 0;
    [self setContentOffset:offset animated:YES];
    return YES;
}
- (void)changeViewFrameToHalf :(UIView*)view;
{
//    CGRect frame = view.frame;
//    frame.size.height = frame.size.height / 2;
//    view.frame = frame;
    view.alpha = view.alpha / 2;
}
- (void)changeViewFrameToTwoTimes :(UIView*)view
{
//    CGRect frame = view.frame;
//    frame.size.height = frame.size.height * 2;
//    view.frame = frame;
    view.alpha = 2*view.alpha;
}
- (BOOL)beginScrolls :(NSDictionary *)parmDic
{
    NSDictionary *timeSet = [parmDic objectForKey:@"timeSet"];
    NSNumber *totalLength = [parmDic objectForKey:@"duration"];
    
    for (int i = 0; i != [_viewArray count]; i++)
    {
        UIView *view = [_viewArray objectAtIndex:i];
        [self performSelectorOnMainThread:@selector(changeViewFrameToHalf:) withObject:view waitUntilDone:NO];
        
        NSString *key = [_viewArrayKey objectAtIndex:i];
        NSNumber *num = [timeSet objectForKey:key];
       
        NSLog(@"开始");
        NSLog(@"duration =%f",[num doubleValue]/[totalLength unsignedIntValue]*_duration);
        [NSThread sleepForTimeInterval:[num doubleValue]/[totalLength unsignedIntValue]*_duration];
        [self performSelectorOnMainThread:@selector(changeViewFrameToTwoTimes:) withObject:view waitUntilDone:NO];
        NSLog(@"结束");
        
    }
        
   return YES;
}
- (BOOL)scrollsSubTitle:(NSDictionary *)timeSet :(NSInteger)totalLength :(double)duration
{
    _duration = duration;
    NSUInteger total = 0;
    for (NSString *key in [timeSet keyEnumerator])
    {
        double dur = [[timeSet objectForKey:key] doubleValue];
        total += dur;
    }
    NSLog(@"duration = %f",duration);
    NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:timeSet,@"timeSet",[NSNumber numberWithUnsignedInt:total],@"duration", nil];
    [self performSelectorInBackground:@selector(beginScrolls:) withObject:parmDic];
    return YES;
}

@end
