#import <objc/runtime.h>

#import "_UISignal.h"
#import "UIView+UISignal.h"

#pragma mark - Usage

/**
 * def signal
 @interface View1 : UIView
 
 @property(nonatomic,strong) View2 *v;
 
 ui_signal(VIEW1_FIRE)
 @end
 
 @implementation View1
 @synthesize v=v_;
 
 def_ui_signal(VIEW1_FIRE)
 
 ...
 
 @end
 
 * send signal
 
 [self sendUISignal:View1.VIEW1_FIRE withObject:self];
 
 * signal warning : 信号处理，必须要在一个事件链上，不然不可搞定.
 
 */

#pragma mark -

@implementation UIView ( UISignal )

+ (NSString *)SIGNAL {
	return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE {
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (void)handleUISignal:(_UISignal *)signal {
	if ( self.superview ) {
		[signal forward:self.superview];
	} else {
		signal.reach = YES;
	}
}

- (_UISignal *)sendUISignal:(NSString *)name {
	return [self sendUISignal:name withObject:nil from:self];
}

- (_UISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object {
	return [self sendUISignal:name withObject:object from:self];
}

- (_UISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source {
    _UISignal * signal = [[_UISignal alloc] init];
	if ( signal ) {
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;		
		signal.object = object;
		[signal send];
	}
	return signal;
}

- (UIViewController *)viewController {
    if ([self.superview isKindOfClass:[UIWindow class]] || (self.superview == nil)) {
        id nextResponder = [self nextResponder];
        if ( [nextResponder isKindOfClass:[UIViewController class]] ) {
            return (UIViewController *)nextResponder;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end
