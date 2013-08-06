//
//  DataProcessing.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProcessing : NSObject
{
    NSMutableArray *recognizedStrArray;
}

- (NSMutableArray*)getRecognizedData;
- (void)recordRecognizedStr :(NSString*)str;
@end
