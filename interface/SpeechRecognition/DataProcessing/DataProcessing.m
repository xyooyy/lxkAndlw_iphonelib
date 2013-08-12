//
//  DataProcessing.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "DataProcessing.h"



@implementation DataProcessing

- (id)init
{
    self = [super init];
    if(self)
    {
        recognizedStrAndDurationDic = [[NSMutableDictionary alloc]init];
        return self;
    }
    return nil;
}
#pragma mark - 接口方法

- (NSArray*)getValueSet
{
    NSMutableArray *valueSet = [[NSMutableArray alloc]init];
    for (NSString *key in recognizedStrAndDurationDic)
    {
        [valueSet addObject:[recognizedStrAndDurationDic objectForKey:key]];
    }
    return valueSet;
}
- (BOOL)saveDicToFile:(NSString *)filePath
{
   return  [recognizedStrAndDurationDic writeToFile:filePath atomically:YES];
}
- (NSNumber*)getValue:(NSString *)key
{
    return [recognizedStrAndDurationDic objectForKey:key];
}
- (NSMutableArray*)getAllValues
{
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    for (NSString *key in [recognizedStrAndDurationDic keyEnumerator])
    {
        [valueArray addObject:[recognizedStrAndDurationDic objectForKey:key]];
    }
    return valueArray;
}
- (NSEnumerator*)getKeyEnumerator
{
    return [recognizedStrAndDurationDic keyEnumerator];
}
- (BOOL)clearDicData
{
    [recognizedStrAndDurationDic removeAllObjects];
    return YES;
}

- (int)getDicCount
{
    return [recognizedStrAndDurationDic count];
}
- (void)recognizedStrAndDuration:(NSString *)str :(NSUInteger)duration
{
    [recognizedStrAndDurationDic setValue:str forKey:[NSString stringWithFormat:@"%u",duration]];
}
- (BOOL)setDictionary:(NSMutableDictionary *)dictionary
{
    recognizedStrAndDurationDic = dictionary;
    return YES;
}
- (NSDictionary*)getDic
{
    return recognizedStrAndDurationDic;
}
- (BOOL)isKeyHasExist:(NSString *)key
{
    if([recognizedStrAndDurationDic objectForKey:key])
        return YES;
    return NO;
}
- (NSString*)getKeyFirstApperWithValue:(NSString *)value
{
    for (NSString *key in [recognizedStrAndDurationDic keyEnumerator])
    {
        if([[recognizedStrAndDurationDic objectForKey:key] isEqual:value])
            return key;
    }
    return nil;
}
- (NSString *)getStringFromArray
{
    NSString *result = @"";
    
    for (NSString *key in [recognizedStrAndDurationDic keyEnumerator])
    {
        result = [result stringByAppendingFormat:@"%@\n", [recognizedStrAndDurationDic objectForKey:key]];
    }
    
    return result;
}

@end
