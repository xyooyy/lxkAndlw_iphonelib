//
//  GradientColorImage.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-3.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradientColorImage : NSObject

- (UIImage *)imageLinearGradientWithRect:(CGRect)rect
                              startColor:(CGColorRef)startColor
                                endColor:(CGColorRef)endColor;

@end
