//
//  HeadSpeakControlView.h
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//
/*
    视图用途：控制返回，开始、停止录音和查看历史就用
    控件包括：按钮*2 Label*1
 */

#import <UIKit/UIKit.h>

@interface HeadControlView : UIView
{
    UILabel *mLabelTitle;
    UIButton *mBtnLeft;
    UIButton *mBtnRight;
    
    id mController;
    
    SEL mLeftBtnPressCall;
    SEL mRightBtnPressCall;
}

//函数初始化函数
-(id)initWithSuperViewCGRect:(CGRect)aSuperRect AndTitle:(NSString *)aStrTitle;

//设置接口函数
-(void)setTitleWithString:(NSString *)aTitle;

//设置按钮标题
-(void)setLeftBtnTitleWithString:(NSString *)aStrTitle;
-(void)setRightBtnTitleWithString:(NSString *)aStrTitle;

//设置按钮操作性
-(void)disableRightBtn;
-(void)enableRightBtn;

//设置按钮显示
-(void)showRightBtn;
-(void)showLeftBtn;

//设置回调函数接口
//设置controller
-(void)setControllerWithID:(id)aIDController;

//设置SEL
-(void)setLeftBtnPressCallBackWithSEL:(SEL)aLeftPressCall;
-(void)setRightBtnPressCallBackWithSEL:(SEL)aRightPressCall;


@end
