//
//  EditViewController.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-9.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataProcessing;
@class TextViewScroll;

@interface EditViewController : UIViewController

- (id)initWithData:(DataProcessing *)data;
- (BOOL)setSavePath:(NSString *)path;
- (BOOL)setTextViewScroll:(TextViewScroll *)textView;

@end
