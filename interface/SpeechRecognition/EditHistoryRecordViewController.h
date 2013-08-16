//
//  EditHistoryRecordViewController.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-16.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditHistoryRecordViewController : UIViewController
{
    UITextView *_textView;
    id obj;
    SEL saveAction;
}
- (BOOL)setTextString:(NSString *)string;
- (BOOL)saveButtonCallBack :(id)parmObj :(SEL)parmAction;
@end
