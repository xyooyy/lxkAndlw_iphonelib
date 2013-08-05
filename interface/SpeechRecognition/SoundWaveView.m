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

- (void)drawRect:(CGRect)rect
{
#define kSoundWaveWidth 3
    if (0 == _strong) return;
    
    GradientColorImage *gradient = [[GradientColorImage alloc] init];
    int height = 0;
    for (int i = 0; i < kScreenWidth; i+=kSoundWaveWidth)
    {
        height = (rand() % _strong) / 9.f + _strong / rand() % 100;
        CGContextRef context = UIGraphicsGetCurrentContext();
        if(height == 0)
            height = 2;
        
        UIImage *image = [gradient imageLinearGradientWithRect:CGRectMake(0, 0, kSoundWaveWidth, height)
                                                    startColor:kSoundWaveEndCGColor
                                                      endColor:[UIColor colorWithRed:0.700 green:0.137 blue:0.297 alpha:1.000].CGColor];
        [image drawInRect:CGRectMake(i, 350 - height, kSoundWaveWidth, height)];
        CGContextSetShadowWithColor(context, CGSizeMake(3, 0), 5, [UIColor redColor].CGColor);
    }
    
}

- (BOOL)addSoundStrong:(NSUInteger)strong
{
    _strong = strong;
    [self setNeedsDisplay];
    //[NSThread sleepForTimeInterval:1.0f];
    return YES;
}

@end
