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
    id obj;
    SEL saveAction;
}

- (BOOL)setTextString:(NSString *)string;
- (BOOL)setSavePath:(NSString *)path;
- (BOOL)saveButtonCallBack :(id)parmObj :(SEL)parmAction;

@end
