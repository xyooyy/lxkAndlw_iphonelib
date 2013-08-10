//
//  EditViewController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController

- (BOOL)setSavePath:(NSString *)path;

- (BOOL)setTextArray:(NSArray *)textArray;
- (BOOL)setTextString:(NSString *)textString;

@end
