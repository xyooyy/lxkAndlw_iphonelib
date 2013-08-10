//
//  EditViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditViewController.h"
#import "PopupView.h"

@interface EditViewController ()
{
    UITextView *_textView;
    NSString *_savePath;
}
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    
    // 添加键盘上面的工具条
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    toolbar.barStyle = UIBarStyleBlack;
    
    // 占位符
    UIBarButtonItem * blank1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:self action:nil];
    UIBarButtonItem * blank2 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:self action:nil];
    // 完成按钮
    UIBarButtonItem *completionButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(completionButtonTouch:)];
    NSArray *buttonItemArray = [NSArray arrayWithObjects:blank1, blank2, completionButtonItem, nil];
    [toolbar setItems:buttonItemArray];
    [_textView setInputAccessoryView:toolbar];
    
    [self.view addSubview:_textView];

    [self addButtonWithNamed:@"复制"
                        rect:CGRectMake(160, 6, 70, 30)
                    delegate:self
                      action:@selector(copyButtonTouch:)];
    [self addButtonWithNamed:@"保存"
                        rect:CGRectMake(250, 6, 70, 30)
                    delegate:self
                      action:@selector(saveButtonTouch:)];
}

// 创建一个按钮，并添加到self中
- (UIButton *) addButtonWithNamed:(NSString *)name
                             rect:(CGRect)rect
                         delegate:(id)delegate
                           action:(SEL)action
{
    UINavigationBar *navbar = self.navigationController.navigationBar;

    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button setTitle:name forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchDown];
    button.backgroundColor = [UIColor blackColor];
    [navbar addSubview:button];
    
    return button;
}

- (BOOL)setSavePath:(NSString *)path
{
    _savePath = path;
    return YES;
}

- (BOOL)setTextArray:(NSArray *)textArray
{
    NSString *text = @"";
    for (NSString *item in textArray)
    {
        text = [text stringByAppendingFormat:@"%@\n", item];
    }
    [_textView setText:text];
    return YES;
}

- (BOOL)setTextString:(NSString *)textString
{
    [_textView setText:textString];
    return YES;
}

#pragma mark - 按钮事件

- (BOOL)completionButtonTouch:(UIButton *)sender
{
    [_textView resignFirstResponder];
    return YES;
}

- (BOOL)copyButtonTouch:(UIButton *)sender
{
    PopupView *popupView = [[PopupView alloc] init];
    [popupView showWithText:@"复制成功"
               AndSuperView:self.view
                  andHeight:self.view.frame.size.height * 0.4];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[_textView text]];

    return YES;
}

- (BOOL)saveButtonTouch:(UIButton *)sender
{
    NSError *error;
    if (![[_textView text] writeToFile:_savePath atomically:YES encoding:NSUTF8StringEncoding error:&error])
        NSLog(@"%s error :%@", __func__, error.description);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

@end
