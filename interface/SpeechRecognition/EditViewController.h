//
//  EditViewController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTableView.h"
#import "DataProcessing.h"
#import "TextViewScroll.h"

@interface EditViewController : UIViewController
{
    
    EditTableView *m_tableView;
    DataProcessing *m_data;
    TextViewScroll *m_textView;
    
    NSIndexPath *m_currentIndex;
    NSString *m_savePath;
    
    id obj;
    SEL action;
}

- (id)initWithData:(DataProcessing *)data;
- (BOOL)setSavePath :(NSString *)path;
- (BOOL)setTextViewScroll:(TextViewScroll *)textView;
- (BOOL)setEditCompleteCallBack :(id)parmObj :(SEL)parmAction;

@end
