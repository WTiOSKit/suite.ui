//
//  UIColor+Extension.h
//  hairdresser
//
//  Created by fallen.ink on 6/8/16.
//
//

#import <UIKit/UIKit.h>

@interface UIColor ( Extension )

// Color builders
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

// Extract color from Image
+ (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;

/**
 *  根据大小声称image
 *
 *  @param size 大小
 *
 *  @return UIImage *
 */
- (UIImage *)imageSized:(CGSize)size;

@end

#pragma mark - 

@interface UIColor ( Gradient )
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

@end


