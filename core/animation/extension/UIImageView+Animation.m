//
//  UIImageView+Addition.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView ( Animation )

+ (id)imageViewWithImageNamed:(NSString*)imageName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (id)imageViewWithStretchableImage:(NSString*)imageName Frame:(CGRect)frame {
    UIImage *image =[UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return imageView;
}

- (void)setImageWithStretchableImage:(NSString*)imageName {
    UIImage *image =[UIImage imageNamed:imageName];
    self.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

+ (id)imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration; {
    if (imageArray && [imageArray count] <= 0) {
        return nil;
    }
    
    UIImageView *imageView = [UIImageView imageViewWithImageNamed:[imageArray objectAtIndex:0]];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < imageArray.count; i++) {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [images addObject:image];
    }
    [imageView setImage:[images objectAtIndex:0]];
    [imageView setAnimationImages:images];
    [imageView setAnimationDuration:duration];
    [imageView setAnimationRepeatCount:0];
    
    return imageView;
}

@end
