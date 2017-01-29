//
//  LSYActivityIndicator.m
//  LoadingHUD
//
//  Created by Labanotation on 16/5/6.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYActivityIndicator.h"
#import <objc/runtime.h>

#define ANIMATION_DURATION_SECS 0.4

@interface LSYActivityIndicator ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) float dotRadius;
@property (nonatomic, assign) int stepNumber;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) CGRect firstPoint, secondPoint;
@property (nonatomic, strong) CALayer *firstDot, *secondDot;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong) id timerTarget;

@end

@implementation LSYActivityIndicator

static const void * weakKey = @"weakKey";

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViewLayout:self.frame];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewLayout:frame];
    }
    return self;
}

- (void)setupViewLayout:(CGRect)frame {
    _stepNumber = 0;
    _isAnimating = NO;
    self.hidesWhenStopped = YES;
    UIColor *blueColor = [UIColor colorWithRed:218/255.0f green:17/255.0f blue:82/255.0f alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:50/255.f green:161/255.f blue:247/255.f alpha:1.0];
    
    _dotRadius = 5.5f;
    _firstPoint = CGRectMake(frame.size.width/2-20.f, frame.size.height/2-_dotRadius, 2*_dotRadius, 2*_dotRadius);
    _secondPoint = CGRectMake(frame.size.width/2+20.f, frame.size.height/2-_dotRadius, 2*_dotRadius, 2*_dotRadius);

    _firstDot = [CALayer layer];
    [_firstDot setMasksToBounds:YES];
    [_firstDot setBackgroundColor:[blueColor CGColor]];
    [_firstDot setCornerRadius:_dotRadius];
    [_firstDot setBounds:CGRectMake(0.0f, 0.0f, _dotRadius*2, _dotRadius*2)];
    _firstDot.frame = _firstPoint;
    
    _secondDot = [CALayer layer];
    [_secondDot setMasksToBounds:YES];
    [_secondDot setBackgroundColor:[redColor CGColor]];
    [_secondDot setCornerRadius:_dotRadius];
    [_secondDot setBounds:CGRectMake(0.0f, 0.0f, _dotRadius*2, _dotRadius*2)];
    _secondDot.frame = _secondPoint;
    
    [[self layer] addSublayer:_firstDot];
    [[self layer] addSublayer:_secondDot];
    
    self.layer.hidden = YES;
}

- (void)startAnimating {
    if (!_isAnimating) {
        _isAnimating = YES;
        self.layer.hidden = NO;
        _timerTarget = [NSObject new];
        class_addMethod([_timerTarget class], @selector(animateNextStep), (IMP)timMethod, "v@:");
        
        objc_setAssociatedObject(_timerTarget, weakKey, self, OBJC_ASSOCIATION_ASSIGN);
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION_SECS target:_timerTarget selector:@selector(animateNextStep) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        // Animate imidiately
        [self animateNextStep];
    }
}
void timMethod(id self,SEL _cmd) {
    LSYActivityIndicator *indicator = objc_getAssociatedObject(self, weakKey);
    IMP imp = [indicator methodForSelector:_cmd];
    void (*func)(id,SEL) = (void *)imp;
    func(indicator,_cmd);
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)stopAnimating {
    _isAnimating = NO;
    if (self.hidesWhenStopped)
        self.layer.hidden = YES;
    [_timer invalidate];
    _stepNumber = 0;
    _firstDot.frame = self.firstPoint;
    _secondDot.frame = self.secondPoint;
}

- (void)animateNextStep {
    switch (_stepNumber) {
        case 0:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            _firstDot.frame = _secondPoint;
            _secondDot.frame = _firstPoint;
            
            
            [CATransaction commit];
            
            _stepNumber++;
            break;
        case 1:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            
            _firstDot.frame = _firstPoint;
            _secondDot.frame = _secondPoint;
            
            _stepNumber = 0;
            [CATransaction commit];
            break;
        default:
            break;
    }
    
    
}

- (BOOL)isAnimating {
    return _isAnimating;
}

@end
