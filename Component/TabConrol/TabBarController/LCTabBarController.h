//
//  LCTabBarController.h
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//
//  GitHub: https://github.com/iTofu/LCTabBarController
//  Blog:   http://LeoDev.me
//
//  V 1.3.3

#import "_greats.h"
#import "LCTabBar.h"

/**
 *  无效值为－1
 */
EXTERN NSUInteger nonTitleIndex; // 将 TabBarItem 的 title 去掉，让 image 区域扩展，default 为 －1

@protocol LCTabBarControllerDelegate;

@interface LCTabBarController : UITabBarController <LCTabBarDelegate>

@property (nonatomic, strong) LCTabBar *lcTabBar;

/**
 *  LCTabBarController delegate
 */
@property (nonatomic, weak) id<LCTabBarControllerDelegate> lctdelegate;

/**
 *  Tabbar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  Tabbar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 * Tabbar background color
 */
@property (nonatomic, strong) UIColor *tabBarBackgroundColor;

/**
 *  Tabbar item title font
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 *  Tabbar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  Tabbar item image ratio
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  Remove origin controls, for `- popToRootViewController`
 */
- (void)removeOriginControls;

- (BOOL)isVisibleEx;

@end

#pragma mark - LCTabBarControllerDelegate

@protocol LCTabBarControllerDelegate <UITabBarControllerDelegate>
@optional
- (void)LCTTabBarController:(LCTabBarController *)controller didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end
