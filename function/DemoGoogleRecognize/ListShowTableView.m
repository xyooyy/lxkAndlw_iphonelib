//
//  ListShowTableView.m
//  BaiduTranslate1
//
//  Created by Lovells on 13-7-22.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "ListShowTableView.h"

#define kTableCellIdentifier @"history"

@interface ListShowTableView ()
{
    NSArray *_dataArray;
    id _target;
    SEL _action;
}

@end

@implementation ListShowTableView

- (id)initWithFrame:(CGRect)frame andDataArray:(NSArray *)dataArray andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:CGRectMake(0.0f, 30.0f, frame.size.width, frame.size.height-30.f)];
    if (self)
    {
        [self setDelegate:self];
        [self setDataSource:self];
        _dataArray = [[NSArray alloc]initWithArray:dataArray];
        _target = target;
        _action = action;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[_target performSelector:_action withObject:[indexPath row]];
    [_target performSelector:_action withObject:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableCellIdentifier];
    }
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"file"];
    return cell;
}


@end
