//
//  RootViewController.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "SpeechRecognitionViewController.h"
#import "SpeechRecognitionView.h"
#import "data.h"

@interface SpeechRecognitionViewController ()

@end

@implementation SpeechRecognitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
}

- (void)loadView
{
    SpeechRecognitionView *rootView = [[SpeechRecognitionView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                                                          delegate:self];
    self.view = rootView;
}

- (BOOL)startRecogniseButtonTouch:(UIButton *)sender
{
    SpeechRecognitionView *rootView = (SpeechRecognitionView *)self.view;
    [rootView startRecogniseButtonTouchAnimation:sender];
    [rootView switchButton:sender
                 oldAction:@selector(startRecogniseButtonTouch:)
                withTarget:self
                 newAction:@selector(stopRecogniseButtonTouch:)
                withTarget:self];
    
    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(test) userInfo:nil repeats:YES];
    return YES;
}

- (BOOL)test
{
    SpeechRecognitionView *rootView = (SpeechRecognitionView *)self.view;
    [UIFont systemFontOfSize:16.f];
    static int number = 0;    
    NSArray *array = [NSArray arrayWithObjects:
                      @"google语音识别我阿斯顿发生地df发送到阿斯顿发生地方水电费",
                      @"adflkajdsfhkasdfhkajsdfhjkasdhfkjasd",
                      @"阿士大夫撒旦哈库拉水电费",
                      @"1547891235413289471234789", nil];
    [rootView addText:[array objectAtIndex:(number++ % [array count])]];
    return YES;
}

- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    SpeechRecognitionView *rootView = (SpeechRecognitionView *)self.view;
    [rootView stopRecogniseButtonTouchAnimation:sender];
    [rootView switchButton:sender
                 oldAction:@selector(stopRecogniseButtonTouch:)
                withTarget:self
                 newAction:@selector(startRecogniseButtonTouch:)
                withTarget:self];
    
    return YES;
}



@end
