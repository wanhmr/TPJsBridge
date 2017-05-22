//
//  TPJsInvokedUrlCommand.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPJsInvokedUrlCommand : NSObject
@property (nonatomic, readonly) NSString *callbackId;
@property (nonatomic, readonly) NSString *pluginName;
@property (nonatomic, readonly) NSString *pluginProvideMethod;
@property (nonatomic, readonly) NSDictionary *data;

- (instancetype)initWithPluginName:(NSString *)pluginName pluginProvideMethod:(NSString *)pluginProvideMethod data:(NSDictionary *)data callbackId:(NSString *)callbackId;

+ (instancetype)commandWithUrl:(NSURL *)url;
@end
