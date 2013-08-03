//
//  Translator.m
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/27/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "Translator.h"

@implementation Translator
-(id)initWithQuestion:(NSString *)aStrQ andDelegate:(id)aDelegate
{
    self = [super init];
    if (self) {
        mTransString = [[NSString alloc]initWithString:aStrQ];
        NSString *url = [[NSString alloc]initWithFormat:@"%@%@",transUrl,mTransString];
        mUrl = [[NSURL alloc]initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        mDelegate = aDelegate;
    }
    return self;
}

-(void)TranslateString
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:mUrl];
    [NSURLConnection connectionWithRequest:request delegate:mDelegate];
}

@end
