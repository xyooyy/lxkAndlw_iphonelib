//
//  SandBoxOperation.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-8.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandBoxOperation : NSObject

- (NSString*)getDocumentPath;
- (int)getDocumentPathFileCount;
- (NSArray*)getDocumentPathFileSet;
- (BOOL)isContainSpecifiedSuffixFile :(NSString*)suffix;

@end
