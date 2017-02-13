//
//  LCTabBarController.m
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCTabBarCONST.h"
#import "LCTabBarItem.h"

/**
 *  静态变量
 */
NSUInteger nonTitleIndex = -1;

@interface LCTabBarController ()

@end

@implementation LCTabBarController

#pragma mark -

- (UIColor *)itemTitleColor {
    
    if (!_itemTitleColor) {
        
        _itemTitleColor = LCColorForTabBar(117, 117, 117);
    }
    return _itemTitleColor;
}

- (UIColor *)selectedItemTitleColor {
    
    if (!_selectedItemTitleColor) {
        
        _selectedItemTitleColor = LCColorForTabBar(234, 103, 7);
    }
    return _selectedItemTitleColor;
}

- (UIColor *)tabBarBackgroundColor {
    if (!_tabBarBackgroundColor) {
        _tabBarBackgroundColor = [UIColor whiteColor];
    }
    
    return _tabBarBackgroundColor;
}

- (UIFont *)itemTitleFont {
    
    if (!_itemTitleFont) {
        
        _itemTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return _itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    
    if (!_badgeTitleFont) {
        
        _badgeTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return _badgeTitleFont;
}

#pragma mark -

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.70f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar addSubview:({
        
        LCTabBar *tabBar = [[LCTabBar alloc] init];
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        self.lcTabBar = tabBar;
        
//        storedTabBar = tabBar;
    })];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self removeOriginControls];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)removeOriginControls {
    
    [self.tabBar.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIControl class]]) {
            
            [obj removeFromSuperview];
        }
    }];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    self.lcTabBar.badgeTitleFont         = self.badgeTitleFont;
    self.lcTabBar.itemTitleFont          = self.itemTitleFont;
    self.lcTabBar.itemImageRatio         = self.itemImageRatio;
    self.lcTabBar.itemTitleColor         = self.itemTitleColor;
    self.lcTabBar.selectedItemTitleColor = self.selectedItemTitleColor;
    self.lcTabBar.backgroundColor        = self.tabBarBackgroundColor;
    self.lcTabBar.tabBarBackgroundColor  = [self.tabBarBackgroundColor copy];
    
    self.lcTabBar.tabBarItemCount = viewControllers.count;
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TabBarViewType type = TabBarViewType_normal;
        UIViewController *VC = (UIViewController *)obj;
        
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:VC];
        
        if (idx == nonTitleIndex) type = TabBarViewType_NonTitle;
        
        [self.lcTabBar addTabBarItem:VC.tabBarItem type:type];
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.lcTabBar.selectedItem.selected = NO;
    self.lcTabBar.selectedItem = self.lcTabBar.tabBarItems[selectedIndex];
    self.lcTabBar.selectedItem.selected = YES;
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(LCTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    if (is_method_implemented(self.lctdelegate, LCTTabBarController:didSelectedItemFrom:to:)) {
        [self.lctdelegate LCTTabBarController:self didSelectedItemFrom:from to:to];
    }
    
    self.selectedIndex = to;
}

#pragma mark - Tool

- (BOOL)isVisibleEx {
    return (self.isViewLoaded && self.view.window);
}

@end

