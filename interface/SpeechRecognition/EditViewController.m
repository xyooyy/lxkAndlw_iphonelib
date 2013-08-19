//
//  EditViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditViewController.h"
#import "PopupView.h"
#import "Data.h"
#import "EditView.h"
#define kTableViewCellHeight 30.f
#define kTableViewBorderRadius 10.f

@implementation EditViewController

#pragma mark - 初始化函数
- (id)initWithData:(DataProcessing *)data
{
    self = [super init];
    if (self)
    {
        m_data = data;
    }
    return self;
}
#pragma mark - viewDidLoad

- (BOOL)createTableView :(int)tableView_height
{
    m_tableView = [[EditTableView alloc] initWithFrame:CGRectMake(TABLEVIEW_ORG_X, TABLEVIEW_ORG_Y, TABLEVIEW_WIDTH, tableView_height) andData:m_data];
    [m_tableView setSelectCallBack:self :@selector(selectAction::)];
    [self.view addSubview:m_tableView];
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
- (BOOL)createRightButton
{
    UIButton *completionButton = [self addButtonWithImageNamed:kImageCompletionButton
                                                          rect:CGRectMake(kFloatZero, kFloatZero, NAVIGATION_BTN_WIDTH, NAVIGATION_BTN_HEIGHT)
                                                      delegate:self
                                                        action:@selector(completionButtonTouch:)
                                                        toView:nil];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completionButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    return YES;
}
- (BOOL)createFootOperationButton :(int)operationBtn_Org_Y
{
    [self addButtonWithImageNamed:kImageCopyButton
                             rect:CGRectMake(OPERATION_COPYBTN_ORG_X, operationBtn_Org_Y, OPERATION_COPYBTN_WIDTH, OPERATION_COPYBTN_HEIGHT)
                         delegate:self
                           action:@selector(copyButtonTouch:)
                           toView:self.view];
    
    [self addButtonWithImageNamed:kImageSaveButton
                             rect:CGRectMake(OPERATION_SAVEBTN_ORG_X, operationBtn_Org_Y, OPERATION_SAVEBTN_WIDTH, OPERATION_SAVEBTN_HEIGHT)
                         delegate:self
                           action:@selector(saveButtonTouch:)
                           toView:self.view];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int tableView_height = screenHeight == IPHONE4_SCREEN_HEIGHT?TABLEVIEW_HEIGHT:(TABLEVIEW_HEIGHT+screenHeight - IPHONE4_SCREEN_HEIGHT);
    int operationBtn_Org_Y = tableView_height == TABLEVIEW_HEIGHT?OPERATON_BTN_ORG_Y:(OPERATON_BTN_ORG_Y+screenHeight - IPHONE4_SCREEN_HEIGHT);
    
    [self createTableView:tableView_height];
    [self createBackButton];
    [self createRightButton];
    [self createFootOperationButton:operationBtn_Org_Y];
    
    
}

// 创建一个按钮，并添加到self中
- (UIButton *)addButtonWithImageNamed:(NSString *)name
                                 rect:(CGRect)rect
                             delegate:(id)parmDelegate
                               action:(SEL)parmAction
                               toView:(UIView *)view
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    UIImage *image = [UIImage imageNamed:name];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:parmDelegate action:parmAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
   
    return button;
}

#pragma mark - 接口函数
- (BOOL)setSavePath:(NSString *)path
{
    m_savePath = path;
    return YES;
}

- (BOOL)setTextViewScroll:(TextViewScroll *)textView
{
    m_textView = textView;
    return YES;
}

- (BOOL)setEditCompleteCallBack:(id)parmObj :(SEL)parmAction
{
    obj = parmObj;
    action = parmAction;
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

- (BOOL)copyButtonTouch:(UIButton *)sender
{
    PopupView *popupView = [[PopupView alloc] init];
    [popupView showWithText:@"复制成功"
               AndSuperView:self.view
                  andHeight:self.view.frame.size.height * 0.7];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[m_tableView getTextStringInEditView]];
    return YES;
}

- (NSMutableDictionary*)upDateData :(NSArray*)newTextArray :(NSArray*)soundDataArray
{
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < newTextArray.count; i++)
    {
        NSString *str = [newTextArray objectAtIndex:i];
        if(![str isEqualToString:@"--"])
            [newDictionary setObject:str forKey:[soundDataArray objectAtIndex:i]];
    }
    return newDictionary;

}
- (BOOL)saveButtonTouch:(UIButton *)sender
{
    
    NSArray *newTextArray = [m_tableView getTextArrayStringInEditView];
    NSArray *soundDataArray = [m_tableView getSoundDataArray];
    NSMutableDictionary *newDictionary = [self upDateData:newTextArray :soundDataArray];
    
    if (![newDictionary writeToFile:m_savePath atomically:YES])
        NSLog(@"%s error", __func__);
    
    [obj performSelector:action withObject:newDictionary];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

- (BOOL)backButtonTouch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}


#pragma mark - 单元格点击回调
- (void)selectAction :(NSIndexPath*)indexPath :(NSString*)str
{
    m_currentIndex = indexPath;
    EditView *view = [[EditView alloc]init];
    [view setTextString:str];
    [view setEditSaveCallBack:self :@selector(editSaveCallBack:)];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - 编辑保存回调
- (void)editSaveCallBack :(NSString*)editStr
{
    UITableViewCell *cell = [m_tableView cellForRowAtIndexPath:m_currentIndex];
    if([editStr isEqual:@""]||[[editStr stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])
        editStr = @"--";
    cell.textLabel.text = editStr;
    [m_tableView upDateSourceData:editStr :m_currentIndex];
}
@end
