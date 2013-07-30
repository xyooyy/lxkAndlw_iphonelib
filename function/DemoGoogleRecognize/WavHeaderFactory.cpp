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
    /*
     typedef struct RIFF_HEADER
     {
     char szRiffID[4];  // 'R','I','F','F'
     DWORD dwRiffSize;
     char szRiffFormat[4]; // 'W','A','V','E'
     }RIFF_HEADER;
     */
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
    
    //http://blog.csdn.net/citysheep/article/details/1756238

    
    /*
     typedef struct FMT_BLOCK
     {
     char  szFmtID[4]; // 'f','m','t',' '
     DWORD  dwFmtSize;
     WAVE_FORMAT wavFormat;
     }FMT_BLOCK;
     */
    *(mHeader->fmtBlock.szFmtID) = 'f';
    *(mHeader->fmtBlock.szFmtID+1) = 'm';
    *(mHeader->fmtBlock.szFmtID+2) = 't';
    *(mHeader->fmtBlock.szFmtID+3) = ' ';
    mHeader->fmtBlock.dwFmtSize = 16;
    //    typedef struct WAVE_FORMAT
    //    {
    //        WORD wFormatTag;
    //        WORD wChannels;
    //        DWORD dwSamplesPerSec;
    //        DWORD dwAvgBytesPerSec;
    //        WORD wBlockAlign;
    //        WORD wBitsPerSample;
    //    } WAVE_FORMAT;
    
    mHeader->fmtBlock.wavFormat.wFormatTag = 1;
    mHeader->fmtBlock.wavFormat.wChannels = 2;
    mHeader->fmtBlock.wavFormat.dwSamplesPerSec = 16000;
    
    //2*16000*sizeof(short)
    mHeader->fmtBlock.wavFormat.dwAvgBytesPerSec = 16000*2*2*sizeof(short);
    // sizeof(short);
    mHeader->fmtBlock.wavFormat.wBlockAlign = 2*2*sizeof(short);
    // 8*sizeof(short)
    mHeader->fmtBlock.wavFormat.wBitsPerSample = 16;
    
    /*
     typedef struct DATA_BLOCK
     {
     char szDataID[4]; // 'd','a','t','a'
     DWORD dwDataSize;
     }DATA_BLOCK;
     */
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