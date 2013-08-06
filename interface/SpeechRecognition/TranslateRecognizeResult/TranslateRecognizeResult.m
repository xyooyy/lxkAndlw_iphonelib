//
//  TranslateRecognizeResult.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TranslateRecognizeResult.h"
#import "SBJson.h"

#define transUrl @"http://openapi.baidu.com/public/2.0/bmt/translate?from=auto&to=auto&client_id=GXAx2QSwjEVViqgvPsrgdjSo&q="

@implementation TranslateRecognizeResult

- (id)initWithData:(id)parmObj :(SEL)parmtranslateFinish
{
    self = [super init];
    if(self)
    {
        mTranslateResult = [[NSMutableData alloc]init];
        obj = parmObj;
        translateFinish = parmtranslateFinish;
        return self;
    }
    return nil;
}
- (BOOL)translate:(NSString *)str
{
    translateStr = str;
    NSString *url = [[NSString alloc]initWithFormat:@"%@%@",transUrl,str];
    NSURL *mUrl = [[NSURL alloc]initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:mUrl];
    [NSURLConnection connectionWithRequest:request delegate:self];
    return YES;
}

#pragma mark- NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mTranslateResult appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: [parser objectWithData:mTranslateResult]];
    NSString *mStrResult = [[[dic objectForKey:@"trans_result"] objectAtIndex:0] objectForKey:@"dst"];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:mStrResult,translateStr, nil];
    NSLog(@"%@->%@",translateStr,mStrResult);
    if(obj && translateFinish)
    [obj performSelector:translateFinish withObject:mStrResult];
    [mTranslateResult setLength:0];
    //[mBodyContentView setTextRewirteAll:mStrResult];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response");
}

@end
