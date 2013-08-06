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
        return self;
    }
    return nil;
}
- (void)recordRecognizedStr:(NSString *)str
{
    [recognizedStrArray addObject:str];
}
- (NSMutableArray*)getRecognizedData
{
    return recognizedStrArray;
}
@end
