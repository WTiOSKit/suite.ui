//
//  LCTabBarMiddleExtendController.m
//  hairdresser
//
//  Created by fallen.ink on 7/24/16.
//
//

#import "LCTabBarMiddleExtendController.h"
#import "LCTabBar.h"
#import "LCTabBarItem.h"

static LCTabBarController *storedTabBarController;

@interface LCTabBarMiddleExtendController ()

/**
 *  如果是偶数个选项，则LCTabBarMiddleExtendController 和 LCTabBarController 一样。
 
 *  如果是奇数个选项，则中间那个，被突出。则 isMiddleExtendValid 为 YES， 否则 NO。
 */
@property (nonatomic, assign) BOOL isMiddleExtendValid;


@property (nonatomic, assign) NSUInteger extendButtonIndex;


@end

@implementation LCTabBarMiddleExtendController

@def_singleton( LCTabBarMiddleExtendController )

#pragma mark - Initialize

- (instancetype)init {
    if (self  = [super init]) {
        storedTabBarController = self;
        
        self.extendButtonIndex = -1;
    }
    
    return self;
}

- (void)reload {
    [self.lcTabBar.tabBarItems removeAllObjects];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    self.lcTabBar.badgeTitleFont         = self.badgeTitleFont;
    self.lcTabBar.itemTitleFont          = self.itemTitleFont;
    self.lcTabBar.itemImageRatio         = self.itemImageRatio;
    self.lcTabBar.itemTitleColor         = self.itemTitleColor;
    self.lcTabBar.selectedItemTitleColor = self.selectedItemTitleColor;
    self.lcTabBar.backgroundColor        = self.tabBarBackgroundColor;
    
    self.lcTabBar.tabBarItemCount = viewControllers.count;
    
    // 如果count为奇数
    if (viewControllers.count % 2) {
        self.extendButtonIndex = (viewControllers.count-1) / 2; // 从 0 开始
    }
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *VC = (UIViewController *)obj;
        
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:VC];
        
        if (idx == self.extendButtonIndex) {
            [self.lcTabBar addTabBarItem:VC.tabBarItem withWrapperTabBarItem:[NonTitleTabBarItem new]];
        } else {
            [self.lcTabBar addTabBarItem:VC.tabBarItem withWrapperTabBarItem:[LCTabBarItem new]];
        }
    }];
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(LCTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    if (to == self.extendButtonIndex) {
        if (is_method_implemented(self.extendDelegate, onMiddleExtendButtonSelected)) {
            [self.extendDelegate onMiddleExtendButtonSelected];
        }
    } else {
        if (is_method_implemented(self.extendDelegate, LCTTabBarController:didSelectedItemFrom:to:)) {
            [self.extendDelegate LCTTabBarController:self didSelectedItemFrom:from to:to];
        }
        
        self.selectedIndex = to;
    }
}

@end

#pragma mark - Hack

@implementation UITabBar ( Hack )

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    LCTabBar *tabBar = storedTabBarController.lcTabBar;
    BOOL isTabBarControllerVisible = !tabBar.hidden && !storedTabBarController.tabBar.hidden;
    
    //    LOG(@"lct tabbar hide = %@, system tabbar hide = %@", @(tabBar.hidden), @(storedTabBarController.tabBar.hidden));
    
    // TabBar 是否在最前
    if (!view && tabBar && isTabBarControllerVisible) {
        
        // find circle button
        LCTabBarItem *circleItem = nil;
        NSArray<LCTabBarItem *> *items = tabBar.tabBarItems;
        for (LCTabBarItem *item in items) {
            if ([item isKindOfClass:CircleTabBarItem.class]) {
                circleItem = item;
                break;
            }
        }
        
        if (circleItem) {
            CGPoint toPoint = [circleItem convertPoint:point fromView:self];
            
            if (circleItem && CGRectContainsPoint(circleItem.bounds, toPoint)) {
                // 当前TabBar已经不在通用也没必要
                
                if ([tabBar.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
                    [tabBar.delegate tabBar:tabBar
                        didSelectedItemFrom:tabBar.selectedItem.tabBarItem.tag
                                         to:circleItem.tag];
                }
            }
        }
    }
    
    return view;
}

@end
