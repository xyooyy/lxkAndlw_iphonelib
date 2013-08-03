//
//  TranslateController.h
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/18/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadControlView.h"
#import "BodyContentView.h"
#import "FootTextControlView.h"
#import "EditController.h"
#import "Translator.h"
#import "PopupView.h"

@interface TranslateController : UIViewController <NSURLConnectionDataDelegate>
{
    HeadControlView *mHeadControllView;
    BodyContentView *mBodyContentView;
    FootTextControlView *mFootTextControlView;
    PopupView *mPopupView;
    
    Translator *mTrans;
    NSMutableData *mResult;
    NSMutableString *mStrResult;
}

-(id)initWithContentText:(NSString *)aStrText;
@end
