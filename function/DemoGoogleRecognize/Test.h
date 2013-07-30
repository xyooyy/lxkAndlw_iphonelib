//
//  Test.h
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/22/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <Foundation/Foundation.h>

struct waveHeader {
    
    char riff[4];
    unsigned long fileLength;
    char wavTag[4];
    char fmt[4];
    unsigned long size;
    unsigned short formatTag;
    unsigned short channel;
    unsigned long sampleRate;
    unsigned long bytePerSec;
    unsigned short blockAlign;
    unsigned short bitPerSample;
    char data[4];
    unsigned long dataSize;
    
};

void *createWaveHeader(int dataLength);