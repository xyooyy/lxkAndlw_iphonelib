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
    NSMutableArray *recognizedStrArray;
    NSMutableDictionary *recognizedStrAndDurationDic;
}

- (NSMutableArray*)getRecognizedData;
- (void)recordRecognizedStr :(NSString*)str;

- (void)recognizedStrAndDuration :(NSString*)str :(double)duration;
- (int)getDicCount;
- (BOOL)clearDicData;
- (NSEnumerator*)getKeyEnumerator;
- (NSNumber*)getValue :(NSString*)key;
- (NSArray*)getValueSet;
- (BOOL)saveDicToFile :(NSString*)fileName;
- (NSDictionary*)getDic;
@end
