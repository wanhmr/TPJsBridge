//
//  TPJsPlugin_device.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPlugin.h"

@interface TPJsPlugin_device : TPJsPlugin
/**
 *@func 获取设备信息
 */
- (void)getDeviceInfo:(TPJsInvokedUrlCommand *)command;

@end
