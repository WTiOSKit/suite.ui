//
//  UIImage+Utility.h
// fallen.ink
//
//  Created by 李杰 on 4/20/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

- (UIImage *)resizeImageToWidth:(CGFloat)resizedWidth height:(CGFloat)resizedHeight;

- (UIImage *)compressImageWithJPGCompression:(CGFloat)compressValue;    //return image as JPEG. May return nil if image has no CGImageRef or invalid bitmap format. compression is 0(most)..1(least)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)circleImageWithColor:(UIColor *)color andSize:(CGSize)size;

- (UIImage *)circleImage;

/**
 @knowledge
 
 * 模糊效果，是用截屏＋虚化实现的（1. 基于UIWindow 2. 基于 子 的UIViewController）
 
 * 还用于实现：侧滑反馈效果
 */
+ (UIImage *)imageOfView:(UIView *)view;

/**
 *  截屏
 *
 *  @param view
 *
 *  @return jpeg
 */
+ (UIImage *)screenshotForView:(UIView *)view;

@end
