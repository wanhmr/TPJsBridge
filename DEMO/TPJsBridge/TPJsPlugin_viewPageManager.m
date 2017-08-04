//
//  TPJsPlugin_viewPageManager.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/21.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPlugin_viewPageManager.h"


@implementation UIApplication (TPJsBridgeTopViewController)

- (UIViewController *)topViewController
{
    return [self tp_visibleViewControllerFrom:self.keyWindow.rootViewController];
}


- (UIViewController *)tp_visibleViewControllerFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self tp_visibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self tp_visibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    }
    
    if (vc.presentedViewController) {
        return [self tp_visibleViewControllerFrom:vc.presentedViewController];
    }
    
    return vc;
    
}

@end

#import "TPJsService.h"

@interface TPJsWebViewController ()
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, strong) TPJsService *service;
@end

@implementation TPJsWebViewController

- (instancetype)initWithRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return [self initWithRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    [webView loadRequest:self.request];
    
    self.service = [TPJsService defaultService];
    [self.service connect:webView];
    
}

- (void)dealloc {
    [self.service close];
}


@end

@implementation TPJsPlugin_viewPageManager
- (void)openViewPage:(TPJsInvokedUrlCommand *)command {
    NSString *url = command.data[@"url"];
    NSString *title = command.data[@"title"];
    NSNumber *animated = command.data[@"animated"];
    UIViewController *topViewCtrl = [[UIApplication sharedApplication] topViewController];
    TPJsWebViewController *webViewCtrl = [[TPJsWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    webViewCtrl.title = title;
    TPJsPluginResult *result = [TPJsPluginResult resultWithStatus:TPJsCommandResultStatus_OK message:command.data];
    if (topViewCtrl.navigationController) {
        [topViewCtrl.navigationController pushViewController:webViewCtrl animated:animated.boolValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pluginResultEmitter sendPluginResult:result callbackId:command.callbackId];
        });
    }else {
        [topViewCtrl presentViewController:webViewCtrl animated:animated.boolValue completion:^{
            [self.pluginResultEmitter sendPluginResult:result callbackId:command.callbackId];
        }];
    }
}

@end
