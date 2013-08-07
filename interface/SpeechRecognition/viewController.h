//
//  RootViewController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-26.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchButtonTouchAction.h"
#import "TranslateRecognizeResult.h"
#import "DataProcessing.h"

@interface viewController : UIViewController
{
    SwitchButtonTouchAction *switchButtonTouchAction;
    TranslateRecognizeResult *translate;
    DataProcessing *dataProcessing;
    
    NSString *filePath;
    
}
@end
