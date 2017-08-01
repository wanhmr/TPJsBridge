//
//  TPJsInvokedUrlCommand.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsInvokedUrlCommand.h"
#import "NSString+TPJsBridge.h"

@interface TPJsInvokedUrlCommand ()
@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, copy) NSString *pluginName;
@property (nonatomic, copy) NSString *pluginProvideMethod;
@property (nonatomic, copy) NSDictionary *data;
@end

@implementation TPJsInvokedUrlCommand

- (instancetype)initWithPluginName:(NSString *)pluginName pluginProvideMethod:(NSString *)pluginProvideMethod data:(NSDictionary *)data callbackId:(NSString *)callbackId {
    self = [super init];
    if (self) {
        self.pluginName = pluginName;
        self.pluginProvideMethod = pluginProvideMethod;
        self.data = data;
        self.callbackId = callbackId;
    }
    return self;
}


+ (instancetype)commandWithUrl:(NSURL *)url {
    if (!url) {
        return nil;
    }
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    NSString *callbackId = components.fragment;
    NSString *pluginName = components.host;
    NSString *pluginProvideMethod = url.lastPathComponent;
    NSURLQueryItem *item = components.queryItems.firstObject;
    NSDictionary *data = nil;
    if (item) {
        NSString *dataStr = item.value.tp_URLDecodedString;
        data = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    
    return [[self alloc] initWithPluginName:pluginName pluginProvideMethod:pluginProvideMethod data:data callbackId:callbackId];
}



@end
