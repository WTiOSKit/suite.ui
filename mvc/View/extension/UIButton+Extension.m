//
//  UIButton+Adjust.m
//  component
//
//  Created by fallen.ink on 4/9/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UIButton+Extension.h"
#import "_precompile.h"

@implementation UIButton (Adjust)

- (void)centerImageAndTitle:(float)spacing {
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width+PIXEL_6);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle {
    [self centerImageAndTitle:PIXEL_8];
}

- (void)verticalCenterAndTopImageWithSpace:(CGFloat)space {
    [self centerImageAndTitle:space];
}

- (void)horizontalCenterAndLeftImageWithSpace:(CGFloat)space {
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    //    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    CGFloat totalWidth = (imageSize.width + titleSize.width + space);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.f, - (totalWidth - imageSize.width), 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.f, - (totalWidth - titleSize.width));
}

- (void)horizontalCenterAndLeftTitleWithSpace:(CGFloat)space {
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
//    exceptioning(@"还没实现")
    // get the height they will take up as a unit: 先计算出content的等效宽度，其中包含space
    //    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    CGFloat totalWidth = (imageSize.width + titleSize.width + space);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.f, -imageSize.width, 0.0, (totalWidth - titleSize.width));
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width, 0.f, - (totalWidth - imageSize.width));
}

@end

#pragma mark -

#import "UIImage+Utility.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"

@implementation UIButton ( Setting )

#pragma mark - Setter

- (void)setTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setTitleColor:(UIColor *)tc backgroundColor:(UIColor *)bc {
    [self setTitleColor:tc];
    
    [self setImage:[UIImage imageWithColor:bc] forState:UIControlStateNormal];
    [self setImage:[UIImage imageWithColor:bc] forState:UIControlStateHighlighted];
}

- (void)setNormalBackgroundColor:(UIColor *)color disableBackgroundColor:(UIColor *)color2 {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:color2] forState:UIControlStateDisabled];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

#pragma mark - Styled

- (void)liningStyled:(UIColor *)color {
    [self setBorderWidth:1.f withColor:color];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitleColor:color];
}

- (void)liningStyledWithTitleColor:(UIColor *)color borderColor:(UIColor *)bordercolor {
    [self setBorderWidth:1.f withColor:bordercolor];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitleColor:color];
}

- (void)colorlumpStyled:(UIColor *)color {
    [self setNormalBackgroundColor:color
            disableBackgroundColor:[UIColor colorWithRGBHex:0xcccccc]];
    
    [self setTitleColor:[UIColor whiteColor]];
}

@end

#pragma mark - 

@implementation UIButton ( Enlarge )

- (UIEdgeInsets)touchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

#pragma mark -

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargedEdge:(CGFloat)enlargedEdge {
    [self setEnlargeEdgeWithTop:enlargedEdge left:enlargedEdge bottom:enlargedEdge right:enlargedEdge];
}

-(CGFloat)enlargedEdge {
    return [(NSNumber *)objc_getAssociatedObject(self, &topNameKey) floatValue];
}

- (void)setEnlargeEdgeWithTop:(CGFloat)top
                        left:(CGFloat)left
                       bottom:(CGFloat)bottom
                         right:(CGFloat)right {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent*) event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
