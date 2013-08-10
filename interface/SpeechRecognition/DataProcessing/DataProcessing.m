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
        recognizedStrArray = [[NSMutableArray alloc]init];
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
- (void)recognizedStrAndDuration:(NSString *)str :(double)duration
{
    [recognizedStrAndDurationDic setValue:[NSNumber numberWithDouble:duration] forKey:str];
}
- (void)recordRecognizedStr:(NSString *)str
{
    [recognizedStrArray addObject:str];
}
- (BOOL)setDictionary:(NSMutableDictionary *)dictionary
{
    recognizedStrAndDurationDic = dictionary;
    return YES;
}
- (NSMutableArray*)getRecognizedData
{
    return recognizedStrArray;
}
- (NSDictionary*)getDic
{
    return recognizedStrAndDurationDic;
}

@end
