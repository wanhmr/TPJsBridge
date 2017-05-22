//
//  TPJsService.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsService.h"
#import "TPJsPluginManager.h"
#import "TPJsCommandDelegate.h"
#import "TPJsInvokedUrlCommand.h"
#import "TPJsCommandQueue.h"
#import "TPJsBridgeCodeProvider.h"
#import "TPJsBridgeConst.h"
#import "TPJsConfigParser.h"

@interface TPJsService ()
@property (nonatomic, strong) TPJsPluginManager *pluginManager;
@property (nonatomic, strong) TPJsCommandDelegateImpl *commandDelegate;
@property (nonatomic, strong) TPJsCommandQueue *commandQueue;
@property (nonatomic, strong) TPJsBridgeCodeProvider *jsBridgeCodeProvider;
@property (nonatomic, weak) id<WKNavigationDelegate> originNavigationDelegate;
@end

@implementation TPJsService

- (instancetype)init {
    NSAssert(NO, @"Bridge Service must init with plugin config file");
    return nil;
}


- (instancetype)initWithConfigFilePath:(NSString *)configFilePath apiBuildFilePath:(NSString *)apiBuildFilePath {
    self = [super init];
    if (self) {
        TPJsConfigParser *configParser = [[TPJsConfigParser alloc] initWithConfigFilePath:configFilePath];
        
        self.pluginManager = [[TPJsPluginManager alloc] initWithService:self plugins:configParser.plugins];
        self.commandDelegate = [[TPJsCommandDelegateImpl alloc] initWithService:self];
        self.commandQueue = [[TPJsCommandQueue alloc] initWithService:self];
        self.jsBridgeCodeProvider = [[TPJsBridgeCodeProvider alloc] initWithJsBridgeScheme:configParser.scheme apiBuildFilePath:apiBuildFilePath apiBuildFileUpdateUrl:nil];
    }
    return self;
}


- (void)dealloc {
    [self close];
}

+ (instancetype)service {
    return [[self alloc] initWithConfigFilePath:nil apiBuildFilePath:nil];
}


- (void)connect:(WKWebView *)webView {
    if (self.webView == webView) return;
    
    if (self.webView) {
        [self close];
    }
    
    self.webView = webView;
    self.originNavigationDelegate = self.webView.navigationDelegate;
    self.webView.navigationDelegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPJsBridgeDidConnectNotification object:self];
    
    [self registerKVO];
}

- (void)close {
    if (!self.webView) return;
    
    [self unregisterKVO];
    
    self.webView.navigationDelegate = self.originNavigationDelegate;
    self.originNavigationDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPJsBridgeDidCloseNotification object:self];
    
}


#pragma mark - KVO
- (void)registerKVO {
    if (!self.webView) return;
    [self.webView addObserver:self
               forKeyPath:@"navigationDelegate"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
}


- (void)unregisterKVO {
    if (!self.webView) return;
    [self.webView removeObserver:self forKeyPath:@"navigationDelegate"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id delegateNew = change[NSKeyValueChangeNewKey];
    if (self &&
        delegateNew &&
        delegateNew != [NSNull null] &&
        object == self.webView &&
        [keyPath isEqualToString:@"navigationDelegate"] &&
        delegateNew != self) {
        self.originNavigationDelegate = delegateNew;
        self.webView.navigationDelegate = self;
    }
}

#pragma mark - eval js
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark - scheme
- (NSString *)scheme {
    return self.jsBridgeCodeProvider.scheme;
}

#pragma mark - WKNavigationDelegate

/*! @abstract Decides whether to allow or cancel a navigation.
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:self.scheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        TPJsInvokedUrlCommand *command = [TPJsInvokedUrlCommand commandWithUrl:url];
        [self.commandQueue excuteCommand:command];
    }else {
        if ([self.originNavigationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
            [self.originNavigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        }else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [self.originNavigationDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.originNavigationDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [self.originNavigationDelegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.originNavigationDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [self.originNavigationDelegate webView:webView didCommitNavigation:navigation];
    }
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    __weak __typeof(self) weak_self = self;
    [self evaluateJavaScript:[self.jsBridgeCodeProvider jsBridgeCode] completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        __strong __typeof(weak_self) strong_self = weak_self;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTPJsBridgeDidReadyNotification object:strong_self];
        NSString *readyJs = [NSString stringWithFormat:@"%@.execPatchEvent('%@');", self.scheme, kTPJsBridgeDidReadyEvent];
        [strong_self evaluateJavaScript:readyJs completionHandler:nil];
    }];
    
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.originNavigationDelegate webView:webView didFinishNavigation:navigation];
    }
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [self.originNavigationDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [self.originNavigationDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

/*! @abstract Invoked when the web view's web content process is terminated.
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    if ([self.originNavigationDelegate respondsToSelector:@selector(webViewWebContentProcessDidTerminate:)]) {
        [self.originNavigationDelegate webViewWebContentProcessDidTerminate:webView];
    }
}

@end
