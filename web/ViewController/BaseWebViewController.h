//
//  BaseWebViewController.h
//  Html5Demo
//
//  Created by 李杰 on 4/7/15.
//  Copyright (c) 2015 only.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyJSWebView.h"
#import "mvc-native.h"

@protocol WebViewJavaScriptReceiver;

/**
 *  param:
 *      title : self.title
 *      1. 优先使用外部设置的
 *      2. 其次使用h5中的title
 *      3. 最后使用应用名字
 */
@interface BaseWebViewController : BaseViewController <UIWebViewDelegate> {
    @private
    UIWebView *_webHolder;
    
    __weak id<WebViewJavaScriptReceiver> _delegate;
}

@property (nonatomic, strong) EasyJSWebView *webHolder;

@property (nonatomic, weak) id<WebViewJavaScriptReceiver> receiver;
@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, assign) BOOL bounces;

/**
 *  是否允许web页面内链接回退
 */
@property (nonatomic, assign) BOOL allowGoBack;

- (id)initWithUrl:(NSString *)url withParam:(NSDictionary *)param;

@end

/**
 * 协议 用于组合机制
 */
@protocol WebViewJavaScriptReceiver <NSObject>

/**
 *  webview，js回调通知
 *
 *  @param invoker should use like contains:NativeHrefCall_BuyProduct
 *  @param param   params
 */
- (void)onMessage:(NSString *)invoker param:(NSDictionary *)param;

@end
