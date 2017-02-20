//
//  _Router+hybrid.m
//  kata
//
//  Created by fallen.ink on 07/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_Router+hybrid.h"
#import "BaseWebViewController.h"

@implementation NSObject (hybrid)

- (void)router_openHtml:(NSString *)url {
    [self router_openHtml:url extraParams:nil];
}

- (void)router_openHtml:(NSString *)url extraParams:(NSDictionary *)params {
    {
        BaseWebViewController *viewController = [[BaseWebViewController alloc] initWithUrl:url withParam:params];
        [self router_push:viewController];
    }
    
}

@end
