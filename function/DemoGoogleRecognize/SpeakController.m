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
        //history
        mCurrentFile = [[NSMutableString alloc]init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"history"];
        mHistory = [[NSMutableArray alloc]initWithContentsOfFile:path];
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
        //recognizer
        mRecognizer = [[ASGoogleVoiceRecognizer alloc]init];
        [mRecognizer setController:self andFunction:@selector(addText:)];
        //player
        mPlayer = [[AudioPlayer alloc]init];
    }
    return self;
}

//设置head
-(void)setHeadView
{
    [mHeadSpeakControlView setLeftBtnTitleWithString:@"开始说话"];
    [mHeadSpeakControlView setRightBtnTitleWithString:@"历史记录"];
    if (0==[mHistory count]) {
        [mHeadSpeakControlView disableRightBtn];
    }
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
    [mBodyContentView setTextRewirteAll:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    [mCurrentFile setString:[NSString stringWithFormat:@"%@.wav",dateTime]];
    [self ChangesWhenStart];
    [mRecognizer setFilePath:[NSString stringWithFormat:@"%@.wav",dateTime]];
    [mRecognizer startRecording];
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
    [mRecognizer stopRecording];
    NSMutableDictionary *dicHis = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mCurrentFile,@"file",[mBodyContentView getContent],@"text",nil];
    [mHistory addObject:dicHis];
    [self historyWriteToFile];
    [self ChangesWhenStop];
}

-(void)historyWriteToFile
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"history"];
    [mHistory writeToFile:path atomically:YES];
}

//停止时控件的变化
-(void)ChangesWhenStop
{
    [mHeadSpeakControlView setTitleWithString:@"准备说话"];
    [mHeadSpeakControlView setLeftBtnTitleWithString:@"开始说话"];
    [mPopupView showWithText:@"正在识别并保存" AndSuperView:self.view];
    if ([mHistory count]!=0) {
        [mHeadSpeakControlView enableRightBtn];
    }
    [mFootTextControlView enableAllButtons];
}

-(void)HistoryAction
{
    [mBodyContentView setTextRewirteAll:@""];
    HistorySelectController *hisController = [[HistorySelectController alloc]initWithHistory:mHistory];
    [self.navigationController pushViewController:hisController animated:YES];
}

/*
    处理来自文字控制区域是请求
 */

-(void)EditAction
{
    EditController *editControl= [[EditController alloc]initWithContentText:[NSString stringWithString:[mBodyContentView getContent]] andPreController:self AndSavaSEL:@selector(changeText:)];
    [self.navigationController pushViewController:editControl animated:YES]; 
}

-(void)ReadAction
{
    //加载文件路径
    [mPlayer setSoundName:mCurrentFile];
    [mPlayer startPlay];
    [mPopupView showWithText:@"正在重复您所说的话。。。" AndSuperView:self.view];
}

-(void)TranslateAction
{
    NSString *string = [[NSString alloc]initWithString:[mBodyContentView getContent]];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    TranslateController *translateController = [[TranslateController alloc]initWithContentText:string];
    [self.navigationController pushViewController:translateController animated:YES];
}

//保存修改的数据
-(void)changeText:(NSMutableString *)aStr
{
    [mBodyContentView setTextRewirteAll:aStr];
}

-(void)addText:(NSString *)aStr
{
    
    [mBodyContentView AddTextAtEnd:aStr];
}
@end
