//
//  UIViewAnimation.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-5.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewAnimation : NSObject

- (BOOL)changeViewFrame:(UIView *)view
            toFrame:(CGRect)frame
       withDuration:(NSTimeInterval)duration
         completion:(void (^)(void))completion;

- (BOOL)animationWithLayer:(CALayer *)layer
                   keypath:(NSString *)keyPath
                 fromValue:(id)fromValue
                   toValue:(id)toValue
                  duration:(NSTimeInterval)time
               repeatCount:(float)repeatCount
             animationName:(NSString *)keyName;

- (BOOL)changeViewLightness:(UIView *)view
                      alpha:(CGFloat)alpha
                   duration:(NSTimeInterval)duration
                 completion:(void(^)(void))completion;

- (BOOL)removeAnimationFromLayer:(CALayer *)layer forKey:(NSString *)key;
@end
