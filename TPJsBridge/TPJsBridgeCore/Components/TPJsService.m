//
//  TPJsService.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsService.h"
#import "TPJsInvokedUrlCommand.h"
#import "TPJsCommandQueue.h"
#import "TPJsBridgeCodeProvider.h"
#import "TPJsBridgeConst.h"
#import "TPJsBridgeMacro.h"
#import "TPJsConfiguration.h"
#import "TPJsBridgePrivate.h"

static NSString* const kTPJsBridgeScriptMessageHandlerName = @"TPJsBridge";

@interface TPJsService () <WKScriptMessageHandler>
@property (nonatomic, strong) TPJsCommandQueue *commandQueue;
@property (nonatomic, strong) TPJsConfiguration *configuration;
@end

@implementation TPJsService
@dynamic isReady, scheme;

- (instancetype)init {
    NSAssert(NO, @"Bridge Service must init with plugin config file");
    return nil;
}


- (instancetype)initWithConfiguration:(TPJsConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration ? configuration : [[TPJsConfiguration alloc] initWithConfigFilePath:nil apiBuildFilePath:nil];
        self.configuration.service = self;
        
        self.commandQueue = [[TPJsCommandQueue alloc] initWithService:self];
        
    }
    return self;
}

+ (instancetype)defaultService {
    return [[self alloc] initWithConfiguration:nil];
}

- (void)dealloc {
    TPJsBridgeLog(@"TPJsService dealloced.");
}



- (void)connect:(WKWebView *)webView {
    if (self.webView == webView) return;
    
    if (self.webView) {
        [self close];
    }
    
    _status = TPJsServiceStatusConnecting;
    
    self.webView = webView;
    
    [self addScriptMessageHandler];
    
    [self noticeDidConnecting];
}

- (void)close {
    WKWebView *webView = self.webView;
    if (!webView || _status == TPJsServiceStatusClosed) return;
    
    _status = TPJsServiceStatusClosed;
    
    [self removeScriptMessageHandler];
    self.webView = nil;
    
    [self noticeDidClose];
    
}


- (void)addScriptMessageHandler {
    WKWebView *webView = self.webView;
    WKUserContentController *userContentController = webView.configuration.userContentController;
    NSAssert(userContentController != nil, @"TPJsBridge: webview.configuration.userContentController cannot be nil.");
    
    NSString *jsBridge = [self.configuration.jsBridgeCodeProvider jsBridgeCode];
    NSString *readyJs = [NSString stringWithFormat:@"%@.execReady();", self.scheme];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:[jsBridge stringByAppendingString:readyJs] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    [userContentController addUserScript:script];
    
    [userContentController addScriptMessageHandler:self name:kTPJsBridgeScriptMessageHandlerName];
}

- (void)removeScriptMessageHandler {
    WKWebView *webView = self.webView;
    WKUserContentController *userContentController = webView.configuration.userContentController;
    @try {
        [userContentController removeScriptMessageHandlerForName:kTPJsBridgeScriptMessageHandlerName];
    } @catch (NSException *exception) {} @finally {}
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    id msgBody = message.body;
    if (!msgBody || [msgBody isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if ([message.name isEqualToString:kTPJsBridgeScriptMessageHandlerName] &&
        [msgBody isKindOfClass:[NSString class]]) {
        NSString *bodyString = msgBody;
        if (bodyString.length == 0) {
            return;
        }
        if ([bodyString isEqualToString:@"ready"]) {
            [self noticeReady];
        }else {
            NSURL *url = [NSURL URLWithString:bodyString];
            TPJsInvokedUrlCommand *command = [TPJsInvokedUrlCommand commandWithUrl:url];
            if (command) {
                [self.commandQueue excuteCommand:command];
            }
        }
    }
    
}


#pragma mark - notification
- (void)noticeReady {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPJsBridgeDidReadyNotification object:self];
}

- (void)noticeDidConnecting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPJsBridgeDidConnectingNotification object:self];
}

- (void)noticeDidClose {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPJsBridgeDidCloseNotification object:self];
}


#pragma mark - eval js
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark - getter
- (NSString *)scheme {
    return self.configuration.jsBridgeCodeProvider.scheme;
}

- (BOOL)isReady {
    return self.status == TPJsServiceStatusOpened;
}


@end
