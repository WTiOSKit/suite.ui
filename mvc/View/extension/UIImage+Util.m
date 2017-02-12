//
//  UIImage+Util.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UIImage+Util.h"

#import "_pragma_push.h"

@import AssetsLibrary;

NS_INLINE CGRect CGRectScaleRect(CGRect r, CGFloat scale) {
    return CGRectMake(r.origin.x * scale,
                      r.origin.y * scale,
                      r.size.width * scale,
                      r.size.height * scale);
}

NS_INLINE CGRect CGRectInsetAll(CGRect r, UIEdgeInsets i) {
    return CGRectMake(r.origin.x + i.left,
                      r.origin.y + i.top,
                      r.size.width - i.right,
                      r.size.height - i.bottom);
}

NS_INLINE CGRect CGRectInsetLeft(CGRect r, CGFloat dx, CGFloat dy) {
    return CGRectMake(r.origin.x + dx,
                      r.origin.y + dy,
                      r.size.width - dx,
                      r.size.height - dy);
}

NS_INLINE CGRect CGRectInsetRight(CGRect r, CGFloat dx, CGFloat dy) {
    return CGRectMake(r.origin.x,
                      r.origin.y,
                      r.size.width - dx,
                      r.size.height - dy);
}

@implementation UIImage (Util)

// It's important to pass in 0.0f to this function to draw the image to the scale of the screen
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)imageByDrawingIcon:(UIImage *)icon onTopOf:(UIImage *)background iconTint:(UIColor *)iconTint bgColor:(UIColor *)bgColor {
    
    icon = [icon tintedImageWithColor:iconTint];
    background = [background tintedImageWithColor:bgColor];
    
    UIGraphicsBeginImageContextWithOptions(background.size, NO, 0.0f);
    CGRect mainBounds = CGRectMake(0, 0, background.size.width, background.size.height);
    
    CGFloat iconX = (mainBounds.size.width - icon.size.width)/2;
    CGFloat iconY = (mainBounds.size.height - icon.size.height)/2;
    CGRect iconBounds = CGRectMake(iconX, iconY, icon.size.width, icon.size.height);
    
    [background drawInRect:mainBounds];
    [icon drawInRect:iconBounds];
    
    UIImage *stackedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return stackedImage;
}

- (UIImage *)paddedImage:(UIEdgeInsets)insets {
    CGSize newSize = self.size;
    newSize.height += insets.top + insets.bottom;
    newSize.width  += insets.left + insets.right;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    CGPoint origin = CGPointMake(insets.left, insets.top);
    [self drawAtPoint:origin];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)paddedToSize:(CGSize)size {
    if (size.width < self.size.width || size.height < self.size.height)
        return self;
    
    CGFloat dw = size.width - self.size.width;
    CGFloat dh = size.height - self.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(dh/2.f, dw/2.f, dh/2.f, dw/2.f);
    return [self paddedImage:insets];
}

- (UIImage *)croppedToRect:(CGRect)rect {
    rect            = CGRectScaleRect(rect, self.scale);
    CGImageRef ref  = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:ref scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(ref);
    return result;
}

- (void)saveToLibrary:(void (^)(NSError *error))completion {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:self.CGImage orientation:(ALAssetOrientation)self.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (completion) completion(error);
    }];
}

@end

#import "_pragma_pop.h"
