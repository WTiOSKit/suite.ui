//
//  LBTabBarController.h
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTabBar.h"

@interface LBTabBarController : UITabBarController

@property (nonatomic, strong, readonly) LBTabBar *lbTabbar;

- (void)addChildViewController:(UIViewController *)viewController image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title;

@end
