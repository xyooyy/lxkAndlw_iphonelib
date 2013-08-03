//
//  AudioPlayer.h
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/24/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *mPlayer;
    NSURL *mPathURL;
    
    BOOL isPlay;
}

-(id)init;
-(void)setStartCallBack:(SEL)aStartCall;
-(void)setStopCallBack:(SEL)aStopCall;
-(void)setSoundName:(NSString *)aName;
-(void)startPlay;
-(void)stopPlay;
@end
