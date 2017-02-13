//
//  LSYLoadingHUD.h
//  LoadingHUD
//
//  Created by Labanotation on 16/5/6.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^reload)(void);
typedef NS_ENUM(NSUInteger,OKWLoadState){
    OKWLoading,
    OKWLoadEnd,
    OKWLoadError
};

@interface LSYLoadingHUD : UIViewController
@property (nonatomic,strong) UIImage *failureImage;   //加载失败视图，没有设置的话使用默认视图
@property (nonatomic,strong) UIView *loadingView;    //加载动画,如果没有设置的话使用默认动画
@property (nonatomic, strong) UIColor *backgroundColor; // Will set to self.view
@property (nonatomic, assign) CGFloat topSpacesRatio; // 以view的上边缘，计算loading 的中心位置

#pragma mark -

- (void)showHUDText:(NSString *)text inViewController:(UIViewController *)vc;
- (void)hiddenHUDViewController:(UIViewController *)vc;
- (void)showFailHUDText:(NSString *)text inViewController:(UIViewController *)vc reload:(reload)reload;

#pragma mark Class Method

+ (void)hiddenAllHUD:(UIViewController *)vc;
+ (void)failHUDText:(NSString *)text inViewController:(UIViewController *)vc reload:(reload)reload;

@end
