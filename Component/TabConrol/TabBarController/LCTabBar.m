//
//  LCTabBar.m
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "_ui_core.h"

#import "LCTabBar.h"
#import "LCTabBarItem.h"

@interface LCTabBar ()

@end

@implementation LCTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mas_addRectEdgeWithStyle:kEdgeStyleTop thickness:1 color:[UIColor clearColor]];
    }
    
    return self;
}

- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        
        _tabBarItems = [[NSMutableArray alloc] init];
    }
    return _tabBarItems;
}

- (void)addTabBarItem:(UITabBarItem *)item type:(int)type {
    
    LCTabBarItem *tabBarItem = [LCTabBarItem tabBarItemWith:type itemImageRatio:self.itemImageRatio];
    
    tabBarItem.badgeTitleFont         = self.badgeTitleFont;
    tabBarItem.itemTitleFont          = self.itemTitleFont;
    tabBarItem.itemTitleColor         = self.itemTitleColor;
    tabBarItem.selectedItemTitleColor = self.selectedItemTitleColor;
    
    tabBarItem.tabBarItemCount = self.tabBarItemCount;
    
    tabBarItem.tabBarItem = item;
    
    [tabBarItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:tabBarItem];
    
    [self.tabBarItems addObject:tabBarItem];
    
    if (self.tabBarItems.count == 1) {
        
        [self buttonClick:tabBarItem];
    }
}

- (void)addTabBarItem:(UITabBarItem *)item withWrapperTabBarItem:(LCTabBarItem *)wrapperItem {
    LCTabBarItem *tabBarItem = wrapperItem;
    
    tabBarItem.itemImageRatio         = self.itemImageRatio;
    tabBarItem.badgeTitleFont         = self.badgeTitleFont;
    tabBarItem.itemTitleFont          = self.itemTitleFont;
    tabBarItem.itemTitleColor         = self.itemTitleColor;
    tabBarItem.selectedItemTitleColor = self.selectedItemTitleColor;
    
    tabBarItem.tabBarItemCount = self.tabBarItemCount;
    
    tabBarItem.tabBarItem = item;
    
    [tabBarItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:tabBarItem];
    
    [self.tabBarItems addObject:tabBarItem];
    
    if (self.tabBarItems.count == 1) {
        
        [self buttonClick:tabBarItem];
    }
}

- (void)buttonClick:(LCTabBarItem *)tabBarItem {
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
        
        [self.delegate tabBar:self didSelectedItemFrom:self.selectedItem.tabBarItem.tag to:tabBarItem.tag];
    }
    
    self.selectedItem.selected = NO;
    self.selectedItem = tabBarItem;
    self.selectedItem.selected = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    int count = (int)self.tabBarItems.count;
    CGFloat itemY = 0;
    CGFloat itemW = w / count;
    CGFloat itemH = h;
    
    for (int index = 0; index < count; index++) {
        
        LCTabBarItem *tabBarItem = self.tabBarItems[index];
        tabBarItem.tag = index;
        CGFloat itemX = index * itemW;
        tabBarItem.frame = [tabBarItem changeWithExpectedFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    }
}

@end
