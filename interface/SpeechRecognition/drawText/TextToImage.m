//
//  StringToImage.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-31.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TextToImage.h"

@implementation TextToImage

- (UIImage *)imageFromText:(NSString *)text
                  withFont:(UIFont *)font
                     color:(UIColor *)color
                rowSpacing:(CGFloat)spacing
              shadowOffset:(CGSize)offset
                shadowBlur:(CGFloat)blur
               shadowColor:(UIColor *)shadowColor
{
    CGSize size = [text sizeWithFont:font];
    size.height += spacing;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, offset, blur, [shadowColor CGColor]);
    CGContextSetShouldSmoothFonts(context, YES);

    UIGraphicsBeginImageContext(size);
    [color set];
    [text drawInRect:CGRectMake(0.f, spacing / 2.f, size.width, size.height) withFont:font];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageFromText:(NSString *)text
                  withFont:(UIFont *)font
                     color:(UIColor *)color
                rowSpacing:(CGFloat)spacing
{
    CGSize size = [text sizeWithFont:font];
    size.height += spacing;
    
    UIGraphicsBeginImageContext(size);
    [color set];
    [text drawInRect:CGRectMake(0.f, spacing / 2.f, size.width, size.height) withFont:font];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageVerticalMergeWithImage:(UIImage *)image1
                                andImage:(UIImage *)image2
                             withSpacing:(CGFloat)spacing
{
    CGSize size = CGSizeMake(MAX(image1.size.width, image2.size.width),
                             image1.size.height + image2.size.height + spacing);
    
    UIGraphicsBeginImageContext(size);
    
    [image1 drawAtPoint:CGPointMake(0.f, 0.f)];
    [image2 drawAtPoint:CGPointMake(0.f, image1.size.height + spacing)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
