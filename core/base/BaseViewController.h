//
//  BaseViewController.h
// fallen.ink
//
//  Created by 李杰 on 4/27/15.
//
//

#import <UIKit/UIKit.h>
#import "_precompile.h"

// ----------------------------------
// AOP 拦截器

// 销毁的后处理
// 1. 移除所有通知
// 2. 移除KVO

// ViewDidLoad统一样式处理
// 1. 背景色
// ----------------------------------

// ----------------------------------
// class declaration
// ----------------------------------

#pragma mark -

/**
 * Implemented by sub-classes of BaseViewController.
 */
@protocol ReactiveViewProtocol <NSObject>

@optional

- (void)bindViewModel;

- (void)bindViewModel:(id)vm;

@end

#pragma mark -

@interface BaseViewController : UIViewController <ReactiveViewProtocol>

@property (nonatomic, assign) NSInteger serviceState;

/**
 @knowledge
 
 *  在UIViewController中收起键盘，除了调用相应控件的resignFirstResponder方法外，还有另外三种：
 
 *  1. 重载UIVIewController中的touchesBegin方法，然后在里面执行[self.view endEditing:YES]
 
 *  2. 直接执行[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; 用于获取当前UIViewController比较困难的时候
 
 *  直接执行[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
 */
@property (nonatomic, assign) BOOL hideKeyboardWhenEndEditing;

/**
 *  用户自定制状态栏的风格，默认为 UIStatusBarStyleLightContent
 */
@property (nonatomic, assign) UIStatusBarStyle userPreferredStatusBarStyle;

/**
 *  状态栏是否隐藏
 */
@property (nonatomic, assign) BOOL statusBarHidden;

#pragma mark - Play with view model: overrided if needed

- (instancetype)initWithViewModel:(id)viewModel;

#pragma mark - Virtual method: Need to be overrided

/**
 *  Make constraints by code! Masonry is suggest.
 
 *  Call it at viewDidLoad 's end.
 */
- (void)applyViewConstraints;

/**
 *  Update Xib's constraints when needed.
 
 *  Call it where needed.
 */
- (void)updateVCviewsConstraints;

/**
 *  Just override api's method here.
 */
- (void)updateViewConstraints;

#pragma mark - NavigationBar style

// 导航栏，默认，不隐藏
// 警告：以下两个方法，要么都覆盖，要么都不覆盖
- (BOOL)navigationBarHiddenWhenAppear;
- (BOOL)navigationBarHiddenWhenDisappear;

// 导航栏，左侧返回按钮，默认，不隐藏
- (BOOL)navigationBarLeftButtonHiddenWhenAppear;

// 修改当前导航栏背景色
- (UIColor *)preferNavBarBackgroundColor;

// 修改当前导航栏标题、左右按钮Normal状态标题颜色
- (UIColor *)preferNavBarNormalTitleColor;

// 修改左右按钮Highlighted标题颜色
- (UIColor *)preferNavBarHighlightedTitleColor;

#pragma mark - Override methods

- (void)onBack; // fallenink: 以后的形式都是，on＋动作

#pragma mark - Utility

- (BOOL)isVisibleEx;

/**
 *  下面两个方法不是很准确，且互斥的！单层navigation＋rootViewController，为isPresent
 *
 *  @return 
 */
- (BOOL)isPresent;
- (BOOL)isPush;

//显示系统自带的菊花
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

#pragma mark - Use aspect hook

- (void)aspect_doLoad;
- (void)aspect_doAppear;
- (void)aspect_doDealloc;

@end

#pragma mark - Config

@interface BaseViewController ( Config )

/**
 *  Config back button image
 */
+ (void)setBackButtonImageName:(NSString *)imageName;

+ (NSString *)backButtonImageName;

/**
 *  Config preferred status bar style
 */
+ (void)setUserPreferredStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end

#pragma mark - 

@interface BaseViewController ( Handler )

@property (nonatomic, strong, readonly) ErrorBlock failureHandler;

@end

#pragma mark - Navigation control

@interface BaseViewController ( NavigationControl )

- (void)pushVC:(UIViewController *)vc animate:(BOOL)animate;

- (void)pushVC:(UIViewController *)vc;

- (void)popVCAnimate:(BOOL)animate;

- (void)popVC;

- (void)popToVC:(UIViewController *)vc animate:(BOOL)animate;

- (void)popToVC:(UIViewController *)vc;

- (void)popToRootAnimate:(BOOL)animate;

- (void)popToRoot;

@end

