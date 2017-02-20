//
//  UIScrollView+Extension.m
//  component
//
//  Created by fallen.ink on 4/8/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView ( Geometry )

- (void)setContentInsetTop:(CGFloat)contentInsetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)contentInsetTop {
    return self.contentInset.top;
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)contentInsetBottom {
    return self.contentInset.bottom;
}

- (void)setContentInsetLeft:(CGFloat)contentInsetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)contentInsetLeft {
    return self.contentInset.left;
}

- (void)setContentInsetRight:(CGFloat)contentInsetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)contentInsetRight {
    return self.contentInset.right;
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    CGPoint offset = self.contentOffset;
    offset.x = contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    CGPoint offset = self.contentOffset;
    offset.y = contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}

- (void)setContentSizeWidth:(CGFloat)contentSizeWidth {
    CGSize size = self.contentSize;
    size.width = contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (void)setContentSizeHeight:(CGFloat)contentSizeHeight {
    CGSize size = self.contentSize;
    size.height = contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)contentSizeHeight {
    return self.contentSize.height;
}

@end

#pragma mark - 

@implementation UIScrollView (UIPages)
- (NSInteger)pages{
    NSInteger pages = self.contentSize.width/self.frame.size.width;
    return pages;
}

- (NSInteger)currentPage{
    NSInteger pages = self.contentSize.width/self.frame.size.width;
    CGFloat scrollPercent = [self scrollPercent];
    NSInteger currentPage = (NSInteger)roundf((pages-1)*scrollPercent);
    return currentPage;
}

- (CGFloat)scrollPercent{
    CGFloat width = self.contentSize.width-self.frame.size.width;
    CGFloat scrollPercent = self.contentOffset.x/width;
    return scrollPercent;
}

- (CGFloat)pagesY {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat contentHeight = self.contentSize.height;
    return contentHeight/pageHeight;
}

- (CGFloat)pagesX{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat contentWidth = self.contentSize.width;
    return contentWidth/pageWidth;
}

- (CGFloat)currentPageY{
    CGFloat pageHeight = self.frame.size.height;
    CGFloat offsetY = self.contentOffset.y;
    return offsetY / pageHeight;
}

- (CGFloat)currentPageX{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat offsetX = self.contentOffset.x;
    return offsetX / pageWidth;
}

- (void)setPageY:(CGFloat)page{
    [self setPageY:page animated:NO];
}

- (void) setPageX:(CGFloat)page{
    [self setPageX:page animated:NO];
}

- (void)setPageY:(CGFloat)page animated:(BOOL)animated {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat offsetY = page * pageHeight;
    CGFloat offsetX = self.contentOffset.x;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset];
}

- (void)setPageX:(CGFloat)page animated:(BOOL)animated{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat offsetY = self.contentOffset.y;
    CGFloat offsetX = page * pageWidth;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset animated:animated];
}

@end

#pragma mark -

@implementation UIScrollView ( Addition )

- (CGFloat)contentWidth {
    return self.contentSize.width;
}

- (void)setContentWidth:(CGFloat)width {
    self.contentSize = CGSizeMake(width, self.frame.size.height);
}

- (CGFloat)contentHeight {
    return self.contentSize.height;
}

- (void)setContentHeight:(CGFloat)height {
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}

- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}

- (void)setContentOffsetX:(CGFloat)x {
    self.contentOffset = CGPointMake(x, self.contentOffset.y);
}

- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}

- (void)setContentOffsetY:(CGFloat)y {
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
}

- (CGPoint)topContentOffset {
    return CGPointMake(0.0f, -self.contentInset.top);
}

- (CGPoint)bottomContentOffset {
    return CGPointMake(0.0f, self.contentSize.height + self.contentInset.bottom - self.bounds.size.height);
}

- (CGPoint)leftContentOffset {
    return CGPointMake(-self.contentInset.left, 0.0f);
}

- (CGPoint)rightContentOffset {
    return CGPointMake(self.contentSize.width + self.contentInset.right - self.bounds.size.width, 0.0f);
}

- (UIScrollDirection)ScrollDirection {
    UIScrollDirection direction;
    
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.0f) {
        direction = UIScrollDirectionUp;
    } else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.0f) {
        direction = UIScrollDirectionDown;
    } else if ([self.panGestureRecognizer translationInView:self].x < 0.0f) {
        direction = UIScrollDirectionLeft;
    } else if ([self.panGestureRecognizer translationInView:self].x > 0.0f) {
        direction = UIScrollDirectionRight;
    } else {
        direction = UIScrollDirectionWTF;
    }
    
    return direction;
}

- (BOOL)isScrolledToTop {
    return self.contentOffset.y <= [self topContentOffset].y;
}

- (BOOL)isScrolledToBottom {
    return self.contentOffset.y >= [self bottomContentOffset].y;
}

- (BOOL)isScrolledToLeft {
    return self.contentOffset.x <= [self leftContentOffset].x;
}

- (BOOL)isScrolledToRight {
    return self.contentOffset.x >= [self rightContentOffset].x;
}

- (void)scrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:[self topContentOffset] animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    [self setContentOffset:[self bottomContentOffset] animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated {
    [self setContentOffset:[self leftContentOffset] animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated {
    [self setContentOffset:[self rightContentOffset] animated:animated];
}

- (NSUInteger)verticalPageIndex {
    return (self.contentOffset.y + (self.frame.size.height * 0.5f)) / self.frame.size.height;
}

- (NSUInteger)horizontalPageIndex {
    return (self.contentOffset.x + (self.frame.size.width * 0.5f)) / self.frame.size.width;
}

- (void)scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0.0f, self.frame.size.height * pageIndex) animated:animated];
}

- (void)scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.frame.size.width * pageIndex, 0.0f) animated:animated];
}

@end


