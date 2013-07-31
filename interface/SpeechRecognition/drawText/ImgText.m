//
//  UITextImgView.m
//  ASTableViewCellShow
//
//  Created by  on 13-4-11.
//  Copyright (c) 2013年 Alpha Studio. All rights reserved.
//

#import "ImgText.h"

@implementation ImgText
-(id)initWithArray :(NSArray *) arrText  :(int)textSize :(CGSize)TextImgSize
{
    self = [super init];
    if (self) {
        m_arrStrText = arrText;
        m_ntextSize = textSize;
        m_textImgSize = TextImgSize;
    }
    return self;
}

-(id) initWithString : (NSString *) strText  :(int)textSize :(CGSize)TextImgSize
{
    self = [super init];
    if (self) {
        m_arrStrText = [[NSArray alloc]initWithObjects:strText, nil];
        m_ntextSize = textSize;
        m_textImgSize = TextImgSize;
    }
    return self;
}

-(int)textDrawCount :(NSString *)strText :(int)wordNum
{
    int count = 0;
    if(strText.length % wordNum == 0)
    {
        count = strText.length / wordNum;
    }
    else
    {
        count = ((strText.length / wordNum) + 1);
    }
    return count;
}
-(NSString *)EveryImgText :(NSString *)strUnit :(int)count :(int)i :(int)wordNum
{
    NSString *strTmp;
    if(i != count - 1)
    {
        strTmp = [strUnit substringWithRange:NSMakeRange(wordNum * i, wordNum )];
    }
    if(i == count - 1)
    {
        int length = strUnit.length - wordNum *(count - 1);
        strTmp = [strUnit substringWithRange:NSMakeRange(wordNum * i, length)];
    }
    return strTmp;
}
-(UIImage *)DrawEveryLineImg :(NSString*)strEveryLineWord
{
    int itemHeight = m_ntextSize * WORD_SIZE_CONVERSE ;
    int textWidth = m_textImgSize.width;
    CGColorSpaceRef ColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 2 * textWidth,itemHeight,
                                                 BIT_PER_COMPONENT,
                                                 BIT_PER_COMPONENT * textWidth,
                                                 ColorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, itemHeight);
    CGContextConcatCTM(context,flipVertical);
    CGContextSetRGBFillColor(context, 255.f, 245.f, 205.f, 1.f);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.728 green:0.739 blue:0.729 alpha:1.000].CGColor);
    UIGraphicsPushContext(context);
    [strEveryLineWord drawInRect:CGRectMake(0, 0, 2 * textWidth, itemHeight)
                        withFont:[UIFont boldSystemFontOfSize:m_ntextSize]];
    UIGraphicsPopContext();
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *imgtmp = [UIImage imageWithCGImage:imgRef scale:1.9 orientation:UIImageOrientationUp];
//    UIImage *imgtmp = [UIImage imageWithCGImage:imgRef];
    return imgtmp;
}
-(NSArray *)DrawSingleText :(NSArray *)arrStrText :(int)iCount :(int)wordNum
{
    NSString *strUnit = [arrStrText objectAtIndex:iCount];
    NSMutableArray *arrTextImg = [[NSMutableArray alloc] initWithCapacity:0];
    int count = 0;
    count = [self textDrawCount :strUnit:wordNum];
    for(int i = 0 ; i < count ;i ++)
    {
        UIImage *imgTmp;
        NSString *strTmp;
        strTmp = [self EveryImgText :strUnit:count :i :wordNum];  
        imgTmp = [self DrawEveryLineImg:strTmp];
        [arrTextImg addObject:imgTmp];
    }
    return arrTextImg;
}
-(void)ADDSingleTxtToArrTextImg :(NSArray *)array :(NSMutableArray **)arrTextImg
{
    for (int i = 0; i < array.count; i ++) {
        [*arrTextImg addObject:[array objectAtIndex:i]];
    }
}
-(NSArray *)DrawEveryTextToImg :(NSArray *)arrStrText :(CGSize)ImgSize :(int)textSize
{
    NSMutableArray *arrTextImg = [[NSMutableArray alloc]initWithCapacity:0];
    int wordNum = 0;
    int textWidth = ImgSize.width;
    wordNum = 2 * textWidth / textSize;
    int count = arrStrText.count;
    for(int i = 0; i < count; i ++)
    {                
        NSArray *array = [self DrawSingleText :arrStrText:i :wordNum];
        [self ADDSingleTxtToArrTextImg:array :&arrTextImg]; 
    }
    return arrTextImg;
}
- (NSArray *)SaveImgPosArr :(NSArray *)arrImg :(int)textSize
{
    NSMutableArray *arrImgPos = [[NSMutableArray alloc]initWithCapacity:0];  
    for (int i = 0; i < arrImg.count; i ++) {
        CGPoint imgPos = CGPointMake(0, textSize * i);
        [arrImgPos addObject:[NSValue valueWithCGPoint:imgPos]];
    }
    return arrImgPos;
}
- (UIImage *)mergeArrImg
{
    NSArray *arrImg = [self DrawEveryTextToImg :m_arrStrText:m_textImgSize :m_ntextSize];
    ImgOperation *imgOp = [[ImgOperation alloc]init];
    NSArray *arrImgPos = [self SaveImgPosArr:arrImg :m_ntextSize];
    return [imgOp MergeImg:arrImg :arrImgPos :m_textImgSize];
}

@end
