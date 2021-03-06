
//
//  UIColor+theme.h
// fallen.ink
//
//  Created by 李杰 on 1/22/15.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (theme)

#pragma mark - 颜色规范
#pragma mark - 基准色

// ===============================================
// 全局用色：灰色系

// Use 000, just because one '0', is too short.
// ===============================================
+ (UIColor *)gray000Color;
+ (UIColor *)gray001Color;
+ (UIColor *)gray002Color;
+ (UIColor *)gray003Color;
+ (UIColor *)gray004Color;
+ (UIColor *)gray005Color;
+ (UIColor *)gray006Color;
+ (UIColor *)gray007Color;

+ (UIColor *)gray008Color;

// ===============================================
// 背景用色
// ===============================================

+ (UIColor *)bgGray000Color;
+ (UIColor *)bgGray001Color;
+ (UIColor *)bgGray002Color;
+ (UIColor *)bgGreenColor;

// ===============================================
// 分割线用色
// ===============================================

+ (UIColor *)lineGray000Color;
+ (UIColor *)lineGray001Color;

// ===============================================
// 文字用色
// 暂时不区分 端
// ===============================================

+ (UIColor *)fontGray001Color; // gray000 white font 1
+ (UIColor *)fontGray002Color; // gray005       font 2
+ (UIColor *)fontGray003Color; // gray006       font 3
+ (UIColor *)fontGray004Color; // gray007       font 4

+ (UIColor *)fontWhiteColor;
+ (UIColor *)fontBlackColor; // title
+ (UIColor *)fontGreenColor;    //              font 5
+ (UIColor *)fontOrangeColor;   //              font 6
+ (UIColor *)fontRedColor;

/**
 *  hair cut
 *
 *  @return UIColor *
 */
+ (UIColor *)fontDeepBlackColor;

// ===============================================
// 按钮特殊用色
// 暂时不区分 端
// ===============================================

+ (UIColor *)buttonRed001Color;

/**
 * 字体灰 1-4 颜色递减
 */
+ (UIColor *)fontGray_one_Color_deprecated; // gray007Color
+ (UIColor *)fontGray_two_Color_deprecated; // gray006
+ (UIColor *)fontGray_three_Color_deprecated; // gray005
+ (UIColor *)fontGray_four_Color_deprecated; // gray004

#pragma mark - 命名色

+ (UIColor *)themeColor;

/**
 *  主题色
 */
+ (UIColor *)themePinkColor;    // 系统、主题 粉红
+ (UIColor *)themePurpleColor;  // 系统、主题 紫色

+ (UIColor *)themeBlackColor;   // 主题 黑色

+ (UIColor *)themeGreenColor;   // 系统、主题 绿色
+ (UIColor *)themeOrangeColor;  // 系统、主题 橙色
+ (UIColor *)themeBlueColor;    // 系统、主题 蓝色
+ (UIColor *)themeBlueColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)themeYellowColor;  // 系统、主题 黄色
+ (UIColor *)themeRedColor;     // 系统、主题 红色

+ (UIColor *)themeGreenTwoColor;
+ (UIColor *)themeGreenColorWithAlpha:(CGFloat)alpha;

#pragma mark - 具体定义

+ (UIColor *)viewBackgroundColor;

@end

#define theme_color [UIColor themeColor]

#define font_gray_1 [UIColor fontGray001Color]
#define font_gray_2 [UIColor fontGray002Color]
#define font_gray_3 [UIColor fontGray003Color]
#define font_gray_4 [UIColor fontGray004Color]

#define line_gray [UIColor lineGray000Color]

#define background_gray [UIColor viewBackgroundColor]
