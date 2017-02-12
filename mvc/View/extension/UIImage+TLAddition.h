//
//  UIImage+TLAddition.h
//  BaiduTuanMerchant
//
//  Created by wujiangwei on 15/5/30.
//  Copyright (c) 2015年 Kevin.Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BTMAddition)

+(UIImage *)imageFromText:(NSArray*)arrContent withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor withBgImage:(UIImage *)bgImage withBgColor:(UIColor *)bgColor;

+(UIImage *)imageFromScrollView:(UIScrollView *)scrollView;

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+(UIImage *)getVideoSubnailImage:(NSString *)videoURL timeWithSecond:(float)secondTime;

-(UIImage *)reducePicQualityIfNeeded:(NSData **)imageData;

- (UIImage *)imageScaledToSize:(CGSize)size;

- (UIImage *)imageScaledToFitSize:(CGSize)size;

- (UIImage *)fixOrientation;

@end
