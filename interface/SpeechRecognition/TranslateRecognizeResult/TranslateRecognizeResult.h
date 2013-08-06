//
//  TranslateRecognizeResult.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslateRecognizeResult : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *mTranslateResult;
    
    NSString *translateStr;
    id obj;
    SEL translateFinish;
    
}
- (id)initWithData :(id)parmObj :(SEL)parmTranslateFinish;
- (BOOL)translate :(NSString*)str;
@end
