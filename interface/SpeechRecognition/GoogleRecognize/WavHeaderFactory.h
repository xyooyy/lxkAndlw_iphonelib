//
//  WavHeaderFactory.h
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/22/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

typedef unsigned int DWORD;
typedef unsigned short WORD;

typedef struct RIFF_HEADER
{
    char szRiffID[4];  // 'R','I','F','F'
    DWORD dwRiffSize;
    char szRiffFormat[4]; // 'W','A','V','E'
}RIFF_HEADER;

typedef struct WAVE_FORMAT
{
    WORD wFormatTag;
    WORD wChannels;
    DWORD dwSamplesPerSec;
    DWORD dwAvgBytesPerSec;
    WORD wBlockAlign;
    WORD wBitsPerSample;
} WAVE_FORMAT;

typedef struct DATA_BLOCK
{
    char szDataID[4]; // 'd','a','t','a'
    DWORD dwDataSize;
}DATA_BLOCK;

typedef struct FMT_BLOCK
{
    char  szFmtID[4]; // 'f','m','t',' '
    DWORD  dwFmtSize; // word
    WAVE_FORMAT wavFormat;
}FMT_BLOCK;


typedef struct
{
    RIFF_HEADER riffHeader;
    FMT_BLOCK fmtBlock;
    DATA_BLOCK data;
}WAVE_HEAD;

class WavHeaderFactory
{
    WAVE_HEAD *mHeader;
public:
    WavHeaderFactory();
    WAVE_HEAD *getHeader();
    void setFileSize(DWORD aSize);
    void setDataSize(DWORD aSize);
    ~WavHeaderFactory();
};
