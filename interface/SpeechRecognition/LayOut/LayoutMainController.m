//
//  LayoutMainController.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "LayoutMainController.h"
#import "Data.h"

@implementation LayoutMainController

#pragma mark- init
- (id)initWithLayoutView:(UIView *)parmView
{
    self = [super init];
    if(self)
    {
        mainView = parmView;
        return self;
    }
    return nil;
}

#pragma mark - layOut
- (BOOL)createStartButton :(UIButton*)buttonStart :(id)target :(SEL)action
{
     buttonStart.frame = CGRectMake(kButtonRecogniseX, kButtonRecogniseY,
                                   kButtonRecogniseWidth, kButtonRecogniseHeight);
    
    [mainView addSubview:buttonStart];
    return YES;
}
@end
