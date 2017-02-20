//
//  UIViewSliderAnimateLayer.m
//  hairdresser
//
//  Created by fallen.ink on 7/1/16.
//
//

#import "_ui_core.h"
#import "DVSliderAnimateLayer.h"

@interface DVSliderAnimateLayer ()

@property (nonatomic, assign) BOOL shouldAnimate;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGPoint drivenViewPosition;

@property (nonatomic, assign) CGFloat lastX;

@property (nonatomic, assign) MoveDirection moveDirection;

@property (nonatomic, assign) CGRect currentRect;

@property (nonatomic, assign) CGFloat factor;

@property (nonatomic, assign) BOOL beginGooeyAnimation;

@end

@implementation DVSliderAnimateLayer

- (instancetype)init {
    if (self = [super init]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLayer)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
    
    return self;
}

#pragma mark - Draw handling

- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    
    CGFloat x = self.drivenViewPosition.x;
    CGFloat y = self.drivenViewPosition.y;
    CGFloat height = self.currentRect.size.height;
    CGFloat width = self.currentRect.size.width;
    CGFloat factor = MIN(1, MAX(0, (ABS(x - self.lastX) / height)));
    CGFloat extra = (height * 2 / 5) * factor;

    if (!self.shouldAnimate) {
        extra = 0;
    }
    
    /**
     *  6 个点来定位该形状
     
     *  依次是左上、右上、右中、右下、左下、左中
     
     *  向右滑动，左中带弹性；向左滑动，右中带弹性。
     */
    CGPoint pointLeftUp = CGPointMake(x+height/2, y);
    CGPoint pointRightUp = CGPointMake(width-height/2+x, y);
    CGPoint pointRight = CGPointMake((self.moveDirection == MoveDirectionLeft ? width + extra * 2 : width)+x,
                                     height/2+y);
    
    CGPoint pointRightDown = CGPointMake(x+width-height/2, height+y);
    CGPoint pointLeftDown = CGPointMake(x+height/2, height+y);
    CGPoint pointLeft = CGPointMake((self.moveDirection == MoveDirectionRight ? extra * 2: 0)+x, height/2+y);

    // 控制点
    CGFloat factorOnHorizontal = 3.6;
    CGFloat factorOnVertical = 3.6;
    CGFloat offsetOnHorizontal = height/factorOnHorizontal;
    CGFloat offsetOnVertical = height/factorOnVertical;
    
    /* pointRightUp, pointRight 之间 */
    CGPoint c1 = CGPointMake(pointRightUp.x+offsetOnHorizontal, pointRightUp.y);
    CGPoint c2 = CGPointMake(pointRight.x, pointRight.y-offsetOnVertical);
    
    /* pointRight, pointRightDown 之间 */
    CGPoint c3 = CGPointMake(pointRight.x, pointRight.y+offsetOnVertical);
    CGPoint c4 = CGPointMake(pointRightDown.x+offsetOnHorizontal, pointRightDown.y);
    
    /* pointLeftDown, pointLeft 之间 */
    CGPoint c5 = CGPointMake(pointLeftDown.x-offsetOnHorizontal, pointLeftDown.y);
    CGPoint c6 = CGPointMake(pointLeft.x, pointLeft.y+offsetOnVertical);
    
    /* pointLeft, pointLeftUp 之间 */
    CGPoint c7 = CGPointMake(pointLeft.x, pointLeft.y-offsetOnVertical);
    CGPoint c8 = CGPointMake(pointLeftUp.x-offsetOnHorizontal, pointLeftUp.y);
    
    // 绘制路径
    [bPath moveToPoint:pointRightUp];
    [bPath addCurveToPoint:pointRight controlPoint1:c1 controlPoint2:c2];
    [bPath addCurveToPoint:pointRightDown controlPoint1:c3 controlPoint2:c4];
    [bPath addLineToPoint:pointLeftDown];
    [bPath addCurveToPoint:pointLeft controlPoint1:c5 controlPoint2:c6];
    [bPath addCurveToPoint:pointLeftUp controlPoint1:c7 controlPoint2:c8];
    [bPath addLineToPoint:pointRightUp];
    
    [bPath closePath];
    
    CGContextAddPath(ctx, bPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);//self.sliderView.sliderColor.CGColor);
    CGContextFillPath(ctx);
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqual:stringify(factor)]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)updateLayer {
    CALayer *layer = _sliderView.layer.presentationLayer;
    
    // change origin-point from center to left-up
    _drivenViewPosition = CGPointMake(layer.position.x, layer.position.y-_sliderView.height/2);
    
    [self animateWithPosition:_drivenViewPosition];
    
    // @fallenink 研究一下
    // 用这个动画方式的话，UIView的x是事先设定的，通过CAKeyFrameAnimation实现的？
    //    [UIView animateWithDuration:interval
    //                     animations:^{
    //                         self.frame = CGRectMake(point.x, point.y, self.width, self.height);
    //                     } completion:^(BOOL finished) {
    //                         [self endAnimate];
    //                     }];
}

- (void)setSliderView:(DVSliderView *)sliderView {
    _sliderView = sliderView;
    
    _sliderView.delegate = self;
}

#pragma mark - Public

- (void)animate {
    _drivenViewPosition = _sliderView.frame.origin;
    [self animateWithPosition:_drivenViewPosition];
}

- (void)animateWithPosition:(CGPoint)point {
    
    /**
     *  1. 动画有：平移、形变、黏状动画
     *  2. 首先是形变，然后是黏状动画，平移是抑制的
     */
    if (!_beginGooeyAnimation) {
        _factor = MIN(1, MAX(0, (ABS(point.x - self.lastX) / _sliderView.width)));
    }
    
    CGFloat width = _sliderView.width;
    CGFloat height = _sliderView.height;
    CGFloat indicatorSize = 20.f; // 形变之后的大小
    CGFloat originX = point.x;

    self.currentRect = CGRectMake(originX, self.frame.size.height / 2 - indicatorSize / 2, width, height);
    
    [self setNeedsDisplay];
}

#pragma mark - DVSliderViewDelegate

- (void)sliderView:(DVSliderView *)sliderView willStartAnimateWithPosition:(CGPoint)point interval:(NSTimeInterval)interval scrollDirection:(MoveDirection)direction {
    self.shouldAnimate = YES;
    
    CALayer *layer = _sliderView.layer.presentationLayer;
    _lastX = layer.position.x;
    
    _displayLink.paused = NO;
}

- (void)sliderViewDidStartAnimate {
    
}

- (void)sliderViewWillEndAnimate {
    
}

- (void)sliderViewDidEndAnimate {
    _displayLink.paused = YES;
    
    CALayer *layer = _sliderView.layer.presentationLayer;
    _lastX = layer.position.x;
}

- (void)sliderViewDidChangeFrameWithoutAimate:(CGRect)newFrame {
    _drivenViewPosition = newFrame.origin;
    
    self.shouldAnimate = NO;
    
    [self animateWithPosition:_drivenViewPosition];
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    _beginGooeyAnimation = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        _beginGooeyAnimation = NO;
        [self removeAllAnimations];
    }
}

#pragma mark -

- (CAKeyframeAnimation *)createSpringAnima:(NSString *)keypath
                                  duration:(CFTimeInterval)duration
                    usingSpringWithDamping:(CGFloat)damping
                     initialSpringVelocity:(CGFloat)velocity
                                 fromValue:(id)fromValue
                                   toValue:(id)toValue {
    
    CGFloat dampingFactor = 10.0;
    CGFloat velocityFactor = 10.0;
    NSMutableArray *values = [self springAnimationValues:fromValue
                                                 toValue:toValue
                                  usingSpringWithDamping:damping * dampingFactor
                                   initialSpringVelocity:velocity * velocityFactor
                                                duration:duration];
    CAKeyframeAnimation *anim =
    [CAKeyframeAnimation animationWithKeyPath:keypath];
    anim.values = values;
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

- (NSMutableArray *)springAnimationValues:(id)fromValue
                                  toValue:(id)toValue
                   usingSpringWithDamping:(CGFloat)damping
                    initialSpringVelocity:(CGFloat)velocity
                                 duration:(CGFloat)duration {
    // 60个关键帧
    NSInteger numOfFrames = duration * 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numOfFrames];
    for (NSInteger i = 0; i < numOfFrames; i++) {
        [values addObject:@(0.0)];
    }
    
    //差值
    CGFloat diff = [toValue floatValue] - [fromValue floatValue];
    for (NSInteger frame = 0; frame < numOfFrames; frame++) {
        CGFloat x = (CGFloat)frame / (CGFloat)numOfFrames;
        CGFloat value = [toValue floatValue] -
        diff * (pow(M_E, -damping * x) *
                cos(velocity * x)); // y = 1-e^{-5x} * cos(30x)
        values[frame] = @(value);
    }
    return values;
}

@end
