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
        recognizedRecord = [[NSMutableDictionary alloc]init];
        count = 0;
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
   count = 0;
   return  [recognizedRecord writeToFile:filePath atomically:YES];
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
    return [recognizedRecord count];
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
    return recognizedRecord;
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

#pragma mark - 有时间戳纪录

- (BOOL)isKeyIn :(NSArray*)keyArray :(NSString*)key
{
    for (NSString *k in keyArray)
    {
        if([k isEqualToString:key]) return YES;
    }
    return NO;
}
- (NSArray*)timestampSequence:(NSArray*)timestampEnumerator
{
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];
    int keyCount = [timestampEnumerator count];
    
    int *keySet = malloc(keyCount*sizeof(int));
    for (int i = 0; i != keyCount; i++)
    {
        keySet[i] = [[timestampEnumerator objectAtIndex:i] integerValue];
    }
    for (int i = 0; i != keyCount; i++)
    {
        for (int j = i+1; j != keyCount;j++)
        {
            if(keySet[i] > keySet[j])
            {
                int temp = keySet[i];
                keySet[i] = keySet[j];
                keySet[j] = temp;
            }
        }
    }
    for (int i = 0; i !=keyCount; i++)
    {
        [keyArray addObject:[NSString stringWithFormat:@"%d",keySet[i]]];
    }
    free(keySet);
    return keyArray;
}
- (void)recognizedStrTimestamp:(NSString *)str :(int)duration
{
    [recognizedRecord setValue:str forKey:[NSString stringWithFormat:@"%d",duration]];
}
- (NSArray*)getKeySet
{
    NSEnumerator *enumeator = [recognizedRecord keyEnumerator];
    NSMutableArray *keyArray = [[NSMutableArray alloc]initWithCapacity:10];
    for (NSString *key in enumeator)
    {
        [keyArray addObject:key];
    }
    return [self timestampSequence:keyArray];
}

@end
