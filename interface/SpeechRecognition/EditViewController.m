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

@interface EditViewController ()
{
    EditTableView *_tableView;
    NSString *_savePath;
    DataProcessing *_data;
    TextViewScroll *_textView;
    
}
@end

@implementation EditViewController

- (id)initWithData:(DataProcessing *)data
{
    self = [super init];
    if (self)
    {
        _data = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[EditTableView alloc] initWithFrame:CGRectMake(15, 15, 290, 350) andData:_data];
    
    [self.view addSubview:_tableView];
    
//    [self addButtonWithImageNamed:kImageCompletionButton
//                             rect:CGRectMake(200, 5, 70, 29)
//                         delegate:self
//                           action:@selector(completionButtonTouch:)
//                           toView:self.navigationController.navigationBar];
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kImageCompletionButton]
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(completionButtonTouch:)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(completionButtonTouch:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    
    [self addButtonWithImageNamed:kImageCopyButton
                             rect:CGRectMake(15, 375, 135, 30)
                         delegate:self
                           action:@selector(copyButtonTouch:)
                           toView:self.view];
    
    [self addButtonWithImageNamed:kImageSaveButton
                             rect:CGRectMake(170, 375, 135, 30)
                         delegate:self
                           action:@selector(saveButtonTouch:)
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
    [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
     button.tintColor = [UIColor whiteColor];
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

- (BOOL)completionButtonTouch:(UIButton *)sender
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
    [pasteboard setString:[_tableView getTextStringInEditView]];

    return YES;
}

- (BOOL)saveButtonTouch:(UIButton *)sender
{
    NSLog(@"%s-->%@", __func__, _savePath);
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
    NSArray *newTextArray = [_tableView getTextArrayStringInEditView];
    NSArray *oldTextArray = [_tableView getTExtArrayArrayInData];
    NSDictionary *oldDictionary = [_data getDic];
    
    for (int i = 0; i < oldTextArray.count; i++)
    {
        NSString *oldKey = [oldTextArray objectAtIndex:i];
        NSString *newKey = [newTextArray objectAtIndex:i];
        [newDictionary setObject:[oldDictionary objectForKey:oldKey] forKey:newKey];
    }

    if (![newDictionary writeToFile:_savePath atomically:YES])
        NSLog(@"%s error", __func__);
    
    [_data setDictionary:newDictionary];
    
    [_textView clearData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

@end
