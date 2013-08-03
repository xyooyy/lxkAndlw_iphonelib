//
//  WavHeaderFactory.cpp
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/22/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#include "WavHeaderFactory.h"

WavHeaderFactory::WavHeaderFactory()
{
    mHeader = new WAVE_HEAD;
    //RIFF
    *(mHeader->riffHeader.szRiffID) = 'R';
    *(mHeader->riffHeader.szRiffID+1) = 'I';
    *(mHeader->riffHeader.szRiffID+2) = 'F';
    *(mHeader->riffHeader.szRiffID+3) = 'F';
    
    //FILE SIZE
    mHeader->riffHeader.dwRiffSize = 0;
    
    //RIFF FORMAT
    *(mHeader->riffHeader.szRiffFormat) = 'W';
    *(mHeader->riffHeader.szRiffFormat+1) = 'A';
    *(mHeader->riffHeader.szRiffFormat+2) = 'V';
    *(mHeader->riffHeader.szRiffFormat+3) = 'E';
    //fmt
    *(mHeader->fmtBlock.szFmtID) = 'f';
    *(mHeader->fmtBlock.szFmtID+1) = 'm';
    *(mHeader->fmtBlock.szFmtID+2) = 't';
    *(mHeader->fmtBlock.szFmtID+3) = ' ';
    mHeader->fmtBlock.dwFmtSize = 16;
    //fmt format
    mHeader->fmtBlock.wavFormat.wFormatTag = 1;
    mHeader->fmtBlock.wavFormat.wChannels = 1;
    mHeader->fmtBlock.wavFormat.dwSamplesPerSec = 16000;
    mHeader->fmtBlock.wavFormat.dwAvgBytesPerSec = 16000*2;
    mHeader->fmtBlock.wavFormat.wBlockAlign = sizeof(short);
    mHeader->fmtBlock.wavFormat.wBitsPerSample = 16;
   //data
    *(mHeader->data.szDataID) = 'd';
    *(mHeader->data.szDataID+1) = 'a';
    *(mHeader->data.szDataID+2) = 't';
    *(mHeader->data.szDataID+3) = 'a';
    mHeader->data.dwDataSize = 0;
    
}

WAVE_HEAD *WavHeaderFactory::getHeader()
{
    return mHeader;
}

void WavHeaderFactory::setFileSize(DWORD aSize)
{
    mHeader->riffHeader.dwRiffSize = aSize-8;
}

void WavHeaderFactory::setDataSize(DWORD aSize)
{
    mHeader->data.dwDataSize = aSize;
}
WavHeaderFactory::~WavHeaderFactory()
{
    delete mHeader;
}