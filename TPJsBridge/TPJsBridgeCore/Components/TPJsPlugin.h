//
//  TPJsPlugin.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPJsCommandDelegate.h"
#import "TPJsInvokedUrlCommand.h"
#import "TPJsPluginResult.h"

@interface TPJsPlugin : NSObject
@property (nonatomic, weak) TPJsService *service;
@property (nonatomic, readonly) id<TPJsCommandDelegate> commandDelegate;

- (void)didInitialize NS_REQUIRES_SUPER;


/**
 监听Bridge服务打开
 */
- (void)onConnect:(NSNotification *)notification NS_REQUIRES_SUPER;

/**
 * 监听Bridge服务关闭
 */
- (void)onClose:(NSNotification *)notification NS_REQUIRES_SUPER;

@end
