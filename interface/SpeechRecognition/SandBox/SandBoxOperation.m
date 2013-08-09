//
//  SandBoxOperation.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-8.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "SandBoxOperation.h"

@implementation SandBoxOperation

- (NSString*)getDocumentPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return docPath;
}
- (int)getDocumentPathFileCount
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *docDir = [self getDocumentPath];
    return  [[manger subpathsAtPath:docDir] count];
}
- (NSArray*)getDocumentPathFileSet
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [manger subpathsAtPath:docDir];
}
- (BOOL)isContainSpecifiedSuffixFile:(NSString *)suffix
{
    NSArray *fileSet = [self getDocumentPathFileSet];
    for (NSString *fileName in fileSet)
    {
        if([fileName rangeOfString:@".data"].location != NSNotFound)
            return YES;
    }
    return NO;
}
@end
