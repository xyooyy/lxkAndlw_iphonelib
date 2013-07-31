//
//  StringToImage.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-31.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextToImage : NSObject

- (UIImage *)imageFromText:(NSString *)text
                  withFont:(UIFont *)font
                     color:(UIColor *)color
                rowSpacing:(CGFloat)spacing
              shadowOffset:(CGSize)offset
                shadowBlur:(CGFloat)blur
               shadowColor:(UIColor *)shadowColor;

- (UIImage *)imageFromText:(NSString *)text
                  withFont:(UIFont *)font
                     color:(UIColor *)color
                rowSpacing:(CGFloat)spacing;

- (UIImage *)imageVerticalMergeWithImage:(UIImage *)image1
                                andImage:(UIImage *)image2
                             withSpacing:(CGFloat)spacing;


@end
