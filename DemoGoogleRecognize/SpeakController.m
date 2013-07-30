//
//  SpeakController.m
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "SpeakController.h"

@interface SpeakController ()

@end

@implementation SpeakController


-(id)init
{
    self = [super init];
    if (self) {
        
        //head
        mHeadSpeakControlView = [[HeadControlView alloc]initWithSuperViewCGRect:self.view.frame AndTitle:@"准备识别"];
        [self setHeadView];
        //foot
        mFootTextControlView = [[FootTextControlView alloc]initWithSuperViewRect:self.view.frame];
        [self setFootView];
        [self.view addSubview:mFootTextControlView];
        
        //body
        mBodyContentView = [[BodyContentView alloc]initWithSuperViewRect:self.view.frame];
        [self.view addSubview:mBodyContentView];
        //popupView
        mPopupView = [[PopupView alloc]initWithFrame:CGRectMake(100, 360, 0, 0)];
        mPopupView.ParentView = self.view;
        //config
        [self setActinsForControl];
        
        //data
        mResult = [[NSMutableString alloc]init];
        
        //recognizer
        mRecognizer = [[ASGoogleVoiceRecognizer alloc]init];
        [mRecognizer setController:self andFunction:@selector(changeResult:)];
    }
    return self;
}

//设置head
-(void)setHeadView
{
    [mHeadSpeakControlView setLeftBtnTitleWithString:@"开始说话"];
    [mHeadSpeakControlView setRightBtnTitleWithString:@"历史记录"];
    [mHeadSpeakControlView showLeftBtn];
    [mHeadSpeakControlView showRightBtn];
    [mHeadSpeakControlView setControllerWithID:self];
    [mHeadSpeakControlView setLeftBtnPressCallBackWithSEL:@selector(ControlButtonPressed)];
    [mHeadSpeakControlView setRightBtnPressCallBackWithSEL:@selector(HistoryAction)];
    [self.view addSubview:mHeadSpeakControlView];
}
//设置Foot
-(void)setFootView
{
    [mFootTextControlView setBtnLTitleWithText:@"编辑文字"];
    [mFootTextControlView setBtnMTitleWithText:@"朗读文字"];
    [mFootTextControlView setBtnRTitleWithText:@"翻译文字"];
    [mFootTextControlView showBtnLandR];
    [mFootTextControlView showBtnM];
}


//为foot中按钮设置点击回调函数
-(void)setActinsForControl
{
    [mFootTextControlView setController:self];
    [mFootTextControlView setBtnLPressCall:@selector(EditAction)];
    [mFootTextControlView setBtnRPressCall:@selector(TranslateAction)];
    [mFootTextControlView setBtnMPressCall:@selector(ReadAction)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [mBodyContentView setTextRewirteAll:mResult];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
    处理来自录音控制请求
 */

-(void)ControlButtonPressed
{
    
    isSpeaking = ~isSpeaking;
    if (!isSpeaking) {
        [self SpeakStop];
    }
    else [self SpeakStart];
    
}
-(void)SpeakStart
{
    [self ChangesWhenStart];
    mFilePath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    
    [mRecognizer setSaveFile:mFilePath];
    
    [mRecognizer startRecording];
//
//    NSData *wavData = [[NSData alloc]initWithContentsOfFile:filePath];
//    [mRecognizer upLoadWAV:wavData];
//    [wavData autorelease];
    //[mRecognizer startRecording];
}

//开始时控件的变化
-(void)ChangesWhenStart
{
    [mHeadSpeakControlView setTitleWithString:@"正在说话..."];
    [mHeadSpeakControlView setLeftBtnTitleWithString:@"停止说话"];
    [mPopupView showWithText:@"可以开始说话了" AndSuperView:self.view];
    [mHeadSpeakControlView disableRightBtn];
    [mFootTextControlView disbleAllButtons];
}


-(void)SpeakStop
{
    [self ChangesWhenStop];
    [mRecognizer stopRecording];
}

//停止时控件的变化
-(void)ChangesWhenStop
{
    [mHeadSpeakControlView setTitleWithString:@"准备说话"];
    [mHeadSpeakControlView setLeftBtnTitleWithString:@"开始说话"];
    [mPopupView showWithText:@"正在识别并保存" AndSuperView:self.view];
    [mHeadSpeakControlView enableRightBtn];
    [mFootTextControlView enableAllButtons];
}

-(void)HistoryAction
{
    [mPopupView showWithText:@"没有历史记录" AndSuperView:self.view];
}

/*
    处理来自文字控制区域是请求
 */

-(void)EditAction
{
    NSString *str = [[[NSString alloc]initWithString:mResult]autorelease];
    EditController *editControl= [[EditController alloc]initWithContentText:str andPreController:self];
    [self.navigationController pushViewController:editControl animated:YES]; 
}

-(void)ReadAction
{
   // NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"wav"];
    
    //NSData *wavData = [[NSData alloc]initWithContentsOfURL:mFilePath];
    //NSData *wav = [[NSData alloc]initWithContentsOfFile:filePath];
   // [mRecognizer startPlaying:wav];
   // [mRecognizer upLoadWAV:wav];
    [mRecognizer playSelf];
    [mPopupView showWithText:@"正在重复您所说的话。。。" AndSuperView:self.view];
}

-(void)TranslateAction
{
    TranslateController *translateController = [[TranslateController alloc]initWithContentText:@"翻译文字"];
    [self.navigationController pushViewController:translateController animated:YES];
}

//保存修改的数据
-(void)changeResult:(NSMutableString *)aStr
{
    mResult = aStr;
    [mBodyContentView setTextRewirteAll:aStr];
}
@end
