//
//  Translator.h
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/27/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define transUrl @"http://openapi.baidu.com/public/2.0/bmt/translate?from=auto&to=auto&client_id=GXAx2QSwjEVViqgvPsrgdjSo&q="

@interface Translator : NSObject
{
    NSString *mTransString;
    NSString *mResult;
    NSURL *mUrl;
    
    id mDelegate;
}
-(id)initWithQuestion:(NSString *)aStrQ andDelegate:(id)aDelegate;
-(void)TranslateString;
@end
