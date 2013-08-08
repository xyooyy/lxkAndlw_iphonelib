//
//  HistoryViewController.h
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/26/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadControlView.h"
#import "BodyContentView.h"
#import "FootTextControlView.h"
#import "EditController.h"
#import "AudioPlayer.h"
#import "TranslateController.h"

@interface HistoryViewController : UIViewController
{
    HeadControlView *mHead;
    BodyContentView *mBody;
    FootTextControlView *mFoot;
    
    NSMutableArray *mHistory;
    AudioPlayer *mPlayer;
    
    int curRow;
}

-(id)initWithHistory:(NSMutableArray *)aHistory AndCurrentRow:(int)aIndex;
@end
