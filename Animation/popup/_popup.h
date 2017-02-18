//
//  _popup.h
//  hairdresser
//
//  Created by fallen.ink on 6/7/16.
//
//

#import "_greats.h"
#import "_animation_protocol.h"

#define PopupAnimationDurationTimeInterval .3f
#define PopupAnimationDelayTimeInterval 0.f

#pragma mark - Animate popup

typedef NS_ENUM(NSUInteger, PopupAnimationType) {
    PopupAnimationType_Normal,     //正常弹出
    PopupAnimationType_Drop,       //下落, 默认效果
    PopupAnimationType_Default = PopupAnimationType_Normal,    //默认效果
};

#pragma mark -

@interface _Popup : NSObject

@singleton( _Popup )

// fixme: 暂时写在这里、暂时只支持组合一种

@property (nonatomic, weak) id<_AnimationDelegate> delegate;

@property (nonatomic, weak) id<_AnimationDataSource> dataSource;

// Where to draw views
@property (nonatomic, readonly) UIWindow *window;

// ----------------------------------
// Animate events
// ----------------------------------

@property (nonatomic, strong) Block dismissCompletionBlock;

+ (void)setDismissCompletionBlock:(Block)block;

/**
 *
 */
+ (void)dismiss;

// ----------------------------------
// 背景模糊
// ----------------------------------

+ (void)blur:(UIView *)contentView;
+ (void)blur:(UIView *)contentView withYOffset:(CGFloat)offset;

// ----------------------------------
// 背景透明＋暗影图层
// ----------------------------------

+ (void)transparent:(UIView *)contentView;
+ (void)transparent:(UIView *)contentView touchBackgroundHide:(BOOL)hide;
+ (void)transparent:(UIView *)contentView withColor:(UIColor *)transparentColor; // 注意 transparentColor 是透明度的色值

@end

#pragma mark - Blur



#pragma mark - Transparent

