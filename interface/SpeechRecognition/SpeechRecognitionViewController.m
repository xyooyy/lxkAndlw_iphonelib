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
    
    [sender removeTarget:self action:@selector(startRecogniseButtonTouch:) forControlEvents:UIControlEventTouchDown];
    [sender addTarget:self action:@selector(stopRecogniseButtonTouch:) forControlEvents:UIControlEventTouchDown];
    
    return YES;
}

- (BOOL)stopRecogniseButtonTouch:(UIButton *)sender
{
    SpeechRecognitionView *rootView = (SpeechRecognitionView *)self.view;
    [rootView stopRecogniseButtonTouchAnimation:sender];

    [sender removeTarget:self action:@selector(stopRecogniseButtonTouch:) forControlEvents:UIControlEventTouchDown];
    [sender addTarget:self action:@selector(startRecogniseButtonTouch:) forControlEvents:UIControlEventTouchDown];
    
    return YES;
}


@end
