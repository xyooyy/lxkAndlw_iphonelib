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

- (id)initWithData :(NSString*)parmSourceStr :(NSString*)parmDestStr :(id)parmObj :(SEL)parmAction
{
    self = [super init];
    if(self)
    {
        sourceStr = parmSourceStr;
        destStr = parmDestStr;
        obj = parmObj;
        action = parmAction;
        translateRecognizeResult = [[TranslateRecognizeResult alloc]initWithData:self :@selector(translateFinished::)];
        self.view.backgroundColor =[UIColor whiteColor];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!destStr)
	[translateRecognizeResult translate:sourceStr];
}
- (void)translateFinished :(NSString*)parmSourceStr :(NSString*)parmDestStr
{
    [obj performSelector:action withObject:parmSourceStr withObject:parmDestStr];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
