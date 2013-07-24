//
//  HeadSpeakControlView.m
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "HeadControlView.h"

@implementation HeadControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithSuperViewCGRect:(CGRect)aSuperRect AndTitle:(NSString *)aStrTitle
{
    self = [super init];
    if (self) {
        //init the Titile
        [self setFrame:CGRectMake(0, 0,aSuperRect.size.width, 30.0f)];
        mLabelTitle = [[UILabel alloc]init];
        [mLabelTitle setText:aStrTitle];
        mLabelTitle.frame = CGRectMake((self.frame.size.width-90)/2, 0, 90, 30);
        [self addSubview:mLabelTitle];
        
        //init the left button
        mBtnLeft = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mBtnLeft setFrame:CGRectMake(0.0f+10.0f, 0.0f, 80.0f, 30.0f)];
        [mBtnLeft addTarget:self action:@selector(leftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //init the right button
        mBtnRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mBtnRight setFrame:CGRectMake(self.frame.size.width-80.0f-10.0f, 0, 80.0f, 30.0f)];
        [mBtnRight addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//按钮点击事件响应
-(void)leftBtnPressed
{
    [mController performSelector:mLeftBtnPressCall];
}

-(void)rightBtnPressed
{
    [mController performSelector:mRightBtnPressCall];
}

//标题设置
-(void)setTitleWithString:(NSString *)aTitle
{
    [mLabelTitle setText:aTitle];
}

//按钮属性设置
-(void)setLeftBtnTitleWithString:(NSString *)aStrTitle
{
    [mBtnLeft setTitle:aStrTitle forState:UIControlStateNormal];
}

-(void)setRightBtnTitleWithString:(NSString *)aStrTitle
{
    [mBtnRight setTitle:aStrTitle forState:UIControlStateNormal];
}

-(void)disableRightBtn
{
    mBtnRight.enabled = NO;
}

-(void)enableRightBtn
{
    mBtnRight.enabled = YES;
}

-(void)showRightBtn
{
    [self addSubview:mBtnRight];
}

-(void)showLeftBtn
{
    [self addSubview:mBtnLeft];
}

//函数回调设置
-(void)setControllerWithID:(id)aIDController
{
    mController = aIDController;
}

-(void)setLeftBtnPressCallBackWithSEL:(SEL)aLeftPressCall
{
    mLeftBtnPressCall = aLeftPressCall;
}
-(void)setRightBtnPressCallBackWithSEL:(SEL)aRightPressCall
{
    mRightBtnPressCall = aRightPressCall;
}

-(void)dealloc
{
    [mBtnLeft dealloc];
    [mBtnRight dealloc];
    [mLabelTitle dealloc];
    [super dealloc];
}
@end
