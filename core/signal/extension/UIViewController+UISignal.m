#import <objc/runtime.h>
#import "_UISignal.h"
#import "UIViewController+UISignal.h"
#import "UIView+UISignal.h"

#pragma mark - Usage

/**
 * handle signal 
 
 - (void)handleUISignal:(_UISignal *)signal
 {
	[super handleUISignal:signal];
 
    // handling
 }
 
 or
 
 - (void)handleUISignal_View1:(_UISignal *)signal
 {
    [super handleUISignal:signal];
 
    if ( [signal is:View1.VIEW1_FIRE] )
    {
 
        // handling
    }
 }
 */

#pragma mark -

@implementation UIViewController ( UISignal )

+ (NSString *)SIGNAL {
	return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE {
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (void)handleUISignal:(_UISignal *)signal {
	signal.reach = YES;
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

@end


