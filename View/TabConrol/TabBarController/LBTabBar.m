//
//  LBTabBar.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBar.h"
#import "_precompile.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import <objc/runtime.h>

static NSString *plusButtonImage = nil;

#define LBMagin 13.5

@interface LBTabBar ()

@property (nonatomic, strong) UIButton *plusBtn;

@end

@implementation LBTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:image_named(plusButtonImage) forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:image_named(plusButtonImage) forState:UIControlStateHighlighted];
    
        _plusBtn = plusBtn;
        
        [plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:plusBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    /** @knowledge
     ios 10 中，该函数调用次数减少，所以，size的设置，一定要在center设置前面
     */
    self.plusBtn.size = CGSizeMake(self.plusBtn.currentBackgroundImage.size.width/5*4, self.plusBtn.currentBackgroundImage.size.height/5*4);

    self.plusBtn.center = CGPointMake(self.centerX, self.height * 0.5 - 2*LBMagin);

    {
        UILabel *label = [self viewWithTag:1111];
        
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.plusBtn.currentBackgroundImage.size.width/5*4, 21.f)];
            label.text = @"魔镜";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14.0];
            label.textColor = [UIColor colorWithRGBHex:0x5e5e5e];
            label.tag = 1111;
            [self addSubview:label];
        }
        
        label.center = CGPointMake(self.plusBtn.centerX, CGRectGetMaxY(self.plusBtn.frame) + LBMagin);
    }
    
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            btn.width = self.width / 3;

            btn.x = btn.width * btnIndex;

            btnIndex++;
            //如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 1) {
                btnIndex++;
            }
        }
    }
    
    [self bringSubviewToFront:self.plusBtn];
}

- (void)plusBtnDidClick {
    if ([self.myDelegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {

        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];

        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        } else {//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }

    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - config

+ (void)setPlusButtonImage:(NSString *)imageName {
    plusButtonImage = imageName;
}

@end
