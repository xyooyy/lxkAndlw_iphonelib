//
//  FootTextControlView.h
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

/*
    视图用途：在屏幕底部的操作按钮
    控件包括：按钮*3
 */

#import <UIKit/UIKit.h>

@interface FootTextControlView : UIView
{
    UIButton *mBtnLeft;
    UIButton *mBtnRight;
    UIButton *mBtnMid;
    
    id mController;
    SEL mBtnLCall;
    SEL mBtnRCall;
    SEL mBtnMCall;
}

-(id)initWithSuperViewRect:(CGRect)aSuperRect;

-(void)disbleAllButtons;
-(void)enableAllButtons;

-(void)setBtnLTitleWithText:(NSString *)aStrText;
-(void)setBtnRTitleWithText:(NSString *)aStrText;
-(void)setBtnMTitleWithText:(NSString *)aStrText;

-(void)showBtnL;
-(void)showBtnM;
-(void)showBtnR;

-(void)showBtnLandR;

-(void)setController:(id)aController;
-(void)setBtnLPressCall:(SEL)aBtnLCall;
-(void)setBtnRPressCall:(SEL)aBtnRCall;
-(void)setBtnMPressCall:(SEL)aBtnMCall;

@end
