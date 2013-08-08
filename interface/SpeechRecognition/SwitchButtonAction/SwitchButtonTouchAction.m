//
//  SWitchButtonTouchAction.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "SwitchButtonTouchAction.h"

@implementation SwitchButtonTouchAction

- (BOOL)switchButtonTouchAction:(UIButton *)parmButton oldAction:(SEL)oldAction withTarget:(id)oldTarget newAction:(SEL)newAction withTarget:(id)newTarget
{
    [parmButton removeTarget:oldTarget action:oldAction forControlEvents:UIControlEventTouchDown];
    [parmButton addTarget:newTarget action:newAction forControlEvents:UIControlEventTouchDown];
    return YES;
}
@end
