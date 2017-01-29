//
//  LCTabBarBadge.h
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTabBarBadge : UIButton

@property (nonatomic, copy) NSString *badgeValue;

@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  Tabbar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

+ (instancetype)badgeWithValue:(NSString *)value;

+ (void)showInView:(UIView *)superView withBadgeValue:(int32_t)value center:(CGPoint)center;

@end

typedef LCTabBarBadge BadgeView;

#pragma mark - 

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   // 显示小红点

- (void)hideBadgeOnItemIndex:(int)index;   // 隐藏小红点

- (void)showBadgeOnItemIndex:(int)index withIndexCount:(NSUInteger)count;

@end

