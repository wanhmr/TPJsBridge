//
//  TPJsPlugin_viewPageManager.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/21.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <TPJsBridge.h>
#import <WebKit/WebKit.h>

@interface UIApplication (TPJsBridgeTopViewController)
- (UIViewController *)topViewController;
@end

@interface TPJsWebViewController : UIViewController
- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithURL:(NSURL *)url;
@end

@interface TPJsPlugin_viewPageManager : TPJsPlugin
- (void)openViewPage:(TPJsInvokedUrlCommand *)command;
@end
