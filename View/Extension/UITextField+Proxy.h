//
//  UITextField+Proxy.h
//
//  Created by fallen.ink on 3/30/16.
//
//

#import <UIKit/UIKit.h>

@class TextFieldDelegate;

@interface UITextField (Proxy)

- (TextFieldDelegate *)getProxyObject;

@end
