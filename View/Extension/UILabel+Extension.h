//
//  UILabel+Extension.h
//  component
//
//  Created by fallen.ink on 4/11/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @knowledge
 
 *  加约束的时候，label 高度一定，可以不设置宽度，会更根据内容自动填充；宽度一定（leading trailiing），可以不设置高度，会自动换行填充。
 */

@interface UILabel ( AttributeText )

- (void)setAttributedText:(NSString *)originText withKeyText:(NSString *)keyText keyTextColor:(UIColor *)textColor;

@end

#pragma mark -

@interface UILabel ( ContentSize )

- (CGFloat)heightWithLimitWidth:(CGFloat)width;

- (int)lineCountWithLimitWidth:(CGFloat)width;

- (BOOL)isTruncated;

@end

#pragma mark - System Adapt

@interface UILabel ( Adapt )

- (void)adapted;

@end
