//
//  UIView+.m
//  XFAnimations
//
//  Created by fallen.ink on 11/24/15.
//  Copyright © 2015 fallen.ink. All rights reserved.
//

#import "UIView+.h"
#import "_pragma_push.h"

@implementation UIView (ConstraintsControl)

- (void)applyConstraints {
    // Do nothing...
}

@end

@implementation UIView (Template)

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

@end

@implementation UIView (Nib)

- (instancetype) _initWithNib {
    return [self.class _loadViewWithNibNamed:NSStringFromClass([self class])];
}

+ (instancetype)_loadViewWithNibNamed:(NSString *)name {
    return [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
}

@end

#import "_pragma_pop.h"
