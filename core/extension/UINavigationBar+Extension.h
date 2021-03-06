//
//  UINavigationBar+Awesome.h
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  注意：不能做以下设置
 
 *  1. self.edgesForExtendedLayout = UIRectEdgeNone
 *  2. [[UINavigationBar appearance] setTranslucent:NO];
 
 *  加了_前缀
 */
@interface UINavigationBar ( Extension )

- (void)_setBackgroundColor:(UIColor *)backgroundColor;

- (void)_setElementsAlpha:(CGFloat)alpha;

- (void)_setTranslationY:(CGFloat)translationY;

- (void)_reset;

@end
