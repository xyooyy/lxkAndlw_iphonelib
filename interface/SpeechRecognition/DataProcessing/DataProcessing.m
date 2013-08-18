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
    for (NSString *key in recognizedRecord)
    {
        [valueSet addObject:[recognizedRecord objectForKey:key]];
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
    return [recognizedRecord objectForKey:key];
}
- (NSMutableArray*)getAllValues
{
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    for (NSString *key in [recognizedRecord keyEnumerator])
    {
        [valueArray addObject:[recognizedRecord objectForKey:key]];
    }
    return valueArray;
}
- (NSEnumerator*)getKeyEnumerator
{
    return [recognizedRecord keyEnumerator];
}
- (BOOL)clearDicData
{
    [recognizedRecord removeAllObjects];
    return YES;
}

- (int)getDicCount
{
    return [recognizedRecord count];
}
- (void)recognizedStrAndDuration:(NSString *)str :(NSUInteger)duration
{
    [recognizedRecord setValue:str forKey:[NSString stringWithFormat:@"%u",duration]];
}

- (BOOL)setDictionary:(NSMutableDictionary *)dictionary
{
    recognizedRecord = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    return YES;
}
- (NSDictionary*)getDic
{
    return recognizedRecord;
}
- (BOOL)isKeyHasExist:(NSString *)key
{
    if([recognizedRecord objectForKey:key])
        return YES;
    return NO;
}
- (NSString*)getKeyFirstApperWithValue:(NSString *)value
{
    for (NSString *key in [recognizedRecord keyEnumerator])
    {
        if([[recognizedRecord objectForKey:key] isEqual:value])
            return key;
    }
    return nil;
}
- (NSString *)getStringFromArray
{
    NSString *result = @"";
    for (NSString *key in [self getKeySet])
    {
        NSString *str = [recognizedRecord objectForKey:key];
        if(![str isEqualToString:@"--"])
        result = [result stringByAppendingFormat:@"%@\n", str];
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
- (BOOL)convertNSArrayToCArray :(NSArray*)objArray :(int*)cArray
{
    for (int i = 0; i != objArray.count; i++)
    {
        cArray[i] = [[objArray objectAtIndex:i] integerValue];
    }
    return YES;
}
- (BOOL)squenceCArray :(int*)cArray :(int)size
{
    for (int i = 0; i != size; i++)
    {
        for (int j = i+1; j != size;j++)
        {
            if(cArray[i] > cArray[j])
            {
                int temp = cArray[i];
                cArray[i] = cArray[j];
                cArray[j] = temp;
            }
        }
    }
    return YES;
}
- (NSMutableArray*)getSquenceValue :(int*)keySet :(int)keyCount
{
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];
    for (int i = 0; i != keyCount; i++)
    {
        [keyArray addObject:[NSString stringWithFormat:@"%d",keySet[i]]];
    }
    return keyArray;
}
- (NSArray*)timestampSequence:(NSArray*)timestampEnumerator
{
    int keyCount = [timestampEnumerator count];
    int *keySet = malloc(keyCount*sizeof(int));
    [self convertNSArrayToCArray:timestampEnumerator :keySet];
    [self squenceCArray:keySet :keyCount];
    NSMutableArray *keyArray = [self getSquenceValue:keySet :keyCount];
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
