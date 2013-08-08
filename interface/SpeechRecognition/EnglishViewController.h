//
//  EnglishViewController.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslateRecognizeResult.h"

@interface EnglishViewController : UIViewController
{
    TranslateRecognizeResult *translateRecognizeResult;
    NSString *sourceStr;
    NSString *destStr;
    id obj;
    SEL action;
}
- (id)initWithData :(NSString*)sourceStr :(NSString*)destStr :(id)parmObj :(SEL)parmAction;
@end
