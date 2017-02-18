//
//  RxWebViewController.h
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

//  inspired by https://github.com/Roxasora/RxWebViewController

//#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RxWebViewController : BaseViewController

/**
 *  origin url
 */
@property (nonatomic, strong) NSURL *url;

/**
 *  embed webView
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 *  tint color of progress view
 */
@property (nonatomic, strong) UIColor *progressViewColor;

/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */
- (instancetype)initWithUrl:(NSURL *)url;


- (void)reloadWebView;

@end



