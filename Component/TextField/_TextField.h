//
//  _TextField.h
//  consumer
//
//  Created by fallen on 16/9/1.
//
//

#import <UIKit/UIKit.h>
#import "TextFieldDelegate.h"

@interface _TextField : UITextField

@property (nonatomic, assign) BOOL canCopyContent; // default: YES

@property (nonatomic, strong) UIColor *focusedBackgroundColor;
@property (nonatomic, strong) UIColor *focusedTextColor;

@end
