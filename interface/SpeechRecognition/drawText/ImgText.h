//
//  UITextImgView.h
//  ASTableViewCellShow
//
//  Created by  on 13-4-11.
//  Copyright (c) 2013年 Alpha Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImgTextDefine.h"
#import "ImgOperation.h"

@interface ImgText : NSObject
{
    NSArray *m_arrStrText;
    CGSize m_textImgSize;
    int m_ntextSize;
}

- (id)initWithArray :(NSArray *) arrText  :(int)textSize :(CGSize)TextImgSize;
- (id)initWithString : (NSString *) strText  :(int)textSize :(CGSize)TextImgSize;
- (UIImage *)mergeArrImg;

@end
