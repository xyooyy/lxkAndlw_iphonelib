//
//  EditTranslateController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-12.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditTranslateController.h"
#import "Data.h"

@implementation EditTranslateController

- (id)init
{
    self = [super init];
    if(self)
    {
        m_textView = [[UITextView alloc]init];
    }
    return self;
}
- (BOOL)createOperationButton
{
    UIButton *completionButton = [self addButtonWithImageNamed:kImageCompletionButton
                                                          rect:CGRectMake(kFloatZero, kFloatZero, NAVIGATION_BTN_WIDTH, NAVIGATION_BTN_HEIGHT)
                                                      delegate:self
                                                        action:@selector(completionButtonTouch:)
                                                        toView:nil];
    UIButton *backButton = [self addButtonWithImageNamed:kImageReturnButton
                                                    rect:CGRectMake(kFloatZero, kFloatZero, NAVIGATION_BTN_WIDTH, NAVIGATION_BTN_HEIGHT)
                                                delegate:self
                                                  action:@selector(backButtonTouch:)
                                                  toView:nil];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completionButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int textView_height = screenHeight == IPHONE4_SCREEN_HEIGHT?TABLEVIEW_HEIGHT:(TABLEVIEW_HEIGHT+screenHeight - IPHONE4_SCREEN_HEIGHT);
    int operationBtn_Org_Y = textView_height == TABLEVIEW_HEIGHT?OPERATON_BTN_ORG_Y:(OPERATON_BTN_ORG_Y+screenHeight - IPHONE4_SCREEN_HEIGHT);
    m_textView .frame = CGRectMake(TEXTVIEW_ORG_X, TEXTVIEW_ORG_Y, TEXTVIEW_WIDTH, textView_height);
    m_textView.backgroundColor = RGBA(COLOR_R, COLOR_G, COLOR_B, COLOR_A);
    m_textView.textColor = [UIColor whiteColor];
    [self.view addSubview:m_textView];
    [self createOperationButton];
    [self addButtonWithImageNamed:kImageBigSaveButton
                             rect:CGRectMake(TEXTVIEW_ORG_X, operationBtn_Org_Y, TEXTVIEW_WIDTH, SAVE_BTN_HEIGHT)
                         delegate:self
                           action:@selector(saveButtonTouch:)
                           toView:self.view];
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

- (BOOL)setTextString:(NSString *)string
{
    m_textView.text = string;

    return YES;
}

- (BOOL)setSavePath:(NSString *)path
{
    m_savePath = path;
    return YES;
}

#pragma mark - 按钮事件

- (BOOL)completionButtonTouch:(id)sender
{
    // 获得当前firstResponder
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    return YES;
}

- (BOOL)backButtonTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (BOOL)setEditSaveCallBack:(id)parmObj :(SEL)parmAction
{
    obj = parmObj;
    editSaveAction = parmAction;
    return YES;
}
- (BOOL)saveButtonTouch:(UIButton *)sender
{
    [obj performSelector:editSaveAction withObject:m_textView.text];
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}


@end
