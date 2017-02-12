//
//  UIBarButtonItem+ImageItem.h
//  component
//
//  Created by fallen.ink on 4/7/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

// inspired by https://github.com/egold/UIKitConvenience/tree/master/UIKitConvenience

@interface UIBarButtonItem (ImageItem)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end
