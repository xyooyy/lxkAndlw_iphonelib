//
//  EditController.m
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "EditController.h"

@interface EditController ()

@end

@implementation EditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContentText:(NSString *)aStrText andPreController:(id)aPreCon AndSavaSEL:(SEL)aSEL
{
    self=[super init];
    if (self) {
        //head控制视图
        mHeadControllView = [[HeadControlView alloc]initWithSuperViewCGRect:self.view.frame AndTitle:@"编辑文字"];
        [mHeadControllView setControllerWithID:self];
        [self setHeadView];
        [self.view addSubview:mHeadControllView];
        
        //内容view
        mBodyContentView = [[BodyContentView alloc]initWithSuperViewRect:self.view.frame];
        [mBodyContentView enableEdit];
        [mBodyContentView setTextRewirteAll:aStrText];
        [self.view addSubview:mBodyContentView];
        
        //foot控制视图
        mFootTextControlView = [[FootTextControlView alloc]initWithSuperViewRect:self.view.frame];
        [self configFootView];
        [self.view addSubview:mFootTextControlView];
        mPopupView = [[PopupView alloc]initWithFrame:CGRectMake(100, 360, 0, 0)];
        [mPopupView setParentView:self.view];
        
        mPreController = aPreCon;
        mSelSaveText = aSEL;
        
    }
    return self;
}


-(void)configFootView
{
    [mFootTextControlView setController:self];
    [mFootTextControlView setBtnLTitleWithText:@"复制文字"];
    [mFootTextControlView setBtnLPressCall:@selector(CopyPressed)];
    [mFootTextControlView setBtnRTitleWithText:@"保存文字"];
    [mFootTextControlView setBtnRPressCall:@selector(SavePressd)];
    [mFootTextControlView showBtnLandR];
}
-(void)setHeadView
{
    [mHeadControllView setLeftBtnTitleWithString:@"返回"];
    [mHeadControllView setRightBtnTitleWithString:@"完成"];
    [mHeadControllView showRightBtn];
    [mHeadControllView showLeftBtn];
    [mHeadControllView setLeftBtnPressCallBackWithSEL:@selector(BackToMain)];
    [mHeadControllView setRightBtnPressCallBackWithSEL:@selector(CloseKeyBoard)];
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

-(void)CloseKeyBoard
{
    [mBodyContentView ExitKeyBoard];
}

-(void)CopyPressed
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[mBodyContentView getContent]];
    [mPopupView showWithText:@"已复制" AndSuperView:self.view];
}

-(void)SavePressd
{
    NSString *str = [[NSString alloc]initWithString:[mBodyContentView getContent]];
    [mPreController performSelector:mSelSaveText withObject:str];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
