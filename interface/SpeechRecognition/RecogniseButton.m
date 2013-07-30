//
//  RecogniseButton.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-29.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "RecogniseButton.h"
#import "data.h"

@implementation RecogniseButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageRecogniseX,
                                                                               kImageRecogniseY,
                                                                               kImageRecogniseWidth,
                                                                               kImageRecogniseHeight)];
        imageView.image = image;
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kLabelRecogniseX, kLabelRecogniseY, kLabelRecogniseWidth, kLabelRecogniseHeight)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.705 alpha:1.000];
//        label.font = [UIFont systemFontOfSize:12.f];
        label.font = [UIFont fontWithName:@"Helvetica" size:12.f];
        [self addSubview:label];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
