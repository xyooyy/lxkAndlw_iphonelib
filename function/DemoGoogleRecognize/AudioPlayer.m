//
//  AudioPlayer.m
//  DemoGoogleRecognize
//
//  Created by ShockingLee on 7/24/13.
//  Copyright (c) 2013 ShockingLee. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer
-(id)init
{
    self = [super init];
    return self;
}

-(void)setSoundName:(NSString *)aName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:aName];
    mPathURL = [[NSURL alloc]initFileURLWithPath:path];
    mPlayer =[[AVAudioPlayer alloc]initWithContentsOfURL:mPathURL error:nil];
    [mPlayer play];
}

-(void)startPlay
{
    mPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:mPathURL error:nil];
    [mPlayer setDelegate:self];
    [mPlayer play];
}

-(void)stopPlay
{
    [mPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}
@end
