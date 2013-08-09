//
//  EditViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EditViewController.h"
#import "EditTextView.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)loadView
{
    self.view = [[EditTextView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)setTextArray:(NSArray *)textArray
{
    for (NSString *item in textArray)
    {
        [(EditTextView *)(self.view) setText:item];
    }
    return YES;
}

@end
