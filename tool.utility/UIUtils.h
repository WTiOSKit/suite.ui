//
//  UIUtils.h
// fallen.ink
//
//  Created by 李杰 on 3/1/15.
//
//

#import <Foundation/Foundation.h>

#pragma mark - Color

//=========================
//  颜色定义
//=========================

#import "UIColor+theme.h"

//=========================
// 其他，请看标注图
//=========================

#pragma mark - UIUtils

@interface UIUtils : NSObject

/**
 * 键盘高度
 */
+ (CGFloat)keyboardHeightFromNotificationUserInfo:(NSDictionary *)userInfo;

@end