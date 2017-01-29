//
//  _AlertView.m
//  Ape_uni
//
//  Created by Chenyu Lan on 8/21/13.
//  Copyright (c) 2013 Fenbi. All rights reserved.
//

#import "_AlertView.h"

@interface _AlertView ()

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UILabel *messageLabel;

- (UIButton *)buttonAtIndex:(NSUInteger)index;

@property (copy, nonatomic) void (^clickedBlock)(_AlertView *, BOOL, NSInteger);

@end

@implementation _AlertView

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.userTitleColor) {
        self.titleLabel.textColor = self.userTitleColor;
    }
    
    if ([self.userMessage length] && self.userKeyMessageColorMap.count) {
        [self.userKeyMessageColorMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.messageLabel setAttributedText:self.userMessage withKeyText:key keyTextColor:obj];
        }];
    }
}

#pragma mark -

- (UILabel *)titleLabel {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)v;
            if ([label.text isEqualToString:self.title]) {
                return label;
            }
        }
    }
    
    return nil;
}

- (UILabel *)messageLabel {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)v;
            if (![label.text isEqualToString:self.title]) {
                return label;
            }
        }
    }
    
    return nil;
}

- (UIButton *)buttonAtIndex:(NSUInteger)index {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            UIButton *button = (UIButton *)v;
            if (button.tag == index) {//给button的标签赋一个值，以便区分左右两个Button，对其进行更详细的设置。
                return button;
            }
        }
    }
    
    return nil;
}

#pragma mark - tool

- (void)applyUserStyle {
    if system_version_greater_than_or_equal_to(@"8.0") {
//        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.userTitleColor}];
        
        //富文本属性
        __block NSMutableAttributedString *attributedMessage = nil;
        [self.userKeyMessageColorMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            attributedMessage = [self.userMessage withSubString:key color:obj];
        }];
        
        UIAlertController *alertController = [self valueForKeyPath:@"alertController"];
        [alertController setValue:attributedMessage forKey:@"attributedMessage"];
        
        /**
         *  @knowledge
         
            forKey: forKeyPath:
         
            1. 当然 在一般的修改一个对象的属性的时候，forKey和forKeyPath,没什么区别
            2. forKeyPath厉害在，能使用点语法，深层次的去寻找我们需要的属性
         */
    }
}

@end

