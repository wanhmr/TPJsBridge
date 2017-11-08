//
//  TPJsService.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <WebKit/WebKit.h>
@class TPJsConfiguration;

typedef NS_ENUM(NSInteger, TPJsServiceStatus) {
    TPJsServiceStatusClosed,
    TPJsServiceStatusConnecting,
    TPJsServiceStatusOpened // isReady
};

NS_ASSUME_NONNULL_BEGIN

@interface TPJsService : NSObject 
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong, readonly) TPJsConfiguration *configuration;
@property (nonatomic, readonly) TPJsServiceStatus status;
@property (nonatomic, readonly) NSString *scheme;
@property (nonatomic, readonly) BOOL isReady; // status == TPJsServiceStatusOpened

- (instancetype)initWithConfiguration:(nullable TPJsConfiguration *)configuration;

+ (instancetype)defaultService;

- (void)connect:(nonnull WKWebView *)webView;

- (void)close;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

@end
NS_ASSUME_NONNULL_END
