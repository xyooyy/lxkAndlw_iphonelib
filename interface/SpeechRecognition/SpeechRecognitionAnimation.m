//
//  SpeechRecogniseAnimation.m
//  SpeechRecognition
//
//  Created by Lovells on 13-7-29.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "SpeechRecognitionAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpeechRecognitionAnimation

- (BOOL)transformView:(UIView *)view
              toFrame:(CGRect)frame
         withDuration:(NSTimeInterval)duration
           completion:(void(^)(void))completion;
{
    [UIView animateWithDuration:duration animations:^{
        view.frame = frame;
    } completion:^(BOOL finished){
        completion();
    }];
    
    return YES;
}

- (BOOL)fadeInWithView:(UIView *)view
              duration:(NSTimeInterval)duration
            completion:(void(^)(void))completion;
{
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.f;
    } completion:^(BOOL finished){
        completion();
    }];
    
    return YES;
}

- (BOOL)fadeOutWithView:(UIView *)view
               duration:(NSTimeInterval)duration
             completion:(void(^)(void))completion;
{
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 0.f;
    } completion:^(BOOL finished){
        completion();
    }];
    return YES;
}

- (BOOL)fadeWithView:(UIView *)view
               alpha:(CGFloat)alpha
            duration:(NSTimeInterval)duration
          completion:(void(^)(void))completion
{
    [UIView animateWithDuration:duration animations:^{
        view.alpha = alpha;
    } completion:^(BOOL finished){
        completion();
    }];
    return YES;
}

- (BOOL)animationWithLayer:(CALayer *)layer
                   keypath:(NSString *)keyPath
                 fromValue:(id)fromValue
                   toValue:(id)toValue
                  duration:(NSTimeInterval)time
               repeatCount:(float)repeatCount
             animationName:(NSString *)keyName;
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = time;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:keyName];
        
    return YES;
}

- (BOOL)animationRemoveFromLayer:(CALayer *)layer forKey:(NSString *)key
{
    [layer removeAnimationForKey:key];
    return YES;
}


@end
