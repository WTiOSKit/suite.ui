//
//  ImagePickerController.h
//  QQing
//
//  Created by fallen.ink on 4/5/16.
//
//

#import <UIKit/UIKit.h>

// 相册单选
@interface ImagePickerController : UIImagePickerController

/**
 *  Default : UIStatusBarStyleLightContent
 */
@property (nonatomic, assign) UIStatusBarStyle customPreferStatusBarStyle;
@property (nonatomic, assign) BOOL enabledMirrorFrontCamera;
@end

#pragma mark - 

@interface ImagePickerController ( Extension )

/**
 *  自带选项：“相机”“相册”“取消”
 *
 *  @param viewController 宿主 视图控制器
 *  @param settingBlock   设置delegate等等
 */
+ (void)showInViewController:(UIViewController *)viewController withSettingBlock:(void (^)(ImagePickerController *controller))settingBlock;

@end
