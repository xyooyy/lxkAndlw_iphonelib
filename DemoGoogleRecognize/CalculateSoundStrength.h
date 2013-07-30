//
//  CalculateSoundStrength.h
//  RecordColumnarDisplayComponent
//
//  Created by 于 硕 on 13-7-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateSoundStrength : NSObject

- (int)voiceStrengthConvertHeight : (int) voiceStrength :(int)baseNumber;
-(int)calculateVoiceStrength :(short*)data :(int)dataSize :(int)channelCount;
@end
