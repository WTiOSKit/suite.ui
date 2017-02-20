//
//  UIImageView+Filter.h
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filter.h"

@interface UIImageView ( Filter )

/*
 Apply 'filter' to the image view's image.
 The filter application can be animated with custom duration
 and options.
 When the filter has finished being applied, the completionBlock is called.
 */
- (void)applyFilter:(CIFilter *)filter
  animationDuration:(NSTimeInterval)animationDuration
   animationOptions:(UIViewAnimationOptions)animationOptions
         completion:(void (^)(void))completionBlock;
- (void)applyFilterWithPreset:(ImageFilterPreset)preset
            animationDuration:(NSTimeInterval)animationDuration
             animationOptions:(UIViewAnimationOptions)animationOptions
                   completion:(void (^)(void))completionBlock;

/*
 Apply 'filter' to the image view's image.
 If 'animated' is YES, the filter application is animated
 with a cross-disolve effect for a duration of 0.3 seconds.
 When the filter has finished being applied, the completionBlock is called.
 */
- (void)applyFilter:(CIFilter *)filter
           animated:(BOOL)animated
         completion:(void (^)(void))completionBlock;
- (void)applyFilterWithPreset:(ImageFilterPreset)preset
                     animated:(BOOL)animated
                   completion:(void (^)(void))completionBlock;

/*
 Apply 'filter' to the image view's image without animation.
 When the filter has finished being applied, the completionBlock is called.
 */
- (void)applyFilter:(CIFilter *)filter
         completion:(void (^)(void))completionBlock;
- (void)applyFilterWithPreset:(ImageFilterPreset)preset
                   completion:(void (^)(void))completionBlock;

/*
 Apply 'filter' to the image view's image without animation.
 */
- (void)applyFilter:(CIFilter *)filter;
- (void)applyFilterWithPreset:(ImageFilterPreset)preset;

/*
 Remove any filters applied.  This bring back the original image.
 */
- (void)removeFilter;

@end

#pragma mark - 

@interface UIImageView ( Config )

+ (UIImageView *)imageViewWithImageNamed:(NSString *)name tintColor:(UIColor *)color;
+ (UIImageView *)imageViewWithImageNamed:(NSString *)name;
- (void)setMaskImage:(UIImage *)mask;

- (void)setImage:(UIImage *)image animated:(BOOL)animated;
- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration;

@end

#pragma mark - 

// inspired by https://github.com/Julioacarrettoni/UIImageView_FaceAwareFill
// debug mode by enable DEBUGGING_FACE_AWARE_FILL

@interface UIImageView (UIImageView_FaceAwareFill)

//Ask the image to perform an "Aspect Fill" but centering the image to the detected faces
//Not the simple center of the image
- (void)faceAwareFill;

- (void)faceAwareFillWithImage:(UIImage *)image;

@end

#pragma mark - WaterMark

@interface UIImageView ( WaterMark )

// 图片水印
- (void)setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;

// 文字水印
- (void)setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;

- (void)setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

@end

