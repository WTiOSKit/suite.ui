//
//  UITextField+Proxy.m
//
//  Created by fallen.ink on 3/30/16.
//
//

#import <objc/runtime.h>

#import "UITextField+Proxy.h"
#import "TextFieldDelegate.h"

@interface UITextField ()

@property (strong, nonatomic, readonly) TextFieldDelegate *proxyObject;

@end

@implementation UITextField (Proxy)

- (TextFieldDelegate *)proxyObject {
    TextFieldDelegate *proxy = objc_getAssociatedObject(self, @selector(proxyObject));
    
    if (!proxy) {
        proxy = [[TextFieldDelegate alloc] initWithTextField:self];
        
        objc_setAssociatedObject(self, @selector(proxyObject), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

- (TextFieldDelegate *)getProxyObject {
    self.delegate = self.proxyObject; // delegate is weak attribute, so it's reasonable.
    
    return self.proxyObject;
}

@end
