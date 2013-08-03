//
//  HistoryViewController.m
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/26/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithHistory:(NSMutableArray *)aHistory AndCurrentRow:(int)aIndex
{
    self = [super init];
    if (self) {
        mPlayer = [[AudioPlayer alloc]init];
        mHistory = [[NSMutableArray alloc]initWithArray:aHistory];
        curRow = aIndex;
        mHead = [[HeadControlView alloc]initWithSuperViewCGRect:self.view.frame AndTitle:@"历史内容"];
        mBody = [[BodyContentView alloc]initWithSuperViewRect:self.view.frame];
        mFoot = [[FootTextControlView alloc]initWithSuperViewRect:self.view.frame];
        
        [mHead setLeftBtnTitleWithString:@"返回"];
        [mHead setControllerWithID:self];
        [mHead setLeftBtnPressCallBackWithSEL:@selector(backToList)];
        [mHead showLeftBtn];
        
        [mBody setTextRewirteAll:[[mHistory objectAtIndex:curRow] objectForKey:@"text"]];
        [mBody disableEdit];
        
        [mFoot setBtnLTitleWithText:@"编辑文字"];
        [mFoot setBtnMTitleWithText:@"播放录音"];
        [mFoot setBtnMPressCall:@selector(playVoice)];
        [mFoot setBtnRTitleWithText:@"翻译文字"];
        [mFoot setBtnRPressCall:@selector(translateText)];
        [mFoot setController:self];
        [mFoot setBtnLPressCall:@selector(EditHistory)];
        [mFoot showBtnLandR];
        [mFoot showBtnM];
        [self.view addSubview:mHead];
        [self.view addSubview:mBody];
        [self.view addSubview:mFoot];
    }
    return self;
}

-(void)EditHistory
{
    EditController * editor = [[EditController alloc]initWithContentText:[[mHistory objectAtIndex:curRow] objectForKey:@"text"] andPreController:self AndSavaSEL:@selector(SaveChanges:)];
    [self.navigationController pushViewController:editor animated:YES];
}

-(void)translateText
{
    NSString *string =[[NSString alloc]initWithString:[mBody getContent]];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    TranslateController *translateController = [[TranslateController alloc]initWithContentText:string];
    [self.navigationController pushViewController:translateController animated:YES];
}
-(void)backToList
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SaveChanges:(NSString *)str
{
    [[mHistory objectAtIndex:curRow] setObject:str forKey:@"text"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"history"];
    [mHistory writeToFile:path atomically:YES];
    [mBody setTextRewirteAll:[[mHistory objectAtIndex:curRow] objectForKey:@"text"]];
}

-(void)playVoice
{
    [mPlayer setSoundName:[[mHistory objectAtIndex:curRow] objectForKey:@"file"]];
    [mPlayer startPlay];
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

@end
