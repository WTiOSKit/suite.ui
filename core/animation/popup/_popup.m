//
//  _popup.m
//  hairdresser
//
//  Created by fallen.ink on 6/7/16.
//
//

// fa: Use pop-1.0.7
#import "POP.h"

#import "_popup.h"
#import "_image.h"
#import "_ui_core.h"

static const NSUInteger CoverViewTag = 99999;

@interface _Popup () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) PopupAnimationType animationType;

@property (nonatomic, strong) UIScrollView *popupScrollView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) UIView *contentHolder;
@property (nonatomic, assign) CGFloat contentHolderYOffset;
@property (nonatomic, assign) CGAffineTransform initialPopupTransform; // contentHolder

@property (nonatomic, assign) BOOL needBlurBackgroundView;

@property (nonatomic, strong) UIViewController *popupVC;

@property (nonatomic, strong) UIColor *transparentColor;

#pragma mark - 把干扰的方法 现隐藏，乱的一逼

+ (void)showPopup:(UIView *)contentView touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType;
+ (void)setShowedPopupOriginY:(CGFloat)originY;
+ (void)resetShowedPopupOriginY;
+ (void)dismissPopup;

+ (void)showPopupVC:(UIViewController *)popupVC;
+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide;
+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType;

@end

@implementation _Popup

@def_singleton( _Popup)

+ (void)showPopup:(UIView *)contentView touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType{
    if (!contentView) return;
    
    _Popup *popup = [self sharedInstance];
    
    if (popup.popupScrollView) return;
    
    popup.animationType = animationType;
    
    UIWindow *window = popup.window;
    
    // 圆角
    contentView.layer.cornerRadius = 4.f;
    contentView.layer.masksToBounds = YES;
    
    // 内容图之下
    popup.contentHolder = [[UIView alloc] initWithFrame:contentView.frame];
    popup.contentHolder.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [popup.contentHolder addSubview:contentView];
    
    // fa:
    // 配合KeyboardManager，这里使用ScrollView，会被自动识别为 遮挡的位移调整。
    popup.popupScrollView = [[UIScrollView alloc] initWithFrame:window.rootViewController.view.bounds];
    popup.popupScrollView.contentSize = CGSizeMake(screen_width, screen_height);
    popup.popupScrollView.showsHorizontalScrollIndicator = NO;
    popup.popupScrollView.showsVerticalScrollIndicator = NO;
    popup.popupScrollView.bounces = NO;
    popup.popupScrollView.scrollEnabled = NO;
    
    if (popup.needBlurBackgroundView) {
        // 获取截屏图，并高斯模糊
        UIImage *image = [UIImage captureWithView:window.rootViewController.view];
        image = [image boxblurImageWithBlur:0.3];
        popup.blurView = [[UIImageView alloc] initWithImage:image];
        popup.blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        popup.blurView.alpha = 1;
        [popup.popupScrollView addSubview:popup.blurView];
    }
    
    // coverView
    popup.coverView = [[UIView alloc] initWithFrame:window.rootViewController.view.bounds];
    popup.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    popup.coverView.backgroundColor = popup.transparentColor;
    popup.coverView.tag = CoverViewTag;
    [popup.popupScrollView addSubview:popup.coverView];
    
    // 点触事件
    if (hide) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[self sharedInstance] action:@selector(handleCloseAction:)];
        tapGesture.delegate = popup;
        [popup.coverView addGestureRecognizer:tapGesture];
    }
    
    [popup.coverView addSubview:popup.contentHolder];
    popup.contentHolder.center = CGPointMake(popup.coverView.bounds.size.width/2,
                                             popup.coverView.bounds.size.height/2+popup.contentHolderYOffset);
    
    popup.popupScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [window.rootViewController.view addSubview:popup.popupScrollView];
    [popup.popupScrollView bringToFront];
    
    switch (popup.animationType) {TODO("用多态来做！")
        case PopupAnimationType_Drop:
            [popup animateInDrop];
            break;
        case PopupAnimationType_Normal:
            [popup animateInNormal];
            break;
        default:
            break;
    }
}


+ (void)dismissPopup {
    _Popup *popup = [self sharedInstance];
    
    if (popup.dismissCompletionBlock) {
        popup.dismissCompletionBlock();
        popup.dismissCompletionBlock = nil;
    }
    
    Block cleanBlock = ^{
        [popup.popupScrollView removeFromSuperview];
        popup.popupScrollView = nil;
        popup.blurView = nil;
        popup.contentHolder = nil;
        popup.coverView = nil;
        if (popup.popupVC) {
            popup.popupVC = nil;
        }
    };
    
    switch (popup.animationType) {
        case PopupAnimationType_Drop:
            [popup animateOutDropWithCompletionBlock:cleanBlock];
            break;
        case PopupAnimationType_Normal:
            [popup animateOutNormalWithCompletionBlock:cleanBlock];
            break;
        default:
            break;
    }
}

+ (void)setShowedPopupOriginY:(CGFloat)originY {
    _Popup *popup = [self sharedInstance];
    if (popup.contentHolder) {
        popup.contentHolder.y = originY;
    }
}

+ (void)resetShowedPopupOriginY {
    _Popup *popup = [self sharedInstance];
    if (popup.contentHolder && popup.coverView) {
        popup.contentHolder.center = CGPointMake(popup.coverView.bounds.size.width/2,
                                                popup.coverView.bounds.size.height/2);
    }
}

+ (void)setDismissCompletionBlock:(Block)block{
    _Popup *popup = [self sharedInstance];
    popup.dismissCompletionBlock = block;
}

+ (void)showPopupVC:(UIViewController *)popupVC {
    [self sharedInstance].popupVC = popupVC;
    [self showPopup:popupVC.view touchBackgroundHide:YES animationType:PopupAnimationType_Default];
}

+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide {
    [self sharedInstance].popupVC = popupVC;
    [self showPopup:popupVC.view touchBackgroundHide:hide animationType:PopupAnimationType_Default];
}

+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType {
    [self sharedInstance].popupVC = popupVC;
    [self showPopup:popupVC.view touchBackgroundHide:hide animationType:animationType];
}

- (UIWindow *)window {
    return [[UIApplication sharedApplication] keyWindow];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag != CoverViewTag) {
        return NO;
    }
    return YES;
}

#pragma mark - 旧版pop动画

- (void)animateInNormal {
    self.coverView.alpha   = 0;
    self.blurView.alpha    = 0;
    
    self.contentHolder.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.initialPopupTransform = self.contentHolder.transform;
    
    [UIView animateWithDuration:PopupAnimationDurationTimeInterval
                     animations:^{
                         self.coverView.alpha = 1;
                         self.blurView.alpha = 1;
                         
                         self.contentHolder.transform = CGAffineTransformIdentity;
                     }];
}

- (void)animateOutNormalWithCompletionBlock:(Block)completion {
    [UIView animateWithDuration:PopupAnimationDurationTimeInterval
                     animations:^{
                         self.coverView.alpha = 0;
                         self.contentHolder.transform = self.initialPopupTransform;
                         self.blurView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         completion();
                     }];
}

#pragma mark - 新版pop动画

#define kPOPLayerPositionChanged    @"POPLayerPositionChanged"

- (void)animateInDrop {
    // 设置主体初始位置
    self.contentHolder.y    = -self.contentHolder.height;
    
    // 设置动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(screen_width/2, screen_height/2)];
    //弹性值
    springAnimation.springBounciness = 10.0;
    //弹性速度
    springAnimation.springSpeed = 20.0;
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        //
    };
    
    [self.contentHolder pop_addAnimation:springAnimation forKey:kPOPLayerPositionChanged];
}

- (void)animateOutDropWithCompletionBlock:(Block)completion {
    // 设置动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(screen_width/2, -self.contentHolder.height)];
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        completion();
    };
    
    [self.contentHolder pop_addAnimation:springAnimation forKey:kPOPLayerPositionChanged];
}

- (void)handleCloseAction:(id)sender {
    [self.class dismissPopup];
}

#pragma mark - public

+ (void)dismiss {
    [self dismissPopup];
}

#pragma mark - 背景模糊 方法

+ (void)blur:(UIView *)contentView {
    [self sharedInstance].needBlurBackgroundView = YES;
    
    [self showPopup:contentView touchBackgroundHide:YES animationType:PopupAnimationType_Default];
}

+ (void)blur:(UIView *)contentView withYOffset:(CGFloat)offset {
    [self sharedInstance].contentHolderYOffset = offset;
    
    [self blur:contentView];
}

#pragma mark - 背景透明 方法

+ (void)transparent:(UIView *)contentView {
    [self transparent:contentView withColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5]];
}

+ (void)transparent:(UIView *)contentView touchBackgroundHide:(BOOL)hide {
    [self sharedInstance].needBlurBackgroundView = NO;
    [self sharedInstance].transparentColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    
    [self showPopup:contentView touchBackgroundHide:hide animationType:PopupAnimationType_Default];
}

+ (void)transparent:(UIView *)contentView withColor:(UIColor *)transparentColor {
    [self sharedInstance].needBlurBackgroundView = NO;
    [self sharedInstance].transparentColor = transparentColor;
    
    [self showPopup:contentView touchBackgroundHide:YES animationType:PopupAnimationType_Default];
}

@end
