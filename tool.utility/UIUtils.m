//
//  UIUtils.m
// fallen.ink
//
//  Created by 李杰 on 3/1/15.
//
//

#import "UIUtils.h"

@implementation UIUtils

+ (CGFloat)keyboardHeightFromNotificationUserInfo:(NSDictionary *)userInfo {
    CGFloat currentKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
#ifdef __IPHONE_8_0
    //以下代码主要是为了让iOS8SDK＋iOS8之后的设备得到的键盘尺寸与iOS8SDK之前的计算方法保持一致
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
        && UIDeviceOrientationIsLandscape((UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation)) {
        currentKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
    }
#endif
    
    return currentKeyboardHeight;
}

@end
