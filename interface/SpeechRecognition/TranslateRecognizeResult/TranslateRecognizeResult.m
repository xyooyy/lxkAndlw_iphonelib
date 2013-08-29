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
    NSArray *resultDictionaryArray = [dic objectForKey:@"trans_result"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < resultDictionaryArray.count; i++)
    {
        [resultArray addObject:[[resultDictionaryArray objectAtIndex:i] objectForKey:@"dst"]];
    }
    
    if(obj && translateFinish)
        [obj performSelector:translateFinish withObject:translateStr withObject:resultArray];
    [mTranslateResult setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"Response");
}

@end
