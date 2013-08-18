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


@interface SoundWaveView ()
{
    
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
        int height = [[UIScreen mainScreen] bounds].size.height;
        kSoundWaveHeight = height == IPHONE4_SCREEN_HEIGHT?SOUNDWAVE_HEIGHT:(SOUNDWAVE_HEIGHT+height-IPHONE4_SCREEN_HEIGHT);
    }
    return self;
}

//#define kSoundWaveHeight 370

- (UIImage*)getTemplateImage
{
    GradientColorImage *gradient = [[GradientColorImage alloc] init];
    UIImage *gradientImage = [gradient imageLinearGradientWithRect:CGRectMake(kFloatZero, kFloatZero, SOUNDWAVE_WIDTH, TMPLATEIMAGE_HEIGHT)
                                                        startColor:[UIColor colorWithRed:START_COLOR_R green:START_COLOR_G blue:START_COLOR_B alpha:START_COLOR_A].CGColor
                                                          endColor:[UIColor colorWithRed:END_COLOR_R green:END_COLOR_G blue:END_COLOR_B alpha:END_COLOR_A].CGColor];
    return gradientImage;
}
- (int) getRandomHeight :(int)index
{
    int height = 0;
    if (_strong > SOUND_STRONG_THRESHOLD)
    {
        double seedFactor = SEED_FACTOR;
        height = (rand() % _strong /seedFactor);
        if (index < LEFT_INDEX_THRESHOLD || index > RIGHT_INDEX_THRESHOLD)
        {
            double factor = SOUND_STRONG_FACTOR;
            height /= factor;
        }
            
    }
    else
    {
        height = rand() % _strong;
    }
    height = MAX(height, SOUND_STRONG_MIN_VALUE);
    return height;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIImage *gradientImage = [self getTemplateImage];
    if(_strong == 0)return;
    for (int i = 0; i < kScreenWidth; i += SOUNDWAVE_WIDTH)
    {
        int height = [self getRandomHeight:i];
        [gradientImage drawInRect:CGRectMake(i, kSoundWaveHeight - height, SOUNDWAVE_WIDTH, height)];
        CGContextSetShadowWithColor(context, CGSizeMake(4, -4), 10, [UIColor redColor].CGColor);
    }
}

- (void)drawQueue
{
    _strong = [[array objectAtIndex:0] unsignedIntValue];
}
- (BOOL)addSoundStrong:(NSUInteger)strong
{
    _strong = strong;
    [self setNeedsDisplay];
    return YES;
}

@end