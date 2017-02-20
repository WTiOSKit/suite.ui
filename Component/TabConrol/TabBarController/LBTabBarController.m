//
//  LBTabBarController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBarController.h"
#import "BaseNavigationController.h"

@interface LBTabBarController ()<LBTabBarDelegate>

@end

@implementation LBTabBarController

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lbTabbar = [[LBTabBar alloc] init];
    [self setValue:_lbTabbar forKeyPath:@"tabBar"];
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)addChildViewController:(UIViewController *)viewController image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.title = title;
    viewController.tabBarItem.title = title;
//    viewController.navigationItem.title = title;
    viewController.tabBarItem.image = myImage;
    viewController.tabBarItem.selectedImage = mySelectedImage;

    [self addChildViewController:[[BaseNavigationController alloc] initWithRootViewController:viewController]];
//    [self addChildViewController:viewController];
}

@end
