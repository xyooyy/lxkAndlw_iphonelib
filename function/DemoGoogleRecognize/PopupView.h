//
//  PopupView.h
//  MSCDemo
//
//  Created by iflytek on 13-6-7.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
{
    UILabel         *_textLabel;
    int             _queueCount;
}
@property (retain) UIView*  ParentView;
-(void)showWithText:(NSString *)aText AndSuperView:(UIView *)aSuperView;

@end
