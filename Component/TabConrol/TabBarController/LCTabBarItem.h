//
//  LCTabBarItem.h
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TabBarViewType_normal,
    TabBarViewType_circle,
    TabBarViewType_NonTitle
} TabBarViewType;

@interface LCTabBarItem : UIButton

@property (nonatomic, strong) UITabBarItem *tabBarItem;

@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  Tabbar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  Tabbar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

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

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio;

- (CGRect)changeWithExpectedFrame:(CGRect)frame;

@end

#pragma mark - 圆形跳起按钮视图

@interface CircleTabBarItem : LCTabBarItem

@property (nonatomic, assign) CGFloat bottomMargin;

@end

#pragma mark - 圆形按钮视图

@interface NonTitleTabBarItem : LCTabBarItem

@end

#pragma mark - LCTabBarItem 工厂

@interface LCTabBarItem ( Factory )

+ (instancetype)tabBarItemWith:(TabBarViewType)type itemImageRatio:(CGFloat)itemImageRatio;

@end

