//
//  SoundWaveView.h
//  SpeechRecognition
//
//  Created by Lovells on 13-8-1.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundWaveView : UIView
{
    NSMutableArray *array;
    BOOL isDrawing;
    NSUInteger _strong;
    int kSoundWaveHeight;
}
- (BOOL)addSoundStrong:(NSUInteger)strong;
@property(atomic)BOOL isDawing;
@property(atomic)BOOL isThreedOneFinish;
@property(atomic)BOOL ISThreedTwoFinish;
@property(atomic)BOOL isContextInUse;

@end
