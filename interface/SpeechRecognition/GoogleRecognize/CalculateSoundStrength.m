//
//  CalculateSoundStrength.m
//  RecordColumnarDisplayComponent
//
//  Created by 于 硕 on 13-7-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CalculateSoundStrength.h"

#define MASK_SIZE 6
int weightArray[MASK_SIZE] = {16,32,32,32,4096,8192};
int maskArray[MASK_SIZE] = {1,2,2,2,8,8};

@implementation CalculateSoundStrength

-(int)calculateVoiceStrength :(short*)data :(int)dataSize :(int)channelCount;
{
    int temp;
    int *average = malloc((dataSize / channelCount)*sizeof(int));
    for (int i = 0;  i != dataSize / channelCount; i++)
    {
        temp = 0;
        for (int j = 0 ; j != channelCount; j++)
        {
            temp += data[i*channelCount + j];
        }
        average[i] = abs(temp / channelCount);
    }
    
    int finalValue = 0;
    for (int i = 1; i != dataSize / channelCount; i++)
    {
        finalValue += abs(average[i]-average[i-1]);
    }
    
    finalValue = finalValue / (dataSize / channelCount);
    free(average);
    return finalValue;
    
}
-(BOOL)cumulative :(int*)voiceStrength :(int*)compressHeight :(int)baseNumber :(int)mask :(int)weight
{
    if(*voiceStrength / weight - baseNumber /mask  > 0)
    {
        *compressHeight += baseNumber / mask;
        *voiceStrength = (*voiceStrength / weight - baseNumber / mask)*weight;
    }
    else
    {
        *compressHeight += *voiceStrength / weight;
    }
    return YES;
}
- (int)voiceStrengthConvertHeight : (int) voiceStrength :(int)baseNumber
{
    int compressHeight = 0;
    for (int i = 0; i != MASK_SIZE; i++)
    {
        int weight = weightArray[i];
        int mask = maskArray[i];
        [self cumulative:&voiceStrength :&compressHeight :baseNumber:mask :weight];
    }
    return compressHeight + 1;
}
@end
