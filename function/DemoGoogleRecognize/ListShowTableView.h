//
//  ListShowTableView.h
//  BaiduTranslate1
//
//  Created by Lovells on 13-7-22.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListShowTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

- (id)initWithFrame:(CGRect)frame andDataArray:(NSArray *)dataArray andTarget:(id)target andAction:(SEL)action;

@end
