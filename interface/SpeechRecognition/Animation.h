//
//  SpeechRecogniseAnimation.h
//  SpeechRecognition
//
//  Created by Lovells on 13-7-29.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject

// 变换view的frame
- (BOOL)transformView:(UIView *)view
              toFrame:(CGRect)frame
         withDuration:(NSTimeInterval)duration
           completion:(void (^)(void))completion;

// 逐渐显示view
- (BOOL)fadeInWithView:(UIView *)view
              duration:(NSTimeInterval)duration
            completion:(void(^)(void))completion;

// 逐渐隐藏view
- (BOOL)fadeOutWithView:(UIView *)view
               duration:(NSTimeInterval)duration
             completion:(void(^)(void))completion;

- (BOOL)fadeWithView:(UIView *)view
               alpha:(CGFloat)alpha
            duration:(NSTimeInterval)duration
          completion:(void(^)(void))completion;

// 向指定layer添加动画
- (BOOL)animationWithLayer:(CALayer *)layer
                   keypath:(NSString *)keyPath
                 fromValue:(id)fromValue
                   toValue:(id)toValue
                  duration:(NSTimeInterval)time
               repeatCount:(float)repeatCount
             animationName:(NSString *)keyName;

// 删除指定动画
- (BOOL)animationRemoveFromLayer:(CALayer *)layer forKey:(NSString *)key;

@end
