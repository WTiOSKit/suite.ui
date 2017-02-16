//
//  UIControl+Convenience.m
//  component
//
//  Created by fallen.ink on 4/7/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UIControl+Extension.h"
#import "_precompile.h"

@implementation UIControl ( Target_Action )

- (void)removeAllTargetActionEvents {
    [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

@end

#pragma mark -

@implementation UIControl ( Event )

+ (void)load {
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (void)_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent) {
        LOG(@"acceptEventInterval triggered!");
        
        return;
    }
    
    if (self.acceptEventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.acceptEventInterval];
    }
    
    [self _sendAction:action to:target forEvent:event];
}

#pragma mark - Property

- (NSTimeInterval)acceptEventInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, @selector(acceptEventInterval), @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, @selector(ignoreEvent), @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
