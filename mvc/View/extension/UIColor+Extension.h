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
 *  @return
 */
- (UIImage *)imageSized:(CGSize)size;

@end
