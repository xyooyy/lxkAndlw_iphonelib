//
//  UIImgView.h
//  ASTableViewCellShow
//
//  Created by  on 13-4-11.
//  Copyright (c) 2013年 Alpha Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImgOperationDefine.h"

@interface ImgOperation :NSObject  
-(UIImage *) ScaleImg :(UIImage *)image :(CGSize)imageSize;
-(UIImage *) ScreenshotImg :(UIImage *)image :(CGRect)imageFrame;
-(UIImage *) AddSquareBorderImg :(UIImage *)image :(CGSize)BorderSize : (float) fRound;
-(UIImage*) MergeImg : (NSArray *)arrImage : (NSArray *) arrPosImage : (CGSize)size;
@end
