//
//  TPJsPlugin.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPJsInvokedUrlCommand.h"
#import "TPJsPluginResultEmitter.h"

@interface TPJsPlugin : NSObject
@property (nonatomic, readonly) TPJsPluginResultEmitter *pluginResultEmitter;
@property (nonatomic, readonly) BOOL isReady;

- (void)didInitialize NS_REQUIRES_SUPER;


/**
 监听Bridge服务连接
 */
- (void)onConnecting:(NSNotification *)notification NS_REQUIRES_SUPER;

/**
 监听Bridge服务关闭
 */
- (void)onClose:(NSNotification *)notification NS_REQUIRES_SUPER;

/**
 监听Bridge服务打开
 */
- (void)onReady:(NSNotification *)notification NS_REQUIRES_SUPER;
@end
