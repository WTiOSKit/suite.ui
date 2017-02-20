//
//  HXTagAttribute.m
//  HXTagsView https://github.com/huangxuan518/HXTagsView
//  博客地址 http://blog.libuqing.com/
//  Created by Love on 16/6/30.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "_ui_core.h"
#import "HXTagAttribute.h"

@implementation HXTagAttribute

- (instancetype)init {
    self = [super init];
    if (self) {
        UIColor *normalColor = font_gray_2;
        UIColor *normalBackgroundColor = [UIColor whiteColor];
        
        _borderWidth = 0.5f;
        _borderColor = normalColor;
        _cornerRadius = 2.0;
        _backgroundColor = normalBackgroundColor;
        _titleSize = 14;
        _textColor = normalColor;
        _keyColor = [UIColor redColor];
        _tagSpace = 20;
    }
    return self;
}

#pragma mark -

+ (instancetype)normal {
    HXTagAttribute *attr = [HXTagAttribute new];
    UIColor *normalColor = font_gray_2;
    
    attr.borderColor = normalColor;
    attr.textColor = normalColor;
    
    
    return attr;
}

+ (instancetype)selected {
    HXTagAttribute *attr = [HXTagAttribute new];
    UIColor *normalColor = [UIColor themeColor];
    
    attr.borderColor = normalColor;
    attr.textColor = normalColor;
    
    return attr;
}

@end
