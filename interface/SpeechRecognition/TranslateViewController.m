//
//  EditViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TranslateViewController.h"
#import "TranslateRecognizeResult.h"
#import "EditTranslateController.h"
#import "PopupView.h"
#import "Data.h"

@interface TranslateViewController ()
{
    UITextView *_textView;
    NSString *_savePath;
    TranslateRecognizeResult *_translate;
}
@end

@implementation TranslateViewController

- (id)initWithString:(NSString *)string :(NSString*)savePath
{
    if (self = [super init])
    {
        _savePath = savePath;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, 290, 350)];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor whiteColor];
        
        _translate = [[TranslateRecognizeResult alloc] initWithData:self :@selector(translate:result:)];
        [_translate translate:string];
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addImageWithName:kImageCD
                     frame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                      kImageCDAfterWidth, kImageCDAfterHeight)];
   
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

// 创建一个按钮，并添加到self中
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

- (UIImageView *)addImageWithName:(NSString *)name frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    [self.view addSubview:imageView];
    return imageView;
}

- (BOOL)setSavePath:(NSString *)path
{
    _savePath = path;
    return YES;
}

#pragma mark - 按钮事件

- (BOOL)copyButtonTouch:(UIButton *)sender
{
    PopupView *popupView = [[PopupView alloc] init];
    [popupView showWithText:@"复制成功"
               AndSuperView:self.view
                  andHeight:self.view.frame.size.height * 0.7];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_textView.text];
    return YES;
}

- (BOOL)editButtonTouch:(UIButton *)sender
{
    EditTranslateController *editTranslateController = [[EditTranslateController alloc] init];
    //[editTranslateController setSavePath:_savePath];
    [editTranslateController setTextString:_textView.text];
    [editTranslateController setEditSaveCallBack:self :@selector(editSaveCallBack:)];
    [self.navigationController pushViewController:editTranslateController animated:YES];
    return YES;
}

- (BOOL)backButtonTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

#pragma mark - 翻译

- (BOOL)translate:(NSString *)string result:(NSArray *)resultArray
{
    [_textView setText:[self arrayToString:resultArray]];
    return YES;
}

- (NSString *)arrayToString:(NSArray *)array
{
    NSString *string = @"";
    
    for (int i = 0; i != array.count; i++)
    {
        string = [string stringByAppendingFormat:@"%d、",i+1];
        string = [string stringByAppendingFormat:@"%@\n", [array objectAtIndex:i]];
    }
    
    return string;
}
#pragma mark - 编辑翻译回调
- (BOOL)editSaveCallBack :(NSString*)str
{
    _textView.text = str;
    return YES;
}
@end
