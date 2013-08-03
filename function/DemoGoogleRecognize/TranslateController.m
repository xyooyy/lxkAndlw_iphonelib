//
//  TranslateController.m
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/18/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "TranslateController.h"
#import "SBJson.h"

@interface TranslateController ()

@end

@implementation TranslateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContentText:(NSString *)aStrText
{
    self=[super init];
    if (self) {
        //head控制视图
        mHeadControllView = [[HeadControlView alloc]initWithSuperViewCGRect:self.view.frame AndTitle:@"翻译文字"];
        [mHeadControllView setControllerWithID:self];
        [self setHeadView];
        [self.view addSubview:mHeadControllView];
        
        //内容view
        mBodyContentView = [[BodyContentView alloc]initWithSuperViewRect:self.view.frame];
        [mBodyContentView disableEdit];
        [self.view addSubview:mBodyContentView];
        
        //foot控制视图
        mFootTextControlView = [[FootTextControlView alloc]initWithSuperViewRect:self.view.frame];
        [self configFootView];
        [self.view addSubview:mFootTextControlView];
        
        mPopupView = [[PopupView alloc]initWithFrame:CGRectMake(100, 360, 0, 0)];
        [mPopupView setParentView:self.view];
        
        mTrans = [[Translator alloc]initWithQuestion:aStrText andDelegate:self];
        [mTrans TranslateString];
        mResult = [[NSMutableData alloc]init];
        mStrResult = [[NSMutableString alloc]init];
    }
    return self;
}
-(void)configFootView
{
    [mFootTextControlView setController:self];
    [mFootTextControlView setBtnLTitleWithText:@"编辑文字"];
    [mFootTextControlView setBtnLPressCall:@selector(EditPressed)];
    [mFootTextControlView setBtnRTitleWithText:@"复制文字"];
    [mFootTextControlView setBtnRPressCall:@selector(CopyPressed)];
    [mFootTextControlView showBtnLandR];
}
-(void)setHeadView
{
    [mHeadControllView setLeftBtnTitleWithString:@"返回"];
    [mHeadControllView showLeftBtn];
    [mHeadControllView setLeftBtnPressCallBackWithSEL:@selector(BackToMain)];
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

-(void)BackToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

//foot控制按钮事件函数实现
-(void)EditPressed
{
    EditController *editController = [[EditController alloc]initWithContentText:[NSString stringWithString:[mBodyContentView getContent]] andPreController:self AndSavaSEL:@selector(EditSave:)];
    [self.navigationController pushViewController:editController animated:YES];
}
-(void)CopyPressed
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[mBodyContentView getContent]];
    [mPopupView showWithText:@"已复制" AndSuperView:self.view];
}
//transDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mResult appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: [parser objectWithData:mResult]];
    mStrResult = [[[dic objectForKey:@"trans_result"] objectAtIndex:0] objectForKey:@"dst"];
    [mBodyContentView setTextRewirteAll:mStrResult];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response");
}

-(void)EditSave:(NSString *)aStr
{
    [mBodyContentView setTextRewirteAll:aStr];
}

@end
