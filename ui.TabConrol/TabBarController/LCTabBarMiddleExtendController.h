//
//  LCTabBarMiddleExtendController.h
//  hairdresser
//
//  Created by fallen.ink on 7/24/16.
//
//

#import "LCTabBarController.h"

@protocol LCTabBarMiddleExtendControllerDelegate;

/**
 *  中部按钮方法，且不参与 tabBar 切换，需要用其他呈现方式，如：present
 */
@interface LCTabBarMiddleExtendController : LCTabBarController

@singleton( LCTabBarMiddleExtendController )

- (void)reload;

@property (nonatomic, weak) id<LCTabBarMiddleExtendControllerDelegate> extendDelegate;

@end

#pragma mark -

@protocol LCTabBarMiddleExtendControllerDelegate <LCTabBarControllerDelegate>

@required

- (void)onMiddleExtendButtonSelected;

@end

#pragma mark - Hack

@interface UITabBar ( Hack )

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end