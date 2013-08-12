//
//  GradientColorImage.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-3.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "GradientColorImage.h"

@implementation GradientColorImage

- (UIImage *)imageLinearGradientWithRect:(CGRect)rect
                             startColor:(CGColorRef)startColor
                               endColor:(CGColorRef)endColor
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0,1};
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    //CGContextSaveGState(context);
   // UIGraphicsPushContext(context);
    //CGContextAddRect(context, rect);
    
    //CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,1);
   //CGContextRestoreGState(context);
    //UIGraphicsPopContext();
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
