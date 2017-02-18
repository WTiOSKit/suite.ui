//
//  UISearchBar+Extension.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UISearchBar+Extension.h"
#import "_greats.h"
#import "system/_system.h"

@implementation UISearchBar (Extension)

- (UITextField *)textField {
    // fallenink added
    Class uisearchbartextfield = classof(UISearchBarTextField);//NSClassFromString(@"UISearchBarTextField");
    
    UIView *v = self.subviews.firstObject;
    for (UITextField *s in v.subviews)
        if ([s isKindOfClass:uisearchbartextfield])
            return s;
    
    return nil;
}

@end
