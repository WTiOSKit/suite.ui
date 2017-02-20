//
//  ImagePickerController.m
//  QQing
//
//  Created by fallen.ink on 4/5/16.
//
//

#import "ImagePickerController.h"
#import "_greats.h"
#import "_tools.h"
#import "_ui_core.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

static NSString *AVCaptureDeviceDidStartRunningNotification = @"AVCaptureDeviceDidStartRunningNotification";

@interface ImagePickerController ()

@end

@implementation ImagePickerController

- (instancetype)init {
    if (self = [super init]) {
        self.customPreferStatusBarStyle = UIStatusBarStyleLightContent;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.customPreferStatusBarStyle;
}

- (void)dealloc {
    [self unobserveAllNotifications];
}

#pragma mark - Notification handler

- (void)handleNotification:(NSNotification *)notification {
    if ([notification is:AVCaptureDeviceDidStartRunningNotification]) {
        if(self.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
            self.cameraViewTransform = CGAffineTransformIdentity;
            self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, -1, 1);
        } else {
            self.cameraViewTransform = CGAffineTransformIdentity;
        }
    }
}

#pragma mark - Getter & Setter

- (void)setEnabledMirrorFrontCamera:(BOOL)enabledMirrorFrontCamera {
    _enabledMirrorFrontCamera = enabledMirrorFrontCamera;
    
    if (enabledMirrorFrontCamera) {
        [self observeNotification:AVCaptureDeviceDidStartRunningNotification];
    } else {
        [self unobserveNotification:AVCaptureDeviceDidStartRunningNotification];
    }
}

@end

#pragma mark -

@implementation ImagePickerController ( Extension )

+ (void)showWithSourceType:(NSUInteger)sourceType inViewController:(UIViewController *)viewController withSettingBlock:(void (^)(ImagePickerController *))settingBlock {
    ImagePickerController *imagePickerController = [[ImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    if (settingBlock) {
        settingBlock(imagePickerController);
    }
    
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

+ (void)showInViewController:(UIViewController *)viewController withSettingBlock:(void (^)(ImagePickerController *))settingBlock {
    UIActionSheet *actionSheet = [UIActionSheet new];
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            return;
        }
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            [self showAlertView:@"提示" message:@"您可以去设置里打开相机，以便获得更好的体验和服务" cancelButtonName:@"确定"];
            
            return;
        }
        
        [self showWithSourceType:sourceType inViewController:viewController withSettingBlock:settingBlock];
    }];
    [actionSheet bk_addButtonWithTitle:@"相册" handler:^{
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            return;
        }
        
        if (IOS9_OR_LATER) {
            PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
            if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
                [self showAlertView:@"提示" message:@"您可以去设置里打开相册，以便获得更好的体验和服务" cancelButtonName:@"确定"];
                return;
            } else if (authStatus == PHAuthorizationStatusNotDetermined) {
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self showWithSourceType:sourceType inViewController:viewController withSettingBlock:settingBlock];
                    }
                }];
                
                return;
            }
        } else {
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
                [self showAlertView:@"提示" message:@"您可以去设置里打开相册，以便获得更好的体验和服务" cancelButtonName:@"确定"];
                return;
            } else if (authStatus == ALAuthorizationStatusNotDetermined) {
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    if (*stop) {
                        
                        [self showWithSourceType:sourceType inViewController:viewController withSettingBlock:settingBlock];

                    }
                    
                    *stop = TRUE;//不能省略
                    
                } failureBlock:^(NSError *error) {
                    LOG(@"failureBlock");
                }];
                
                return;
            }
        }
        
        // Authorized
        
        [self showWithSourceType:sourceType inViewController:viewController withSettingBlock:settingBlock];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:viewController.view];
}

@end
