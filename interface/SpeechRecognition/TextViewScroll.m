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
        _maxRow = number;
        _viewAnimation = [[UIViewAnimation alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = CGSizeMake(0, 0);
        viewCount = 0;
        scrollCount = 0;
        scrollIndex = 0;
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
    
    if (viewCount >= _maxRow)
    {
        [self removeViewArray:_viewArray
                        range:NSMakeRange(kIntZero, textArray.count)];
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
        size.height += view.frame.size.height;
        self.contentSize = size;
        NSLog(@"scrollView的currentSize = %f",size.height/22.0);
        [_viewAnimation changeViewFrame:view
                                toFrame:CGRectMake(view.frame.origin.x,
                                                   rect.size.height * viewCount,
                                                   view.frame.size.width,
                                                   rect.size.height)
                           withDuration:kTextAnimationMoveTime
                             completion:^{
                                
                             }];
        
        [_viewAnimation changeViewLightness:view
                                      alpha:1.f
                                   duration:kTextAnimationFadeInTime
                                 completion:^{}];
        
         viewCount += [[view subviews] count];
    }
   // [viewArray removeAllObjects];
    return YES;
}

// 删除指定的view
- (BOOL)removeViewArray:(NSMutableArray *)viewArray range:(NSRange)range
{
    
    //for (int i = 0; i < range.length; i++)
    //{
       // UIView *view = [viewArray objectAtIndex:i];
        
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
        offset.y += 22*range.length /*view.frame.size.height*/;
        [self setContentOffset:offset animated:YES];
        
        //[viewArray removeObjectAtIndex:i];
  //  }
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
    UIView *merageView = [[UIView alloc]initWithFrame:CGRectMake(40, 100, 247, 22*[textArray count])];
    NSString *str = [[NSString alloc]init];
    for (int i = 0; i < textArray.count; i++)
    {
        UIImage *image = [textToImage imageFromText:[textArray objectAtIndex:i]
                                           withFont:font
                                              color:color
                                         rowSpacing:spacing];
        NSLog(@"image.size.width = %f,merageView.width = %f",image.size.width,merageView.frame.size.width);
        
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        rect = view.frame;
        view.frame = CGRectMake((int)((self.frame.size.width - view.frame.size.width) / 2.f)-2,
                                (int)(self.frame.size.height),
                                view.frame.size.width,
                                view.frame.size.height);
        view.frame = CGRectMake((240 - view.frame.size.width)/2, i*view.frame.size.height, view.frame.size.width, view.frame.size.height);
        //view.alpha = kFloatZero;
        [merageView addSubview:view];
        str = [str stringByAppendingString:[textArray objectAtIndex:i]];
        
    }
    [viewArray addObject:merageView];
    [drawViewArray addObject:merageView];
    merageView.alpha = kFloatZero;
    [self addSubview:merageView];
   
    
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
    if([_viewArray count]>0)
        [_viewArray removeAllObjects];
    [self setContentSize:CGSizeMake(0, 0)];
    return YES;
}
- (BOOL)scrollsToTopWithAnimation
{
    CGPoint offset = self.contentOffset;
    offset.y = 0;
    [self setContentOffset:offset animated:YES];
    return YES;
}
#pragma mark - 字幕同步
- (void)changeViewalphaToHalf :(UIView*)view;
{
    view.alpha = view.alpha / 2;
}
- (void)changeViewalphaToTwoTimes :(UIView*)view
{
    view.alpha = 2*view.alpha;
}
-(NSString*)getKeyFirstApperWithValue :(NSDictionary*)recognizedStrAndDurationDic :(NSString*)value
{
    for (NSString *key in [recognizedStrAndDurationDic keyEnumerator])
    {
        if([[recognizedStrAndDurationDic objectForKey:key] isEqual:value])
            return key;
    }
    return nil;
}


- (BOOL)isKeyInKeyArray :(int)count :(NSArray*)parmkeyArray
{
    for (NSString *key in parmkeyArray)
    {
        if([key isEqualToString:[NSString stringWithFormat:@"%d",count]])
            return YES;
    }
    return NO;
}
-(void)receivePlayData
{
    scrollCount++;
    if(scrollIndex<=[keyArray count] -1 && !flag)
    {
        
        lastView = [_viewArray objectAtIndex:scrollIndex];
        lastView.alpha = 0.5;
        flag = YES;
        if(scrollIndex >= _maxRow-1)
        {
            CGPoint offset = self.contentOffset;
            offset.y += lastView.frame.size.height;
            [self setContentOffset:offset animated:YES];
        }
    }
    
    if([self isKeyInKeyArray:scrollCount :keyArray])
    {
        if(lastView) lastView.alpha = 1.f;
        flag = NO;
        scrollIndex++;
    }
    //[obj performSelector:receivePlayDataAction withObject:voiceData];
}
-(void)playComplete
{
    CGPoint offset = self.contentOffset;
    offset.y = 0;
    [self setContentOffset:offset animated:YES];
}
- (BOOL)setSubtitleKey:(NSArray *)parmKeyArray
{
    keyArray = [[NSArray alloc]initWithArray:parmKeyArray];
    return YES;
}

- (BOOL)playInit
{
    scrollIndex = 0;
    scrollCount = 0;
    return YES;
}
@end
