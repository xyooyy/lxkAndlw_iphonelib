//
//  EditTranslateController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-12.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTranslateController : UIViewController
{
    UITextView *m_textView;
    NSString *m_savePath;
    id obj;
    SEL editSaveAction;
}
- (BOOL)setTextString:(NSString *)string;
- (BOOL)setSavePath:(NSString *)path;
- (BOOL)setEditSaveCallBack :(id)parmObj :(SEL)parmAction;

@end
