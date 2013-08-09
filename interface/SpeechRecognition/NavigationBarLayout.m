//
//  MyNavigationBar.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-28.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NavigationBarLayout.h"
#import "Data.h"

@interface NavigationBarLayout ()
{
    UINavigationBar *_navbar;
    id _delegate;
}

@end

@implementation NavigationBarLayout

- (id)initNavigationBar:(UINavigationBar *)navbar delegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        _navbar = navbar;
        
        // 添加导航栏背景
        [self addImageNamed:kImageNavBackground
                      frame:CGRectMake(kFloatZero, kFloatZero,
                                       kScreenWidth, kNavigationBarHeight)];
        // 添加按钮
        [self addButtonWithImageNamed:kImageHistoryButton
                                 rect:CGRectMake(kButtonHistoryX, kButtonHistoryY,
                                                 kButtonHistoryWidth, kButtonHistoryHeight)
                             delegate:_delegate
                               action:@selector(navbarRightButtonItemTouch:)];
    }
    return self;
}

#pragma mark - 

- (UIImageView *)addImageNamed:(NSString *)name frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    [_navbar addSubview:imageView];
    
    return imageView;
}

// 创建一个按钮，并添加到self中
- (UIButton *) addButtonWithImageNamed:(NSString *)name
                                  rect:(CGRect)rect
                              delegate:(id)delegate
                                action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchDown];
    [_navbar addSubview:button];
    
    return button;
}

@end
