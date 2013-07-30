//
//  EditController.h
//  Demo_VoiceRecognition
//
//  Created by ShockingLee on 7/17/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadControlView.h"
#import "BodyContentView.h"
#import "FootTextControlView.h"

@interface EditController : UIViewController
{
    HeadControlView *mHeadControllView;
    BodyContentView *mBodyContentView;
    FootTextControlView *mFootTextControlView;
    
    id mPreController;
    SEL mSelSaveText;
}

-(id)initWithContentText:(NSString *)aStrText andPreController:(id)aPreCon AndSavaSEL:(SEL)aSEL;

@end
