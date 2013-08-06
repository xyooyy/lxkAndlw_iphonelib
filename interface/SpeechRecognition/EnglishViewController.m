//
//  EnglishViewController.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "EnglishViewController.h"

@interface EnglishViewController ()

@end

@implementation EnglishViewController

- (id)initWithSourceStr:(NSString *)str
{
    self = [super init];
    if(self)
    {
        sourceStr = str;
        translateRecognizeResult = [[TranslateRecognizeResult alloc]initWithData:self :@selector(translate:)];
        self.view.backgroundColor =[UIColor whiteColor];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[translateRecognizeResult translate:sourceStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - translate
- (BOOL)translate :(NSString*)englishStr
{
    return YES;
}
@end
