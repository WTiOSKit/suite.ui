//
//  LCTabBarBadge.m
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "_precompile.h"
#import "_image.h"
#import "LCTabBarBadge.h"
#import "LCTabBarCONST.h"
#import "UIView+Extension.h"

@implementation LCTabBarBadge

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = NO;
        self.hidden = YES;
//        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"LCTabBarController" ofType:@"bundle"];
        NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"LCTabBarBadge@2x.png"];
        UIImage *image = [self resizedImageFromMiddle:[UIImage imageWithContentsOfFile:imagePath]];
//        image = [image imageByApplyingTintEffectWithColor:[UIColor redColor]];
        image = [image imageWithTintColor:[UIColor redColor]];
        [self setBackgroundImage:image
                        forState:UIControlStateNormal];
        
        self.titleLabel.font = font_normal_15;
    }
    return self;
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    
    _badgeTitleFont = badgeTitleFont;
    
    self.titleLabel.font = badgeTitleFont;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    
    _badgeValue = [badgeValue copy];
    
    self.hidden = !(BOOL)self.badgeValue;
    
    if (self.badgeValue) {
        
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        CGRect frame = self.frame;
        
        if (self.badgeValue.length > 0) {
            
            CGFloat badgeW = self.currentBackgroundImage.size.width;
//            CGFloat badgeH = self.currentBackgroundImage.size.height;
            
            CGSize titleSize = [@"99" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.badgeTitleFont, NSFontAttributeName, nil]];
            frame.size.width = MAX(badgeW, titleSize.width + PIXEL_10);
            frame.size.height = frame.size.width;
            self.frame = frame;
            
        } else {
            
            frame.size.width = PIXEL_4;
            frame.size.height = frame.size.width;
        }
        
        frame.origin.x = 58.0f * ([UIScreen mainScreen].bounds.size.width / self.tabBarItemCount) / screen_width * 4.0f;
        frame.origin.y = 2.0f;
        self.frame = frame;
    }
}

- (UIImage *)resizedImageFromMiddle:(UIImage *)image {
    
    return [self resizedImage:image width:1.f height:1.f];
}

- (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height {
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * width
                                      topCapHeight:image.size.height * height];
}

#pragma mark - 

+ (instancetype)badgeWithValue:(NSString *)value {
    LCTabBarBadge *badge = [[LCTabBarBadge alloc] init];
    badge.tabBarItemCount = 1;
    
    [badge setBadgeValue:value];
    
    return badge;
}

+ (void)showInView:(UIView *)superView withBadgeValue:(int32_t)value center:(CGPoint)center {
    int32_t badgeViewTag = 1001;
    [superView removeSubViewByTag:badgeViewTag];
    
    if (value > 0) {
        NSString *badgeValue = [NSString stringWithFormat:@"%@", @(value)];
        BadgeView *badge = [BadgeView badgeWithValue:badgeValue];
        
        badge.tag = badgeViewTag;
        
        [superView addSubview:badge];
        
        [badge setCenter:center];
    }
}

@end

#pragma mark -

#define TabbarItemNums 3.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (badge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index {
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

- (void)showBadgeOnItemIndex:(int)index withIndexCount:(NSUInteger)count {
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end


