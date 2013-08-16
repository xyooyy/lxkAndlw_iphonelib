//
//  CheckNetStatus.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-16.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "CheckNetStatus.h"

@implementation CheckNetStatus

- (int)isInWIFI
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    return [r currentReachabilityStatus];
}
@end
