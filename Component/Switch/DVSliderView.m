//
//  DVSliderView.m
//  hairdresser
//
//  Created by fallen.ink on 6/30/16.
//
//

#import "DVSliderView.h"
#import "pop.h"
#import "_ui_core.h"

@interface DVSliderView ()

@end

@implementation DVSliderView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [NSException raise:@"DVSwitchInitException" format:@"Init call is prohibited, use initWithStringsArray: method"];
    }
    
    return self;
}

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        _sliderColor = color;

        [self initDefault];
    }
    
    return self;
}

- (void)initDefault {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.height/2;
}

#pragma mark - Public

- (void)updatePosition:(CGPoint)point animate:(BOOL)animate interval:(NSTimeInterval)interval {
    BOOL moveLeft = self.x > point.x;
    
    _moveDirection = moveLeft ? MoveDirectionLeft : MoveDirectionRight;

    [self.delegate sliderView:self willStartAnimateWithPosition:point interval:interval scrollDirection:self.moveDirection];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x+self.width/2, point.y+self.height/2)];
//    animation.duration = interval;
    animation.springBounciness = 90.0;
    animation.springSpeed = fabs(self.x-point.x)/interval/50;

    animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        // 动画结束
        [self.delegate sliderViewWillEndAnimate];
        
        // do something
        
        [self.delegate sliderViewDidEndAnimate];
    };
    [self pop_addAnimation:animation forKey:@"changeposition"];
    
    [self.delegate sliderViewDidStartAnimate];
}

- (void)updatePosition:(CGPoint)point {
    self.frame = CGRectMake(point.x, point.y, self.width, self.height);
    
    BOOL moveLeft = self.x > point.x;
    
    _moveDirection = moveLeft ? MoveDirectionLeft : MoveDirectionRight;
    
    [self.delegate sliderViewDidChangeFrameWithoutAimate:self.frame];
}

@end
