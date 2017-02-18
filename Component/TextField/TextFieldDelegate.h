//
//  TextFieldDelegate.h
//
//  Created by fallen.ink on 3/30/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "_precompile.h"

@interface TextFieldDelegate : NSObject <UITextFieldDelegate>

/**
 *
 */
- (instancetype)initWithTextField:(UITextField *)textField;

/**
 *  最大数目
 */
@property (assign, nonatomic) NSInteger max;

/**
 *  输入框事件
 */
@property (strong, nonatomic) ObjectBlock textFieldChanged;

@end
