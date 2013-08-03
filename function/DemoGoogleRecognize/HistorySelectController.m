//
//  HistoryViewController.m
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/26/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "HistorySelectController.h"

@interface HistorySelectController ()

@end

@implementation HistorySelectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithHistory:(NSMutableArray *)aHistory
{
    self = [super init];
    if (self) {
        mHeadControll = [[HeadControlView alloc]initWithSuperViewCGRect:self.view.frame AndTitle:@"历史记录"];
        [mHeadControll setControllerWithID:self];
        [mHeadControll setLeftBtnPressCallBackWithSEL:@selector(backToPreController)];
        [mHeadControll setLeftBtnTitleWithString:@"新建"];
        [mHeadControll showLeftBtn];
        [self.view addSubview:mHeadControll];
        mHistory = [[NSMutableArray alloc]initWithArray:aHistory];
        mHistoryList =[[ListShowTableView alloc]initWithFrame:self.view.frame andDataArray:mHistory andTarget:self andAction:@selector(ListSelected:)];
        [self.view addSubview:mHistoryList];
    }
    return self;
}

-(void)ListSelected:(NSIndexPath*)aIndex
{
    mHistoryViewer = [[HistoryViewController alloc]initWithHistory:mHistory AndCurrentRow:[aIndex row]];
    [self.navigationController pushViewController:mHistoryViewer animated:YES];
}


-(void)backToPreController
{
    [self.navigationController popViewControllerAnimated:YES];
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
