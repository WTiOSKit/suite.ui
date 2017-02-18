//
//  UIViewSliderAnimateView.h
//  hairdresser
//
//  Created by fallen.ink on 7/1/16.
//
//

#import <UIKit/UIKit.h>

/**
 *  动画过程
 
 *  1. 在DVSliderView那一层，加上动画层
 *  2. 操作DVSliderAnimateLayer层，进行动画
 *  3. 动画的输入源：DVSliderView的动画＋CADisplayLink
 *  4. 动画的数学计算模型，参考了：http://www.cocoachina.com/ios/20150618/12171.html
 *  5.
 */

@class DVSliderView;

@interface DVSliderAnimateView : UIView

/**
 *  初始化
 *
 *  @param frame      设置 与 DVSwitch相同
 *  @param sliderView 滑块View，必须要设置了frame的sliderView
 *
 *  @return 
 */
- (instancetype)initWithFrame:(CGRect)frame sliderView:(DVSliderView *)sliderView;

@end
