//
//  HistoryViewController.h
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/26/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListShowTableView.h"
#import "HeadControlView.h"
#import "HistoryViewController.h"

@interface HistorySelectController : UIViewController
{
    ListShowTableView *mHistoryList;
    NSMutableArray *mHistory;
    HeadControlView *mHeadControll;
    int mIndexEditing;
    
    HistoryViewController *mHistoryViewer;
}
-(id)initWithHistory:(NSMutableArray *)aHistory;
@end
