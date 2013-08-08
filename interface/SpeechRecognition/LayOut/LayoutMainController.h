//
//  LayoutMainController.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutMainController : NSObject
{
    UIView *mainView;
}
- (id)initWithLayoutView :(UIView*)view;

- (BOOL)createStartButton :(UIButton*)buttonStart :(id)target :(SEL)action;
@end
