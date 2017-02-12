//
//  UIBarButtonItem+ImageItem.m
//  component
//
//  Created by fallen.ink on 4/7/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UIBarButtonItem+ImageItem.h"

@implementation UIBarButtonItem (ImageItem)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[self alloc] initWithCustomView:button];
    return item;
}

@end
