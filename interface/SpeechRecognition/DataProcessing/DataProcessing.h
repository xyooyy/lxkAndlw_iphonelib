//
//  DataProcessing.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandBoxOperation.h"

@interface DataProcessing : NSObject
{
    NSMutableDictionary *recognizedStrAndDurationDic;
    NSMutableDictionary *recognizedRecord;
    NSUInteger count;
}

- (BOOL)setDictionary:(NSMutableDictionary *)dictionary;
- (BOOL)clearDicData;
- (BOOL)saveDicToFile :(NSString*)fileName;
- (BOOL)isKeyHasExist:(NSString*)key;

- (void)recognizedStrAndDuration :(NSString*)str :(NSUInteger)duration;

- (int)getDicCount;

//- (NSEnumerator*)getKeyEnumerator;
- (NSMutableArray*)getAllValues;

- (NSNumber*)getValue :(NSString*)key;

- (NSArray*)getValueSet;

- (NSDictionary*)getDic;
- (NSString*)getKeyFirstApperWithValue :(NSString*)value;
- (NSString *)getStringFromArray;

//有时间戳
- (NSArray*)getKeySet;
- (void)recognizedStrTimestamp:(NSString *)str :(int)duration;
- (NSArray*)timestampSequence:(NSArray*)timestampArray;

@end
