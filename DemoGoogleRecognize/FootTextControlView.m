//
//  FootTextControlView.m
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "FootTextControlView.h"

@implementation FootTextControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithSuperViewRect:(CGRect)aSuperRect
{
    self = [super init];
    if (self) {
        //init self frame
        [self setFrame:CGRectMake(0.0f, aSuperRect.size.height-50.0f, aSuperRect.size.width, 50.0f)];
        
        //init the Left button frame
        mBtnLeft = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mBtnLeft setFrame:CGRectMake(0.0f+10.0f, 0.0f, 80.0f, 50.0f)];
        [mBtnLeft addTarget:self action:@selector(btnLPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //init the Right button
        mBtnRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mBtnRight setFrame:CGRectMake(aSuperRect.size.width-80.0f-10.0f, 0.0f, 80.0f, 50.0f)];
        [mBtnRight addTarget:self action:@selector(btnRPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //init the Middle button
        mBtnMid = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mBtnMid setFrame:CGRectMake((aSuperRect.size.width-80.0f)/2, 0.0f, 80.0f, 50.0f)];
        [mBtnMid addTarget:self action:@selector(btnMPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)disbleAllButtons
{
    mBtnLeft.enabled = NO;
    mBtnMid.enabled = NO;
    mBtnRight.enabled = NO;
}

-(void)enableAllButtons
{
    mBtnLeft.enabled = YES;
    mBtnMid.enabled = YES;
    mBtnRight.enabled = YES;
}


-(void)btnLPressed
{
    [mController performSelector:mBtnLCall];
}

-(void)btnRPressed
{
    [mController performSelector:mBtnRCall];
}

-(void)btnMPressed
{
    [mController performSelector:mBtnMCall];
}

-(void)dealloc
{
    [mBtnLeft dealloc];
    [mBtnRight dealloc];
    [mBtnMid dealloc];
    
    [super dealloc];
}

-(void)setBtnLTitleWithText:(NSString *)aStrText
{
    [mBtnLeft setTitle:aStrText forState:UIControlStateNormal];
}
-(void)setBtnRTitleWithText:(NSString *)aStrText
{
    [mBtnRight setTitle:aStrText forState:UIControlStateNormal];
}
-(void)setBtnMTitleWithText:(NSString *)aStrText
{
    [mBtnMid setTitle:aStrText forState:UIControlStateNormal];
}

-(void)showBtnL
{
    [self addSubview:mBtnLeft];
}
-(void)showBtnM
{
    [self addSubview:mBtnMid];
}
-(void)showBtnR
{
    [self addSubview:mBtnRight];
}

-(void)showBtnLandR
{
    [self showBtnL];
    [self showBtnR];
}

-(void)setController:(id)aController
{
    mController = aController;
}
-(void)setBtnLPressCall:(SEL)aBtnLCall
{
    mBtnLCall = aBtnLCall;
}
-(void)setBtnRPressCall:(SEL)aBtnRCall
{
    mBtnRCall = aBtnRCall;
}
-(void)setBtnMPressCall:(SEL)aBtnMCall
{
    mBtnMCall = aBtnMCall;
}

@end
