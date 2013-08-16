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
    // 存每一行对应的音长
    NSMutableArray *_soundDataArray;
    NSMutableArray *_cellArray;
}

@end

@implementation EditTableView

- (id)initWithFrame:(CGRect)frame andData:(DataProcessing *)data
{
    self = [super init];
    if (self)
    {
        _data = data;
        
        self.delegate = self;
        self.dataSource = self;
        self.frame = frame;
        self.backgroundColor = RGBA(27.f, 26.f, 24.f, 1.f);
        self.separatorColor = [UIColor colorWithWhite:0.167 alpha:1.000];
        self.layer.cornerRadius = kTableViewBorderRadius;
        
        _soundDataArray = [[NSMutableArray alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        _cellArray =  [[NSMutableArray alloc]init];
        
        
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
    
    for (UITableViewCell *cell in _cellArray)
    {
       result = [result stringByAppendingString:cell.textLabel.text];
    }
    return result;
}

- (NSArray *)getTextArrayStringInEditView
{
    return _dataArray;
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
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width, kTableViewCellHeight)];
//    textField.text = [_dataArray objectAtIndex:indexPath.row];
//    textField.textColor = [UIColor whiteColor];
//    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    [cell.contentView addSubview:textField];
//    [_textFieldArray addObject:textField];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [_cellArray addObject:cell];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    NSString *str = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [obj performSelector:selectAction withObject:indexPath withObject:str];
}
- (BOOL)setSelectCallBack:(id)parmObj :(SEL)parmAction
{
    obj = parmObj;
    selectAction = parmAction;
    return YES;
}
- (BOOL)upDateSourceData:(NSString *)source :(NSIndexPath *)indexPath
{
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_dataArray insertObject:source atIndex:indexPath.row];
    return YES;
}
@end
