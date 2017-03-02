//
//  BottomPopViewController.h
//  kata
//
//  Created by 王涛 on 17/3/2.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "BaseViewController.h"

extern NSMutableArray *g_bottomPopupVCArray;

@interface BottomPopViewController : BaseViewController

@property (nonatomic, assign) BOOL backgroundTapsDisabled;

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint; // 只有需要支持旋转的页面，需要访问该属性

// 下面三个方法可以选择性重写
- (CGFloat)preferredContentHeight;           // 默认为横屏200，竖屏300
- (void)showWithAnimated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;


@end
