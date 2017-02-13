//
//  DVSliderView.h
//  hairdresser
//
//  Created by fallen.ink on 6/30/16.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MoveDirectionRight,
    MoveDirectionLeft,
} MoveDirection;

@protocol DVSliderViewDelegate;

@interface DVSliderView : UIView

@property (nonatomic, weak) id<DVSliderViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIColor *sliderColor;

@property (nonatomic, assign, readonly) MoveDirection moveDirection;

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)color;

/**
 *  更新 滑块 位置
 *
 *  @param point    滑块的目标位置
 *  @param moveLeft YES 为向左，否则向右
 */
- (void)updatePosition:(CGPoint)point animate:(BOOL)animate interval:(NSTimeInterval)interval;

/**
 *  非动画更新
 */
- (void)updatePosition:(CGPoint)point;

@end

#pragma mark - 

@protocol DVSliderViewDelegate <NSObject>

/**
 *  滑块即将开始动画
 *
 *  @param sliderView 滑块
 *  @param point      目标点
 *  @param direction  滑动方向
 */
- (void)sliderView:(DVSliderView *)sliderView
willStartAnimateWithPosition:(CGPoint)point
          interval:(NSTimeInterval)interval
   scrollDirection:(MoveDirection)direction;

- (void)sliderViewWillEndAnimate;

- (void)sliderViewDidStartAnimate;

- (void)sliderViewDidEndAnimate;

// 用方法封装 frame 更新

- (void)sliderViewDidChangeFrameWithoutAimate:(CGRect)newFrame;

@end

