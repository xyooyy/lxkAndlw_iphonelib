//
//  SoundWaveView.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-1.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GradientColorImage.h"
#import "SoundWaveView.h"
#import "Data.h"

#define kSoundWaveCrest 8

@interface SoundWaveView ()
{
    //NSUInteger _strong;
}

@end

@implementation SoundWaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        array = [[NSMutableArray alloc]init];
    }
    return self;
}

// 每一根波形柱的宽度
#define kSoundWaveWidth 2
#define kSoundWaveHeight 370


- (void)drawInBack
{
    
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    GradientColorImage *gradient = [[GradientColorImage alloc] init];
    UIImage *gradientImage = [gradient imageLinearGradientWithRect:CGRectMake(0, 0, kSoundWaveWidth, 100.f)
                                                        startColor:[UIColor colorWithRed:0.111 green:0.063 blue:0.059 alpha:0.000].CGColor
                                                          endColor:[UIColor colorWithRed:1.000 green:0.408 blue:0.317 alpha:1.000].CGColor];
    if(_strong == 0)return;
    int height = 0;
    for (int i = 0; i < kScreenWidth; i+=kSoundWaveWidth)
    {
        // 波形柱高度基于音强的随机数
        if (_strong > 10)
        {
            height = (rand() % _strong / 5.f);
            if (i < 100 || i > 220)
            {
                height /= 1.7f;
            }
        }
        else
        {
            height = rand() % _strong;
        }
        // 波形柱最小为2
        height = MAX(height, 2);
        
        
        // 画波形柱的阴影
        [gradientImage drawInRect:CGRectMake(i, kSoundWaveHeight - height, kSoundWaveWidth, height)];
        CGContextSetShadowWithColor(context, CGSizeMake(4, -4), 10, [UIColor greenColor].CGColor);
        
    }
    

}

- (void)drawQueue
{
    _strong = [[array objectAtIndex:0] unsignedIntValue];
    
    
}
- (BOOL)addSoundStrong:(NSUInteger)strong
{
    //if(strong <= 15) return NO;
    //[array addObject:[NSNumber numberWithUnsignedInt:strong]];
    _strong = strong;
   // NSLog(@"arrayCount = %d",[array count]);
    //[self setNeedsDisplay];
    [self setNeedsDisplay];
    return YES;
}

@end