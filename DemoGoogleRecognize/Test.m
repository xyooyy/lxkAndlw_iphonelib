//
//  Test.m
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/22/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "Test.h"

void *createWaveHeader(int dataLength)
{
    
    struct waveHeader *header = malloc(sizeof(struct waveHeader));
    
    if (header == NULL) {
        return  NULL;
    }
    
    // RIFF
    header->riff[0] = 'R';
    header->riff[1] = 'I';
    header->riff[2] = 'F';
    header->riff[3] = 'F';
    
    // file length
    header->fileLength = dataLength + (44 - 8);
    
    // fmt
    header->fmt[0] = 'f';
    header->fmt[1] = 'm';
    header->fmt[2] = 't';
    header->fmt[3] = ' ';
    
    header->size = 16;
    header->formatTag = 1;
    header->channel = 2;  // 2
    header->sampleRate = 16000; // 16000
    header->bitPerSample = 16; // 16
    header->blockAlign = (short)(header->channel * header->bitPerSample / 8);
    header->bytePerSec = header->blockAlign * header->sampleRate;
    
    // data
    header->data[0] = 'd';
    header->data[1] = 'a';
    header->data[2] = 't';
    header->data[3] = 'a';
    
    // data size
    header->dataSize = dataLength;
    
    return header;
}