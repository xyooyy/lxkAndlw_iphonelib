//
//  BodyContentView.h
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

/*
 视图用途：在屏幕中间显示文字
 控件包括：textField * 1
 */


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BodyContentView : UIView <UITextViewDelegate>
{
    UITextView *mTextView;
    BOOL mEditable;
}

//init
-(id)initWithSuperViewRect:(CGRect)aSuperRect;

//set the editor
-(void)disableEdit;
-(void)enableEdit;

//fix the content of the text field
-(void)setTextRewirteAll:(NSString *)aStrText;
-(void)AddTextAtEnd:(NSString *)aStrText;
-(void)ExitKeyBoard;
-(NSString *)getContent;

@end
