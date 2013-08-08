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
    NSUInteger _strong;
}

@end

@implementation SoundWaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// 每一根波形柱的宽度
#define kSoundWaveWidth 2
#define kSoundWaveHeight 330.f

- (void)drawRect:(CGRect)rect
{
    if (0 == _strong) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    GradientColorImage *gradient = [[GradientColorImage alloc] init];
    UIImage *gradientImage = [gradient imageLinearGradientWithRect:CGRectMake(0, 0, kSoundWaveWidth, 100.f)
                                            startColor:[UIColor colorWithRed:0.111 green:0.063 blue:0.059 alpha:0.000].CGColor
                                              endColor:[UIColor colorWithRed:1.000 green:0.408 blue:0.317 alpha:1.000].CGColor];

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
        // 波形柱最小为1
        height = MAX(height, 2);
        
        [gradientImage drawInRect:CGRectMake(i, kSoundWaveHeight - height, kSoundWaveWidth, height)];
        // 画波形柱的阴影
        CGContextSetShadowWithColor(context, CGSizeMake(3, -3), 10, [UIColor redColor].CGColor);
    }
    NSLog(@"%i", _strong);
}

- (BOOL)addSoundStrong:(NSUInteger)strong
{
    _strong = strong;
    [self setNeedsDisplay];
    return YES;
}

@end
