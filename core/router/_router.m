//
//  _router.m
//  hairdresser
//
//  Created by fallen.ink on 6/1/16.
//
//

#import "_router.h"
#import "UINavigationController+Extension.h"

@interface _Router () {
    @public
    UPRouter *route;
}

@end

@implementation _Router

@def_singleton( _Router )

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        route = [Routable sharedRouter];
    }
    return self;
}

#pragma mark - Interface

- (void)setNavigationController:(UINavigationController *)controller {
    [route setNavigationController:controller];
}

- (void)pop {
    [route pop];
}

- (void)popViewControllerFromRouterAnimated:(BOOL)animated {
    [route popViewControllerFromRouterAnimated:animated];
}

- (void)pop:(BOOL)animated {
    [route pop:animated];
}

- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback {
    [route map:format toCallback:callback];
}

- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback withOptions:(UPRouterOptions *)options {
    [route map:format toCallback:callback withOptions:options];
}

- (void)map:(NSString *)format toController:(Class)controllerClass {
    [route map:format toController:controllerClass];
}

- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(UPRouterOptions *)options {
    [route map:format toController:controllerClass withOptions:options];
}

///-------------------------------
/// @name Opening URLs
///-------------------------------

- (void)openExternal:(NSString *)url {
    [route openExternal:url];
}

- (void)open:(NSString *)url {
    [route open:url];
}

- (void)open:(NSString *)url animated:(BOOL)animated {
    [route open:url animated:animated];
}

- (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams {
    [route open:url animated:animated extraParams:extraParams];
}

- (NSDictionary*)paramsOfUrl:(NSString*)url {
    return [route paramsOfUrl:url];
}

@end

#pragma mark - Router convenionce

@implementation NSObject ( ViewRouter )

- (void)router_setNavigationController:(UINavigationController *)controller {
    [[_Router sharedInstance] setNavigationController:controller];
}

- (void)router_register:(Class)c {
    [[_Router sharedInstance] map:classnameof_Class(c) toController:c];
}

- (void)router_open:(NSString *)url {
    [self router_open:url animate:YES extraParams:nil];
}

- (void)router_open:(NSString *)url animate:(BOOL)animate extraParams:(NSDictionary *)params {
    [[_Router sharedInstance] open:url animated:YES extraParams:params];
}

- (void)router_openExternal:(NSString *)url {
    [[_Router sharedInstance] openExternal:url];
}

- (void)router_push:(UIViewController *)controller {
    [[_Router sharedInstance]->route.navigationController pushViewController:controller animated:YES];
}

- (void)router_pop {
    [[_Router sharedInstance] pop];
}

- (void)router_popTo:(UIViewController *)controller {
    [[_Router sharedInstance]->route.navigationController popToViewController:controller animated:YES];
}

- (void)router_popTos:(NSString *)url {
    UIViewController *c = [[_Router sharedInstance]->route.navigationController viewControllerForClass:classify(url)];
    if (c) {
        [self router_popTo:c];
    }
}

#pragma mark - react native

- (void)rn_register:(Class)c {
    [[_Router sharedInstance] map:@"react-native default" toController:c];
}

- (void)rn_openWithExtraParams:(NSDictionary *)params {
    [[_Router sharedInstance] open:@"react-native default" animated:YES extraParams:params];
}

@end
