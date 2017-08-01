//
//  TPJsService.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <WebKit/WebKit.h>
@class TPJsPluginManager;
@class TPJsCommandDelegateImpl;

typedef NS_ENUM(NSInteger, TPJsServiceStatus) {
    TPJsServiceStatusClosed,
    TPJsServiceStatusConnecting,
    TPJsServiceStatusOpened // isReady
};

NS_ASSUME_NONNULL_BEGIN

@interface TPJsService : NSObject <WKNavigationDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, readonly) TPJsPluginManager *pluginManager;
@property (nonatomic, readonly) TPJsCommandDelegateImpl *commandDelegate;
@property (nonatomic, readonly) NSString *scheme;
@property (nonatomic, readonly) NSString *jsBridgeDidReadyEventName;
@property (nonatomic, readonly) TPJsServiceStatus status;
@property (nonatomic, readonly) BOOL isReady;

- (instancetype)initWithConfigFilePath:(NSString * _Nullable)configFilePath apiBuildFilePath:(NSString * _Nullable)apiBuildFilePath;

+ (instancetype)service;

- (void)connect:(WKWebView *)webView;

- (void)close;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

@end
NS_ASSUME_NONNULL_END
