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

@interface TranslateController : UIViewController
{
    HeadControlView *mHeadControllView;
    BodyContentView *mBodyContentView;
    FootTextControlView *mFootTextControlView;
}

-(id)initWithContentText:(NSString *)aStrText;
@end
