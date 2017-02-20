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

#pragma mark - 备用

+ (UINib *)loadNib;
+ (UINib *)loadNibNamed:(NSString*)nibName;
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;

+ (instancetype)loadInstanceFromNib;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)jk_loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;


@end
