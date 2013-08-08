//
//  UIImgView.m
//  ASTableViewCellShow
//
//  Created by  on 13-4-11.
//  Copyright (c) 2013年 Alpha Studio. All rights reserved.
//

#import "ImgOperation.h"
@interface ImgOperation() 
- (UIImage *)drawRectangle:(CGSize)borderSize :(CGFloat)fRound;
@end
@implementation ImgOperation

-(UIImage *) ScaleImg :(UIImage *)image :(CGSize)imageSize 
{
    UIImage *imgShow;
    UIGraphicsBeginImageContext(imageSize);
    CGRect ImageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [image drawInRect:ImageFrame];
    imgShow = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgShow;
}
-(UIImage *) ScreenshotImg :(UIImage *)image :(CGRect)imageFrame 
{
    UIImage *imgShow;
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, imageFrame);
    UIImage *imageSrc =  [UIImage imageWithCGImage:imageRef];
    
    double imageWidth = imageFrame.size.width;
    double imageHeight = imageFrame.size.height;
    CGSize size = imageFrame.size;
    CGRect imgFrame = CGRectMake(0, 0, imageWidth, imageHeight);
    
    UIGraphicsBeginImageContext(size);
    [imageSrc drawInRect:imgFrame];
    imgShow = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgShow;
}
-(UIImage *) AddSquareBorderImg :(UIImage *)image :(CGSize)BorderSize : (float) fRound
{
    UIImage *imgShow;
    UIImage *imgBorder = [self drawRectangle:BorderSize :fRound];
    UIGraphicsBeginImageContext(BorderSize);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGRect imgBorderFrame = CGRectMake(0, 0, BorderSize.width, BorderSize.height);
    [imgBorder drawInRect:imgBorderFrame];
    imgShow = UIGraphicsGetImageFromCurrentImageContext();
    return imgShow;
}
-(UIImage*) MergeImg : (NSArray *)arrImage : (NSArray *)arrPosImage : (CGSize)size
{
    UIImage *mergeView;
    UIGraphicsBeginImageContext(size);
    for (int i = 0; i < arrImage.count; i ++) {
        UIImage *image = (UIImage *)[arrImage objectAtIndex:i];
        CGSize imgSize = image.size;
        CGPoint imgPos = [[arrPosImage objectAtIndex:i] CGPointValue];
        CGRect imgFrame = CGRectMake(imgPos.x, imgPos.y, imgSize.width, imgSize.height);
        [image drawInRect:imgFrame];
    }
    mergeView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeView;
}
- (UIImage *)drawRectangle:(CGSize)borderSize :(CGFloat)fRound
{
    CGFloat width = borderSize.width;
    CGFloat height = borderSize.height;
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, COLOR_ALPHA);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, fRound, 0);
    CGContextAddLineToPoint(context, width - fRound, 0);
    CGContextAddArc(context, width - fRound, fRound, fRound, CIRCLE_LEFT_UP_ANGLE * M_PI, 0.0, 0);
    CGContextAddLineToPoint(context, width, height - fRound);
    CGContextAddArc(context, width - fRound, height - fRound, fRound, 0.0, CIRCLE_RIGHT_UP_ANGLE * M_PI, 0);
    CGContextAddLineToPoint(context, fRound, height);
    CGContextAddArc(context, fRound, height - fRound, fRound, CIRCLE_RIGHT_DOWN_ANGLE * M_PI, M_PI, 0);
    CGContextAddLineToPoint(context, 0, fRound);
    CGContextAddArc(context, fRound, fRound, fRound, M_PI, CIRCLE_LEFT_DOWN_ANGLE * M_PI, 0);    
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
@end
