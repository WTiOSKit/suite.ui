//
//  UIScrollView+Extension.h
//  component
//
//  Created by fallen.ink on 4/8/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

// inspired by https://github.com/mapedd/UIView-TKGeometry/blob/master/UIView%2BTKGeometry.m

@interface UIScrollView ( Geometry )

@property (assign, nonatomic) CGFloat contentInsetTop;
@property (assign, nonatomic) CGFloat contentInsetBottom;
@property (assign, nonatomic) CGFloat contentInsetLeft;
@property (assign, nonatomic) CGFloat contentInsetRight;

@property (assign, nonatomic) CGFloat contentOffsetX;
@property (assign, nonatomic) CGFloat contentOffsetY;

@property (assign, nonatomic) CGFloat contentSizeWidth;
@property (assign, nonatomic) CGFloat contentSizeHeight;

@end

#pragma mark - 

@interface UIScrollView ( Pages )

- (NSInteger)pages;
- (NSInteger)currentPage;
- (CGFloat)scrollPercent;

- (CGFloat)pagesY;
- (CGFloat)pagesX;
- (CGFloat)currentPageY;
- (CGFloat)currentPageX;

- (void)setPageY:(CGFloat)page;
- (void)setPageX:(CGFloat)page;
- (void)setPageY:(CGFloat)page animated:(BOOL)animated;
- (void)setPageX:(CGFloat)page animated:(BOOL)animated;

@end

#pragma mark - 

typedef NS_ENUM(NSInteger, UIScrollDirection) {
    UIScrollDirectionUp,
    UIScrollDirectionDown,
    UIScrollDirectionLeft,
    UIScrollDirectionRight,
    UIScrollDirectionWTF
};

@interface UIScrollView ( Addition )

@property(nonatomic) CGFloat contentWidth;
@property(nonatomic) CGFloat contentHeight;
@property(nonatomic) CGFloat contentOffsetX;
@property(nonatomic) CGFloat contentOffsetY;

- (CGPoint)topContentOffset;
- (CGPoint)bottomContentOffset;
- (CGPoint)leftContentOffset;
- (CGPoint)rightContentOffset;

- (UIScrollDirection)ScrollDirection;

- (BOOL)isScrolledToTop;
- (BOOL)isScrolledToBottom;
- (BOOL)isScrolledToLeft;
- (BOOL)isScrolledToRight;
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToLeftAnimated:(BOOL)animated;
- (void)scrollToRightAnimated:(BOOL)animated;

- (NSUInteger)verticalPageIndex;
- (NSUInteger)horizontalPageIndex;

- (void)scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;
- (void)scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

@end



