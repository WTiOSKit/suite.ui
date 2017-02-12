
#import "_UISignal.h"

#pragma mark -

@interface UIView ( UISignal )

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (void)handleUISignal:(_UISignal *)signal;

- (_UISignal *)sendUISignal:(NSString *)name;
- (_UISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object;
- (_UISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source;


- (UIViewController *)viewController;

@end
