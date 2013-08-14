//
//  EditTableView.m
//  SpeechRecognition
//
//  Created by Lovells on 13-8-10.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EditTableView.h"
#import "DataProcessing.h"
#import "Data.h"

#define kTableViewCellHeight 30.f
#define kTableViewBorderRadius 10.f

@interface EditTableView ()
{
    DataProcessing *_data;
    // 临时存储每一行要显示的内容
    NSMutableArray *_dataArray;
    // 存一系列的textField
    NSMutableArray *_textFieldArray;
    // 存每一行对应的音长
    NSMutableArray *_soundDataArray;
}

@end

@implementation EditTableView

- (id)initWithFrame:(CGRect)frame andData:(DataProcessing *)data
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _data = data;
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = RGBA(27.f, 26.f, 24.f, 1.f);
        self.separatorColor = [UIColor colorWithWhite:0.167 alpha:1.000];
        self.layer.cornerRadius = kTableViewBorderRadius;
        
        _textFieldArray = [[NSMutableArray alloc] init];
        _soundDataArray = [[NSMutableArray alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        
        
        NSArray *keySet = [_data getKeySet];
        
        for (NSString *key in keySet)
        {
            [_dataArray addObject:[[_data getDic] objectForKey:key]];
            [_soundDataArray addObject:key];
        }
    }
    return self;
}

- (NSString *)getTextStringInEditView
{
    NSString *result = @"";
    
    for (UITextField *textField in _textFieldArray)
    {
        result = [result stringByAppendingFormat:@"\n%@", textField.text];
    }
    
    return result;
}

- (NSArray *)getTextArrayStringInEditView
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:_textFieldArray.count];
    
    for (UITextField *textField in _textFieldArray)
    {
        [result addObject:textField.text];
    }
    
    return result;
}

- (NSArray *)getSoundDataArray
{
    return _soundDataArray;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data getDicCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"editCell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width, kTableViewCellHeight)];
    textField.text = [_dataArray objectAtIndex:indexPath.row];
    textField.textColor = [UIColor whiteColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [cell.contentView addSubview:textField];
    [_textFieldArray addObject:textField];
    
    return cell;
}

@end
