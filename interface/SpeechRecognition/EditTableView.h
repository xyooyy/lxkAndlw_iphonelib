//
//  EditTableView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-10.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataProcessing;

@interface EditTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

- (id)initWithFrame:(CGRect)frame andData:(DataProcessing *)data;
- (NSString *)getTextStringInEditView;
- (NSArray *)getTextArrayStringInEditView;
- (NSArray *)getTExtArrayArrayInData;

@end