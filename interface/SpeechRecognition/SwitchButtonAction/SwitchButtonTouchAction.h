//
//  SWitchButtonTouchAction.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchButtonTouchAction : NSObject

- (BOOL)switchButtonTouchAction:(UIBarButtonItem *)parmButton
           oldAction:(SEL)oldAction
          withTarget:(id)oldTarget
           newAction:(SEL)newAction
          withTarget:(id)newTarget;
@end
