//
//  BaseWebViewController.m
//  Html5Demo
//
//  Created by 李杰 on 4/7/15.
//  Copyright (c) 2015 only.com. All rights reserved.
//

#import "WebApi.h"
#import "BaseWebViewController.h"
#import "EasyJSBridge.h"
#import "vendor/ui.MBProgressHUD/MBProgressHUD.h"
#import "_captain.h"

#define kWebFailedViewHeight    200.0f
#define kWebFailedViewWidth     320.0f
#define kWebLoadingViewHeight   105.0f
#define kWebLoadingViewWidth    275.0f

#define kH5LogLevelDebug     @"d"
#define kH5LogLevelInfo      @"i"
#define kH5LogLevelWarning   @"w"
#define kH5LogLevelError     @"e"

#define kH5LogLevelKey       @"lv"
#define kH5LogTagKey         @"tag"
#define kH5LogMsgKey         @"msg"
#define kH5LogTitleKey       @"title"

@interface BaseWebViewController () <EasyJSBridgeDelegate>

@property (nonatomic, strong) UIButton          *backButtonWhenLoading;
@property (nonatomic, weak)   IBOutlet UIButton *retryButton;
@property (nonatomic, strong) IBOutlet UIView   *webFailedView;

@property (nonatomic, strong) UIView            *processView;
@property (nonatomic, strong) NSString          *webviewTitle;
@property (nonatomic, strong) NSString          *currentShareUrl;
@property (nonatomic, strong) NSString          *urlHost;
@property (nonatomic, assign) BOOL               isWebViewLoadSuccess;

@end

@implementation BaseWebViewController
@synthesize webHolder;

#pragma mark - Initialize

- (void)commonInit {
    self.bounces = YES;
    
    self.allowGoBack = YES;
}

- (id)initWithUrl:(NSString *)url withParam:(NSDictionary *)param {
    if (self = [super init]) {
        [self commonInit];
        
        self.requestUrl = url;
        self.params = param;
        
        if ([self.params hasKey:@"title"]) {
            self.title = self.params[@"title"];
        }
    }
    
    return self;
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor viewBackgroundColor]];
    
    [self setNavLeftItemWithImage:[BaseViewController backButtonImageName] target:self action:@selector(didClickOnReturnButton)];
    
    //初始化失败页面
    _webFailedView = [[[NSBundle mainBundle] loadNibNamed:@"WebFailedView" owner:self options:nil] lastObject];
    [self.view addSubview:_webFailedView];
    
    {
        [self.webFailedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    _webFailedView.hidden = YES;
    self.retryButton.backgroundColor = [UIColor themeRedColor];
    self.retryButton.layer.cornerRadius = 5;
    
    //初始化webview
    CGRect webHolderFrame = self.view.bounds;
    webHolderFrame = CGRectMake(webHolderFrame.origin.x,
                                webHolderFrame.origin.y,
                                webHolderFrame.size.width,
                                screen_height - status_bar_height - navigation_bar_height);
    
    self.webHolder = [[EasyJSWebView alloc] initWithFrame:webHolderFrame];
    self.webHolder.backgroundColor = [UIColor clearColor];
    self.webHolder.scrollView.backgroundColor = [UIColor clearColor];
    EasyJSBridge *interface = [EasyJSBridge new];
    interface.delegate = self;
    [self.webHolder addJavascriptInterfaces:interface WithName:@"QQJSExternal"];
    self.webHolder.delegate = self;
    self.webHolder.scrollView.bounces = self.bounces;
    self.webHolder.translatesAutoresizingMaskIntoConstraints = NO;
    self.webHolder.scalesPageToFit = YES;
    [self.view addSubview:self.webHolder];
    
    //初始化加载进度条
    self.processView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
    self.processView.backgroundColor = [UIColor themeColor];
    [self.view addSubview:self.processView];
    
}

#pragma mark - Life cycle

- (BOOL)navigationBarHiddenWhenAppear {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];

    [self requestWebView];
}

#pragma mark - Action handler

- (IBAction)retryButtonClicked:(id)sender {
    [self requestWebView];
    _webFailedView.hidden = YES;
    self.webHolder.hidden = NO;
}

- (void)didClickOnReturnButton {
    if (self.webHolder.canGoBack && self.allowGoBack) {
        [self.webHolder goBack];
        self.urlHost = self.webHolder.request.mainDocumentURL.host;
        self.currentShareUrl = self.webHolder.request.mainDocumentURL.absoluteString;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Event handler

- (void)handleFail:(NSError *)error {
    [self showToastWithText:localized(@"Web页面.页面加载失败.Toast提示")];
}

- (void)handleCancel:(id)param {
    [self router_pop];
}

- (void)handleWebCall:(NSString *)invoker param:(NSDictionary *)param {
    if ([self.receiver respondsToSelector:@selector(onMessage:param:)]) {
        [self.receiver onMessage:invoker param:param];
    }
}

#pragma mark - Process Animation

- (void)startAnimation {
    [self.processView.layer removeAllAnimations];
    self.processView.hidden = NO;
    self.processView.frame = CGRectMake(0, 0, 0, 3);
    [UIView animateWithDuration:4 animations:^{
        self.processView.frame = CGRectMake(0, 0, screen_width*0.6, 3);
    } completion:^(BOOL finished) {
        if (!self.isWebViewLoadSuccess) {
            [self secondAnimation];
        }
    }];
}

- (void)secondAnimation {
    [UIView animateWithDuration:4 animations:^{
        self.processView.frame = CGRectMake(0, 0, screen_width*0.8, 3);
    } completion:^(BOOL finished) {
        if (!self.isWebViewLoadSuccess) {
            [self thirdAnimation];
        }
    }];
}

- (void)thirdAnimation {
    [UIView animateWithDuration:8 animations:^{
        self.processView.frame = CGRectMake(0, 0, screen_width*0.9, 3);
    } completion:^(BOOL finished) {
    }];
}

- (void)endAnimation {
    [self.processView.layer removeAllAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        self.processView.frame = CGRectMake(0, 0, screen_width, 3);
    } completion:^(BOOL finished) {
        self.processView.hidden = YES;
    }];
}

#pragma mark - Utility

- (void)requestWebView {
    BOOL isH5CacheOptimize = YES;
    if (isH5CacheOptimize) {
        self.isWebViewLoadSuccess = NO;
        NSURL *url = [NSURL URLWithString:self.requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10.f];
        [self.webHolder loadRequest:request];
    } else {
        //清除本地h5缓存和cookie
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        self.isWebViewLoadSuccess = NO;
        NSURL *url = [NSURL URLWithString:self.requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:10.f];
        [self.webHolder loadRequest:request];
    }
}

#pragma mark - Share VC

- (void)onShare {
    
}

#pragma mark - UIWebViewDelegate

/********************
 
 以下4个方法是easyjs回调上来的，用于处理这几个问题：
 1.老的h5和app交互的case需要过滤
 2.h5页面加载失败后，需要显示native的失败页面
 3.针对h5页面加载的各个状态，子类可能处理一些特殊case
 
 ********************/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    __unused NSURL *url = [request mainDocumentURL];
    __unused NSString *absUrl = [url absoluteString];
    BOOL isNativeCaller = [absUrl contains:NativeHrefCallMatcher];
    __unused NSString *query = [[request.URL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (isNativeCaller) {
        self.urlHost = url.host;
        self.currentShareUrl = request.mainDocumentURL.absoluteString;
        
        if([url.path contains:NativeHrefCall_Back]){ // containsString 只有8.0后可以用
            if ([self respondsToSelector:@selector(handleCancel:)]) {
                [self performSelector:@selector(handleCancel:) withObject:nil];
            }
            
            return NO;
        }
        
        else {
            NSDictionary *params = [query queryDictionaryUsingEncoding:NSUTF8StringEncoding];
            
            LOG(@"Scheme: %@", [url scheme]);
            LOG(@"Host: %@", [url host]);
            LOG(@"Port: %@", [url port]);
            LOG(@"Path: %@", [url path]);
            LOG(@"Relative path: %@", [url relativePath]);
            LOG(@"Path components as array: %@", [url pathComponents]);
            LOG(@"Parameter string: %@", [url parameterString]);
            LOG(@"Query: %@", [url query]);
            LOG(@"Fragment: %@", [url fragment]);
            LOG(@"User: %@", [url user]);
            LOG(@"Password: %@", [url password]);
            
            [self handleWebCall:request.URL.host param:params];
            
            return NO;
        }

    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.backButtonWhenLoading.hidden = NO;
    self.isWebViewLoadSuccess = NO;
    self.webHolder.hidden = NO;
    
    [self startAnimation];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.isWebViewLoadSuccess = YES;
    self.backButtonWhenLoading.hidden = YES;
    self.webFailedView.hidden = YES;
    
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    //外部网页，不会有回调显示分享按钮，需要默认打开
    if (![self.currentShareUrl contains:@"www.baidu.com"]) {
        [self setNavRightItemWithImage:@"my_icon23" target:self action:@selector(onShare)];
    }

    //外部网页，title需要截取网页的title
    if (![self.params hasKey:@"title"] ||
        [self.title empty]) // 优先使用外部的
    {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        if ([self.title empty]) {
            self.title = @"发咖";
        }
    }

    //当前还有资源需要加载的话，进度条就不干掉
    if (![self.webHolder isLoading]) {
        [self endAnimation];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    self.backButtonWhenLoading.hidden = YES;
    
    [self hideLoadingIndicator];
    self.webFailedView.hidden = NO;
    [self setNavTitleString:@"敬请期待"];
    self.webHolder.hidden = YES;

    [self endAnimation];
}

#pragma mark - QQJSExternalDelegate

/*
 * qqJSExternal回调方法，接收h5页面的回调
 *
 * @return param    content     返回的参数
 * @return param    methodName  返回的方法名，通过这个可以区分是什么回调
 *
 */
- (void)callbackWithContent:(NSString *)content methodName:(NSString *)methodName {
    
    NSError* parseToJsonError = nil;
    NSMutableDictionary* dicPrama = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&parseToJsonError];

    if ([methodName isEqualToString:kEasyJSCallBack]) {//h5页面返回
        DDLogInfo(@"h5页面返回,content=%@,methodName=%@",dicPrama,methodName);
        
        [self handleCancel:nil];
    } else if ([methodName isEqualToString:kEasyJSRefresh]) {//h5 刷新
        DDLogInfo(@"h5页面刷新,content=%@,methodName=%@",dicPrama,methodName);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:NSURLErrorTimedOut];
        [self.webHolder loadRequest:request];
    } else if ([methodName isEqualToString:NativeHrefCall_Reload]) {
        DDLogInfo(@"h5页面重新加载,content=%@,methodName=%@",dicPrama,methodName);
    } else if ([methodName isEqualToString:kEasyJSLog]) {
        DDLogInfo(@"h5页面log,content=%@",dicPrama);
    }
    
    
    else if ([methodName is:NativeHrefCall_BuyProduct]) {
        
    }
    
    else if ([methodName isEqualToString:kEasyJSLog]) {//打印h5页面log
        NSString *logLevel = [dicPrama objectForKey:kH5LogLevelKey];
        NSString *logTag = [dicPrama objectForKey:kH5LogTagKey];
        NSString *logMsg = [dicPrama objectForKey:kH5LogMsgKey];
        NSString *logHoleMessage = [NSString stringWithFormat:@"[H5]---%@-%@",logTag,logMsg];
        
        if ([logLevel isEqualToString:kH5LogLevelDebug]) {
            DDLogDebug(@"%@", logHoleMessage);
//            TestDebugLog2(@"H5模块", @"H5日志:[DEBUG]%@", logHoleMessage);
        } else if ([logLevel isEqualToString:kH5LogLevelInfo]) {
            DDLogInfo(@"%@", logHoleMessage);
//            TestDebugLog2(@"H5模块", @"H5日志:[INFO]%@", logHoleMessage);
        } else if ([logLevel isEqualToString:kH5LogLevelError]) {
            DDLogError(@"%@", logHoleMessage);
//            TestDebugLog2(@"H5模块", @"H5日志:[ERROR]%@", logHoleMessage);
        } else if ([logLevel isEqualToString:kH5LogLevelWarning]) {
            DDLogWarn(@"%@", logHoleMessage);
//            TestDebugLog2(@"H5模块", @"H5日志:[WARNING]%@", logHoleMessage);
        }
    } else if ([methodName isEqualToString:kEasyJSTitle]) {//h5回调显示标题
        NSString *title = [dicPrama objectForKey:kH5LogTitleKey];
        self.title = title;
    } else if ([methodName isEqualToString:kEasyJSShareH5]) {//显示分享h5页面按钮
        [self setNavRightItemWithImage:@"my_icon23" target:self action:@selector(shareCurrentH5)];
    } else if ([methodName isEqualToString:@"showAlertMessage"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
}

@end
