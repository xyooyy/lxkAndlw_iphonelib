//
//  EditView.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-15.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditView.h"
#import "Data.h"

@implementation EditView


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addImageWithName:kImageCD
                     frame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                      kImageCDAfterWidth, kImageCDAfterHeight)];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, 290, 350)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    
    UIButton *backButton = [self addButtonWithImageNamed:kImageReturnButton
                                                    rect:CGRectMake(0, 0, 70, 29)
                                                delegate:self
                                                  action:@selector(backButtonTouch:)
                                                  toView:nil];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    [self addButtonWithImageNamed:kImageEditButton
                             rect:CGRectMake(15, 375, 135, 30)
                         delegate:self
                           action:@selector(editButtonTouch:)
                           toView:self.view];
    
    [self addButtonWithImageNamed:kImageRedCopyButton
                             rect:CGRectMake(170, 375, 135, 30)
                         delegate:self
                           action:@selector(copyButtonTouch:)
                           toView:self.view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (UIImageView *)addImageWithName:(NSString *)name frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    [self.view addSubview:imageView];
    return imageView;
}
- (UIButton *)addButtonWithImageNamed:(NSString *)name
                                 rect:(CGRect)rect
                             delegate:(id)delegate
                               action:(SEL)action
                               toView:(UIView *)view
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    UIImage *image = [UIImage imageNamed:name];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return button;
}
- (BOOL)backButtonTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
@end
