//
//  BodyContentView.m
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "BodyContentView.h"

@implementation BodyContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id)initWithSuperViewRect:(CGRect)aSuperRect
{
    self = [super initWithFrame:CGRectMake(0.0f, 30.0f, aSuperRect.size.width, aSuperRect.size.height-50.0f-30.f)];
    if (self) {
        mTextView = [[UITextView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, aSuperRect.size.width-10.0f, self.frame.size.height-10.0f)];
        [self configTextViewBorder];
        [self addSubview:mTextView];
    }
    return self;
}

-(void)configTextViewBorder
{
    [self disableEdit];
    mTextView.delegate = self;
    mTextView.font = [UIFont systemFontOfSize:16.0f];
    mTextView.backgroundColor = [UIColor clearColor];
    mTextView.layer.masksToBounds = YES;
    mTextView.layer.borderWidth = 1.;
    mTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    mTextView.layer.cornerRadius = 10.0f;
    mTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
}

-(void)disableEdit
{
    mEditable = NO;
}

-(void)enableEdit
{
    mEditable = YES;
}

-(void)setTextRewirteAll:(NSString *)aStrText
{
    mTextView.text = aStrText;
}
-(void)AddTextAtEnd:(NSString *)aStrText
{
    mTextView.text = [NSString stringWithFormat:@"%@\r\n%@",mTextView.text,aStrText];
}

-(void)dealloc
{
    [mTextView dealloc];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return mEditable;
}

-(void)ExitKeyBoard
{
    [mTextView resignFirstResponder];
}

-(NSString *)getContent
{
    return mTextView.text;
}

@end
