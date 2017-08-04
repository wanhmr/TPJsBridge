//
//  TPJsPlugin_device.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPlugin_device.h"
#import "TPJsPluginResult.h"

@implementation TPJsPlugin_device

- (void)getDeviceInfo:(TPJsInvokedUrlCommand *)command {
    NSMutableDictionary *deviceProperties = [NSMutableDictionary dictionaryWithCapacity:4];
    
    UIDevice *device = [UIDevice currentDevice];
    [deviceProperties setObject:[device systemName] forKey:@"systemName"];
    [deviceProperties setObject:[device systemVersion] forKey:@"systemVersion"];
    [deviceProperties setObject:[device model] forKey:@"model"];
    
    
    [self.pluginResultEmitter sendPluginResultOKWithMessage:deviceProperties callbackId:command.callbackId];
}
@end
