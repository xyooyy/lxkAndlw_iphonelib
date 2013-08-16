//
//  EditViewController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslateViewController : UIViewController

- (id)initWithString:(NSString *)string :(NSString*)savePath;
- (BOOL)setSavePath:(NSString *)path;

@end
