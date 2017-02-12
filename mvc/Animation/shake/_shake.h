//
//  _shake.h
//  consumer
//
//  Created by fallen.ink on 9/20/16.
//
//  inspired by https://github.com/ArtFeel/AFViewShaker/blob/master/AFViewShaker/AFViewShaker.m

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface _Shake : NSObject

+ (void)shakeOnView:(UIView *)view;

+ (void)shakeOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration completion:(void (^)())completion;

@end
