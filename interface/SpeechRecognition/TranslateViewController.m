//
//  EditViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TranslateViewController.h"
#import "EditTranslateController.h"
#import "PopupView.h"
#import "Data.h"

@implementation TranslateViewController

- (id)initWithString:(NSString *)string :(NSString*)savePath
{
    if (self = [super init])
    {
        m_savePath = savePath;
        [self createTranslate:string];
    }
    return self;
}

- (BOOL)createTextView :(int)tableView_height
{
    m_textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, 290, tableView_height)];
    m_textView.editable = NO;
    m_textView.backgroundColor = [UIColor clearColor];
    m_textView.textColor = [UIColor whiteColor];
    [self.view addSubview:m_textView];
    return YES;
}
- (BOOL)createTranslate :(NSString*)translateStr
{
    m_translate = [[TranslateRecognizeResult alloc] initWithData:self :@selector(translate:result:)];
    [m_translate translate:translateStr];
    return YES;
}

- (BOOL)createBackButton
{
    UIButton *backButton = [self addButtonWithImageNamed:kImageReturnButton
                                                    rect:CGRectMake(kFloatZero, kFloatZero, NAVIGATION_BTN_WIDTH, NAVIGATION_BTN_HEIGHT)
                                                delegate:self
                                                  action:@selector(backButtonTouch:)
                                                  toView:nil];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    return YES;
}
- (BOOL)createOperationButton :(int)operation_Org_Y
{
    [self addButtonWithImageNamed:kImageEditButton
                             rect:CGRectMake(OPERATION_COPYBTN_ORG_X, operation_Org_Y, OPERATION_COPYBTN_WIDTH, OPERATION_COPYBTN_HEIGHT)
                         delegate:self
                           action:@selector(editButtonTouch:)
                           toView:self.view];
    
    [self addButtonWithImageNamed:kImageRedCopyButton
                             rect:CGRectMake(OPERATION_SAVEBTN_ORG_X, operation_Org_Y, OPERATION_SAVEBTN_WIDTH, OPERATION_SAVEBTN_HEIGHT)
                         delegate:self
                           action:@selector(copyButtonTouch:)
                           toView:self.view];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int textView_height = screenHeight == IPHONE4_SCREEN_HEIGHT?TEXTVIEW_HRIGHT:(TEXTVIEW_HRIGHT+screenHeight - IPHONE4_SCREEN_HEIGHT);
    int operation_Org_Y = textView_height == TEXTVIEW_HRIGHT?OPERATON_BTN_ORG_Y:(OPERATON_BTN_ORG_Y+screenHeight - IPHONE4_SCREEN_HEIGHT);
    
    [self addImageWithName:kImageCD
                     frame:CGRectMake(kImageCDAfterX, kImageCDAfterY,
                                      kImageCDAfterWidth, kImageCDAfterHeight)];
    [self createTextView:textView_height];
    [self createBackButton];
    [self createOperationButton:operation_Org_Y];
    
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
    m_savePath = path;
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
    [pasteboard setString:m_textView.text];
    return YES;
}

- (BOOL)editButtonTouch:(UIButton *)sender
{
    EditTranslateController *editTranslateController = [[EditTranslateController alloc] init];
    //[editTranslateController setSavePath:_savePath];
    [editTranslateController setTextString:m_textView.text];
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
    [m_textView setText:[self arrayToString:resultArray]];
    return YES;
}

- (NSString *)arrayToString:(NSArray *)array
{
    NSString *string = @"";
    for (int i = 0; i != array.count; i++)
         string = [string stringByAppendingFormat:@"%@\n", [array objectAtIndex:i]];
    return string;
}
#pragma mark - 编辑翻译回调
- (BOOL)editSaveCallBack :(NSString*)str
{
    m_textView.text = str;
    return YES;
}
@end
