
#import <UIKit/UIKit.h>

@class _UISignal;


@interface UIViewController ( UISignal )

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (void)handleUISignal:(_UISignal *)signal;

- (_UISignal *)sendUISignal:(NSString *)name;
- (_UISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object;
- (_UISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source;

@end
