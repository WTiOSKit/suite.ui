//
//  UIView+.h
//  XFAnimations
//
//  Created by fallen.ink on 11/24/15.
//  Copyright © 2015 fallen.ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConstraintsControl)

/**
 *  Make constraints by code! Masonry is suggest.
 
 *  Call it at subViews created.
 */
- (void)applyConstraints;

@end

@interface UIView (Template)

+ (NSString *)identifier;
+ (UINib *)nib;

@end

@interface UIView (Nib)

- (instancetype) _initWithNib;

+ (instancetype) _loadViewWithNibNamed:(NSString *)name;

@end