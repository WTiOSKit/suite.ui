//
//  _router.h
//  hairdresser
//
//  Created by fallen.ink on 6/1/16.
//
//

#import "_greats.h"
#import "BaseViewController.h"
#import "Routable.h"

#pragma mark -

@interface _Router : NSObject

/**
 *  当前没有模块跳转需求，所以用单例，统管页面跳转方式
 */
@singleton( _Router )

/**
 *  Add root navigation controller
 *
 *  @param controller navigation controller
 */
- (void)setNavigationController:(UINavigationController *)controller;

/**
 Pop to the last `UIViewController` mapped with the router; this will either dismiss the presented `UIViewController` (i.e. modal) or pop the top view controller in the navigationController. The transition is animated.
 */
- (void)pop;

/**
 Pop to the last `UIViewController` mapped with the router; this will either dismiss the presented `UIViewController` (i.e. modal) or pop the top view controller in the navigationController.
 @param animated Whether or not the transition is animated;
 */

- (void)popViewControllerFromRouterAnimated:(BOOL)animated;
/**
 Pop to the last `UIViewController` mapped with the router; this will either dismiss the presented `UIViewController` (i.e. modal) or pop the top view controller in the navigationController.
 @param animated Whether or not the transition is animated;
 @remarks not idiomatic objective-c naming
 */
- (void)pop:(BOOL)animated;

///-------------------------------
/// @name Mapping URLs
///-------------------------------

/**
 Map a URL format to an anonymous callback
 @param format A URL format (i.e. "users/:id" or "logout")
 @param callback The callback to run when the URL is triggered in `open:`
 */
- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback;
/**
 Map a URL format to an anonymous callback and `UPRouterOptions` options
 @param format A URL format (i.e. "users/:id" or "logout")
 @param callback The callback to run when the URL is triggered in `open:`
 @param options Configuration for the route
 */
- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback withOptions:(UPRouterOptions *)options;
/**
 Map a URL format to an anonymous callback and `UPRouterOptions` options
 @param format A URL format (i.e. "users/:id" or "logout")
 @param controllerClass The `UIViewController` `Class` which will be instanstiated when the URL is triggered in `open:`
 */
- (void)map:(NSString *)format toController:(Class)controllerClass;
/**
 Map a URL format to an anonymous callback and `UPRouterOptions` options
 @param format A URL format (i.e. "users/:id" or "logout")
 @param controllerClass The `UIViewController` `Class` which will be instanstiated when the URL is triggered in `open:`
 @param options Configuration for the route, such as modal settings
 */
- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(UPRouterOptions *)options;

///-------------------------------
/// @name Opening URLs
///-------------------------------

/**
 A convenience method for opening a URL using `UIApplication` `openURL:`.
 @param url The URL the OS will open (i.e. "http://google.com")
 */
- (void)openExternal:(NSString *)url;

/**
 Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`. `UIViewController` transitions will be animated;
 @param url The URL being opened (i.e. "users/16")
 @exception RouteNotFoundException Thrown if url does not have a valid mapping
 @exception NavigationControllerNotProvided Thrown if url opens a `UIViewController` and navigationController has not been assigned
 @exception RoutableInitializerNotFound Thrown if the mapped `UIViewController` instance does not implement -initWithRouterParams: or +allocWithRouterParams:
 */
- (void)open:(NSString *)url;

/**
 Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 @param url The URL being opened (i.e. "users/16")
 @param animated Whether or not `UIViewController` transitions are animated.
 @exception RouteNotFoundException Thrown if url does not have a valid mapping
 @exception NavigationControllerNotProvided Thrown if url opens a `UIViewController` and navigationController has not been assigned
 @exception RoutableInitializerNotFound Thrown if the mapped `UIViewController` instance does not implement -initWithRouterParams: or +allocWithRouterParams:
 */
- (void)open:(NSString *)url animated:(BOOL)animated;

/**
 Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 @param url The URL being opened (i.e. "users/16")
 @param animated Whether or not `UIViewController` transitions are animated.
 @param extraParams more paramters to pass in while opening a `UIViewController`; take priority over route-specific default parameters
 @exception RouteNotFoundException Thrown if url does not have a valid mapping
 @exception NavigationControllerNotProvided Thrown if url opens a `UIViewController` and navigationController has not been assigned
 @exception RoutableInitializerNotFound Thrown if the mapped `UIViewController` instance does not implement -initWithRouterParams: or +allocWithRouterParams:
 */
- (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams;

/**
 Get params of a given URL, simply return the params dictionary NOT using a block
 @param url The URL being detected (i.e. "users/16")
 */
- (NSDictionary*)paramsOfUrl:(NSString*)url;

@end

#pragma mark - Router adapter

@interface BaseViewController ()

@property (nonatomic, strong) NSDictionary *params;

- (instancetype)initWithRouterParams:(NSDictionary *)params;

@end

#pragma mark - Router convenionce

@interface NSObject ( ViewRouter )

- (void)router_setNavigationController:(UINavigationController *)controller;

/**
 *  Register view contoller to router
 *
 *  @param c Class of the view controller
 */
- (void)router_register:(Class)c;

/**
 *  Open view controller
 *
 *  @param url unique url of view Controller (like class name)
 */
- (void)router_open:(NSString *)url;

/**
 *  Open view controller
 *
 *  @param url unique url of view Controller (like class name)
 *  @param animate   animate
 *  @param params    extra params
 */
- (void)router_open:(NSString *)url animate:(BOOL)animate extraParams:(NSDictionary *)params;

/**
 *  Open out link
 *
 *  @param url link
 */
- (void)router_openExternal:(NSString *)url;

/**
 *  Open view controller without param cache
 *
 *  @param controller controller
 */
- (void)router_push:(UIViewController *)controller;

/**
 *  Pop the last view (controller)
 */
- (void)router_pop;

/**
 *  Pop to the exactly view, MUST be in the sample navigation route
 */
- (void)router_popTo:(UIViewController *)controller;

/**
 *  Pop to the exactly view, MUST be in the sample navigation route
 *
 *  @param url unique url of a view page
 */
- (void)router_popTos:(NSString *)url;

#pragma mark - react native

/**
 *  权宜之计
 *
 *  @param c class of a view page
 */
- (void)rn_register:(Class)c;

/**
 *  Open react native vc with extra params
 *
 *  @param params all the params the client wanna pass to
 
 *  Basic key value define
 
 *  'url'       url to init RCTRootView
 *  'title'     title of View Controller
 *  'param'     param to init react view
 *  'module'    module name to load react view
 */
- (void)rn_openWithExtraParams:(NSDictionary *)params;

@end




