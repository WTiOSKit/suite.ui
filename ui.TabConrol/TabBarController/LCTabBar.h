//
//  LCTabBar.h
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LCTabBar, LCTabBarItem;

@protocol LCTabBarDelegate <NSObject>

@optional

- (void)tabBar:(LCTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end



@interface LCTabBar : UIView

/**
 *  Tabbar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  Tabbar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 *  Tabbar background color
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

@property (nonatomic, assign) NSInteger tabBarItemCount;

@property (nonatomic, strong) LCTabBarItem *selectedItem;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, weak) id<LCTabBarDelegate> delegate;

/**
 *  该方法 将要废弃
 *
 *  @param item
 *  @param type
 */
- (void)addTabBarItem:(UITabBarItem *)item type:(int)type;

/**
 *  摆脱类型 增加Item
 *
 *  @param item        实际的TabBarItem
 *  @param wrapperItem 自己封装的的Item
 */
- (void)addTabBarItem:(UITabBarItem *)item withWrapperTabBarItem:(LCTabBarItem *)wrapperItem;

@end
