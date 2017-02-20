//
//  UIViewController+Tracking.m
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import "SGGuideDispatcher.h"
#import "_aspects.h"
#import "_notification.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

+ (void)load {
//    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(viewWillAppear:)), class_getInstanceMethod([self class], @selector(track_viewWillAppear:)));
    
    [self aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSNumber *anmated){
        [self postNotification:SGGuideTrigNotification withObject:@{@"viewController":self}];
    } error:nil];
}

//- (void)track_viewWillAppear:(BOOL)animated {
//    [self track_viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:SGGuideTrigNotification object:@{@"viewController":self}];
//}

@end
