//
//  HistoryViewController.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-7.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UITableViewController
{
    id obj;
    SEL popViewAction;
}

- (BOOL)setPopViewAction :(id)parmObj :(SEL)parmAction;
@end
