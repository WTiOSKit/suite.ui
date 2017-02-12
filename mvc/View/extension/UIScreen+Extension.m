//
//  UIScreen+Ex.m
// fallen.ink
//
//  Created by 李杰 on 2/20/15.
//
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

- (CGRect)currentBounds {
    return [self boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}


- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
    CGRect bounds = [self bounds];
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat buffer = bounds.size.width;
        
        bounds.size.width = bounds.size.height;
        bounds.size.height = buffer;
    }
    return bounds;
}

- (BOOL)isRetinaDisplay {
    static dispatch_once_t predicate;
    static BOOL answer;
    
    dispatch_once(&predicate, ^{
        answer = ([self respondsToSelector:@selector(scale)] && [self scale] == 2);
    });
    return answer;
}

+ (CGFloat)width {
    CGRect bounds = [[UIScreen mainScreen] currentBounds];
    
    return bounds.size.width;
}

+ (CGFloat)height {
    CGRect bounds = [[UIScreen mainScreen] currentBounds];
    return bounds.size.height;
}

@end
