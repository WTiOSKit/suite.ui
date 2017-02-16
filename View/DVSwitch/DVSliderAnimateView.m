//
//  UIViewSliderAnimateView.m
//  hairdresser
//
//  Created by fallen.ink on 7/1/16.
//
//

#import "DVSliderAnimateView.h"
#import "DVSliderAnimateLayer.h"

@interface DVSliderAnimateView ()

@property (nonatomic, strong) DVSliderAnimateLayer *sliderAnimateLayer;

@end

@implementation DVSliderAnimateView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame sliderView:(DVSliderView *)sliderView {
    if (self = [super initWithFrame:frame]) {
        self.sliderAnimateLayer = [DVSliderAnimateLayer layer];
        self.sliderAnimateLayer.frame = self.frame;
        self.sliderAnimateLayer.sliderView = sliderView;
        self.sliderAnimateLayer.contentsScale = [UIScreen mainScreen].scale; // 不加这个，会出现锯齿
        [self.layer addSublayer:self.sliderAnimateLayer];
    }
    
    return self;
}

@end
