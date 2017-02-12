//
//  UIImage+Extension.h
//  example
//
//  Created by fallen.ink on 9/24/15.
//  Copyright (c) 2015 fallen.ink. All rights reserved.
//

#import <UIKit/UIKit.h>

CGFloat DegreesToRadians(CGFloat degrees);

CGFloat RadiansToDegrees(CGFloat radians);

@interface UIImage (Extension)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;

- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

//-  ( void ) saveToAlbumWithMetadata: ( NSDictionary  * ) metadata
//                    customAlbumName: ( NSString  * ) customAlbumName
//                    completionBlock: ( void  ( ^ )( void )) completionBlock
//                       failureBlock: ( void  ( ^ )( NSError  * error )) failureBlock;

/**
 *  待添加
 *
 *  @param tintColor 待添加
 *
 *  @return 待添加
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

/**
 *
 *
 *  @return
 */
- (UIImage *)imageRepresentation;

@end

#pragma mark - UIImage (Blur)

// inspired by https://github.com/rnystrom/RNBlurModalView

@interface UIImage (Blur)

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end
