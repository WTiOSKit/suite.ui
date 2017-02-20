//
//  CameraVC.m
//  TabbarCustom
//
//  Created by 江伟 吴 on 16/5/30.
//  Copyright © 2016年 Singer. All rights reserved.
//

#import "CameraVC.h"
//#import "PhotoManager.h"

#pragma mark -

@interface CameraVC () <FastttCameraDelegate>

@property (nonatomic, strong) FastttCamera *fastCamera;

// 拍照按钮
#define TakePhotoViewWidth      64.f
#define TakePhotoViewHeight     TakePhotoViewWidth
#define TakePhotoButtonWidth    56.f
#define TakePhotoButtonHeight   TakePhotoButtonWidth
@property (nonatomic, strong) UIView *takePhotoView;

@property (nonatomic, strong) UIButton *takePhotoButton;


@end

@implementation CameraVC

#pragma mark - Initialize

//- (instancetype)init {
//    if (self = [super init]) {
//        [self initCameraView];
//    }
//    
//    return self;
//}

- (void)initCameraView {
    _fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;

    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.view.frame;
}

- (void)initTakePhotoButton {
    self.takePhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TakePhotoViewWidth, 64.f)];
    self.takePhotoView.backgroundColor = [UIColor whiteColor];
    [self.takePhotoView circular:TakePhotoViewWidth/2];
    
    self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.takePhotoButton circular:TakePhotoButtonWidth/2];
    self.takePhotoButton.backgroundColor = [UIColor whiteColor];
    [self.takePhotoButton setBorderWidth:2.f withColor:[UIColor blackColor]];
    [self.takePhotoButton addTarget:self action:@selector(onTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.takePhotoView];
    [self.takePhotoView addSubview:self.takePhotoButton];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拍摄";
    
    [self initCameraView];
    
    [self initTakePhotoButton];
    
    [self applyViewConstraints];
}

- (void)applyViewConstraints {
    [self.takePhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TakePhotoViewWidth);
        make.height.mas_equalTo(TakePhotoViewHeight);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-PIXEL_8);
    }];
    
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TakePhotoButtonWidth);
        make.height.mas_equalTo(TakePhotoButtonHeight);
        make.centerX.equalTo(self.takePhotoView.mas_centerX);
        make.centerY.equalTo(self.takePhotoView.mas_centerY);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)navigationBarHiddenWhenAppear {
    return NO;
}

#pragma mark - IFTTTFastttCameraDelegate

- (void)cameraController:(FastttCamera *)cameraController
 didFinishCapturingImage:(FastttCapturedImage *)capturedImage {
    /**
     *  Here, capturedImage.fullImage contains the full-resolution captured
     *  image, while capturedImage.rotatedPreviewImage contains the full-resolution
     *  image with its rotation adjusted to match the orientation in which the
     *  image was captured.
     */
    
}

- (void)cameraController:(FastttCamera *)cameraController
didFinishScalingCapturedImage:(FastttCapturedImage *)capturedImage {
    /**
     *  Here, capturedImage.scaledImage contains the scaled-down version
     *  of the image.
     */
//    [[PhotoManager sharedInstance] savePhoto:capturedImage.scaledImage];
}

- (void)cameraController:(FastttCamera *)cameraController
didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {
    /**
     *  Here, capturedImage.fullImage and capturedImage.scaledImage have
     *  been rotated so that they have image orientations equal to
     *  UIImageOrientationUp. These images are ready for saving and uploading,
     *  as they should be rendered more consistently across different web
     *  services than images with non-standard orientations.
     */
}

#pragma mark - Action handler

- (void)onTakePhoto {
    [self.fastCamera takePicture];
}

@end
