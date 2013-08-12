//
//  EditTranslateController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-12.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditTranslateController.h"
#import "Data.h"

@interface EditTranslateController ()
{
    UITextView *_textView;
    NSString *_savePath;
}
@end

@implementation EditTranslateController

- (id)init
{
    self = [super init];
    if (self)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, 290, 350)];
        _textView.backgroundColor = RGBA(27.f, 26.f, 24.f, 1.f);
        _textView.textColor = [UIColor whiteColor];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:_textView];
    
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

    [self addButtonWithImageNamed:kImageBigSaveButton
                             rect:CGRectMake(15, 373, 290, 34)
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
    _textView.text = string;

    return YES;
}

- (BOOL)setSavePath:(NSString *)path
{
    _savePath = path;
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

- (BOOL)saveButtonTouch:(UIButton *)sender
{
    NSError *error;
    if (![_textView.text writeToFile:_savePath atomically:YES encoding:NSUTF8StringEncoding error:&error])
        NSLog(@"%@", error);
    
    return YES;
}

@end
