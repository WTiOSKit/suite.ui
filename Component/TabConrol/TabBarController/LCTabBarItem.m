//
//  LCTabBarItem.m
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "_ui_core.h"
#import "LCTabBarItem.h"
#import "LCTabBarBadge.h"
#import "LCTabBarCONST.h"

@interface LCTabBarItem ()

@property (nonatomic, strong) LCTabBarBadge *tabBarBadge;

@end

@implementation LCTabBarItem

- (void)dealloc {
    
    [self.tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
    [self.tabBarItem removeObserver:self forKeyPath:@"title"];
    [self.tabBarItem removeObserver:self forKeyPath:@"image"];
    [self.tabBarItem removeObserver:self forKeyPath:@"selectedImage"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.tabBarBadge = [[LCTabBarBadge alloc] init];
        [self addSubview:self.tabBarBadge];
    }
    return self;
}

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio {
    
    if (self = [super init]) {
        
        self.itemImageRatio = itemImageRatio;
    }
    return self;
}

#pragma mark - 

- (CGRect)changeWithExpectedFrame:(CGRect)frame {
    return frame;
}

#pragma mark -

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    
    _itemTitleFont = itemTitleFont;
    
    self.titleLabel.font = itemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    
    _itemTitleColor = itemTitleColor;
    
    [self setTitleColor:itemTitleColor forState:UIControlStateNormal];
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    
    _selectedItemTitleColor = selectedItemTitleColor;
    
    [self setTitleColor:selectedItemTitleColor forState:UIControlStateSelected];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    
    _badgeTitleFont = badgeTitleFont;
    
    self.tabBarBadge.badgeTitleFont = badgeTitleFont;
}

#pragma mark -

- (void)setTabBarItemCount:(NSInteger)tabBarItemCount {
    
    _tabBarItemCount = tabBarItemCount;
    
    self.tabBarBadge.tabBarItemCount = self.tabBarItemCount;
}


- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    
    _tabBarItem = tabBarItem;
    
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"title" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"image" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    
    self.tabBarBadge.badgeValue = self.tabBarItem.badgeValue;
}

#pragma mark - Reset TabBarItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0.f;
    CGFloat imageY = 0.f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * self.itemImageRatio;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 0.f;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleY = contentRect.size.height * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : -5.0f);
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted {}

@end

#pragma mark - 圆形按钮视图

@interface CircleTabBarItem ()

@property (nonatomic, assign) CGFloat validHeight;

@end

@implementation CircleTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self liningStyled:[UIColor colorWithRGBHex:0xe0e0e0]];
    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0.f;
    CGFloat imageY = 0.f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * self.itemImageRatio;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 0.f;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleY = self.validHeight * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : 8.0f);
    CGFloat titleH = self.validHeight - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)changeWithExpectedFrame:(CGRect)frame {
    self.validHeight = CGRectGetHeight(frame);
    
    // 修改frame到自己希望的
    frame = CGRectMake(frame.origin.x+4, frame.origin.y, frame.size.width-8, frame.size.width-8);
    
    // 变成圆形
    [self circular:CGRectGetWidth(frame)/2];
    
    return CGRectOffset(frame, 0, -30);
}

@end

#pragma mark - 圆形按钮视图

@implementation NonTitleTabBarItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0.f;
    CGFloat imageY = 0.f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectZero;
}

@end

#pragma mark - LCTabBarItem 工厂

@implementation LCTabBarItem ( Factory )

+ (instancetype)tabBarItemWith:(TabBarViewType)type itemImageRatio:(CGFloat)itemImageRatio {
    LCTabBarItem *instance = nil;
    
    if (type == TabBarViewType_normal) {
        instance = [[LCTabBarItem alloc] initWithItemImageRatio:itemImageRatio];
    } else if (type == TabBarViewType_circle) {
        instance = [[CircleTabBarItem alloc] initWithItemImageRatio:itemImageRatio];
    } else if (type == TabBarViewType_NonTitle) {
        instance = [[NonTitleTabBarItem alloc] initWithItemImageRatio:itemImageRatio];
    }
    
    return instance;
}

@end
