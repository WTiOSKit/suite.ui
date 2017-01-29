//
//  UIViewSliderAnimateLayer.h
//  hairdresser
//
//  Created by fallen.ink on 7/1/16.
//
//

#import <QuartzCore/QuartzCore.h>

#import "DVSliderView.h"

@interface DVSliderAnimateLayer : CALayer <DVSliderViewDelegate>

@property (nonatomic, weak) DVSliderView *sliderView;

//- (void)animate;

@end
