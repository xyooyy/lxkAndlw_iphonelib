//
//  EditViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditViewController.h"
#import "EditTableView.h"
#import "PopupView.h"
#import "DataProcessing.h"
#import "TextViewScroll.h"
#import "Data.h"
#import "EditHistoryRecordViewController.h"
#define kTableViewCellHeight 30.f
#define kTableViewBorderRadius 10.f

@interface EditViewController ()
{
    EditTableView *_tableView;
    NSString *_savePath;
    DataProcessing *_data;
    TextViewScroll *_textView;
    NSMutableArray *_dataArray;
    NSMutableArray *_soundDataArray;
    
}
@end

@implementation EditViewController

- (id)initWithData:(DataProcessing *)data
{
    self = [super init];
    if (self)
    {
        _data = data;
        NSArray *keySet = [_data getKeySet];
        _soundDataArray = [[NSMutableArray alloc]init];
        _dataArray = [[NSMutableArray alloc]init];
        for (NSString *key in keySet)
        {
            [_dataArray addObject:[[_data getDic] objectForKey:key]];
            [_soundDataArray addObject:key];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int tableView_height = screenHeight == 480?350:(350+screenHeight - 480);
    int operation_Org_Y = tableView_height == 350?375:(375+screenHeight - 480);
    
    
    _tableView = [[EditTableView alloc] initWithFrame:CGRectMake(15, 15, 290, tableView_height) andData:_data];
    [_tableView setSelectCallBack:self :@selector(selectAction::)];
    
    
    [self.view addSubview:_tableView];
    
    UIButton *backButton = [self addButtonWithImageNamed:kImageReturnButton
                                                    rect:CGRectMake(0, 0, 70, 29)
                                                delegate:self
                                                  action:@selector(backButtonTouch:)
                                                  toView:nil];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *completionButton = [self addButtonWithImageNamed:kImageCompletionButton
                                                          rect:CGRectMake(0, 0, 70, 29)
                                                      delegate:self
                                                        action:@selector(completionButtonTouch:)
                                                        toView:nil];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completionButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [self addButtonWithImageNamed:kImageCopyButton
                             rect:CGRectMake(15, operation_Org_Y, 135, 30)
                         delegate:self
                           action:@selector(copyButtonTouch:)
                           toView:self.view];
    
    [self addButtonWithImageNamed:kImageSaveButton
                             rect:CGRectMake(170, operation_Org_Y, 135, 30)
                         delegate:self
                           action:@selector(saveButtonTouch:)
                           toView:self.view];
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

- (BOOL)setSavePath:(NSString *)path
{
    _savePath = path;
    return YES;
}

- (BOOL)setTextViewScroll:(TextViewScroll *)textView
{
    _textView = textView;
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
    NSLog(@"copy string is :%@", [_tableView getTextStringInEditView]);
    [pasteboard setString:[_tableView getTextStringInEditView]];

    return YES;
}

- (BOOL)saveButtonTouch:(UIButton *)sender
{
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
    NSArray *newTextArray = [_tableView getTextArrayStringInEditView];
    NSArray *soundDataArray = [_tableView getSoundDataArray];
    
    for (int i = 0; i < newTextArray.count; i++)
    {
        [newDictionary setObject:[newTextArray objectAtIndex:i] forKey:[soundDataArray objectAtIndex:i]];
    }
    
    if (![newDictionary writeToFile:_savePath atomically:YES])
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
#pragma mark - 设置保存完成
- (BOOL)setEditCompleteCallBack:(id)parmObj :(SEL)parmAction
{
    obj = parmObj;
    action = parmAction;
    return YES;
}

#pragma mark - 单元格点击回调
- (void)selectAction :(NSIndexPath*)indexPath :(NSString*)str
{
    currentIndex = indexPath;
    EditHistoryRecordViewController *view = [[EditHistoryRecordViewController alloc]init];
    [view setTextString:str];
    [view saveButtonCallBack:self :@selector(editSaveCallBack:)];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - 编辑保存回调
- (void)editSaveCallBack :(NSString*)editStr
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:currentIndex];
    if([editStr isEqual:@""]||[[editStr stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])
        editStr = @"--";
    cell.textLabel.text = editStr;
    [_tableView upDateSourceData:editStr :currentIndex];
}
@end
