//
//  LDJSPluginManager.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPluginManager.h"
#import "TPJsPluginInfo.h"
#import "TPJsBridgeMacro.h"
#import "TPJsPlugin.h"

@interface TPJsPluginManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, TPJsPluginInfo *> *pluginMap;
@property (nonatomic, copy) NSURL *updateJsBridgeUrl;
@property (nonatomic, assign, getter=isUpdated) BOOL updated;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, weak) TPJsService *service;
@end

@implementation TPJsPluginManager

- (instancetype)init {
    NSAssert(NO, @"Please use initWithConfigFile: to initialize.");
    return nil;
}

- (instancetype)initWithService:(TPJsService *)service plugins:(NSArray<NSDictionary *> *)plugins {
    self = [super init];
    if (self) {
        self.service = service;
        [self parsePlugins:plugins];
    }
    return self;
}


- (void)parsePlugins:(NSArray<NSDictionary *> *)plugins {
    
    if (plugins.count == 0) return;
    
    for (NSDictionary *plugin in plugins) {
        NSString *pClass = [plugin objectForKey:@"pluginclass"];
        Class aClass = NSClassFromString(pClass);
        if (!aClass) {
            TPJsBridgeLog(@"class is not found: %@", pClass);
            continue;
        }
        
        NSString *pName = [plugin objectForKey:@"pluginname"];
        NSDictionary *exports = [plugin objectForKey:@"exports"];
        
        TPJsPluginInfo *info = [[TPJsPluginInfo alloc] initWithName:pName class:aClass exports:exports];
        info.pInstance.service = self.service;
        
        [self.lock lock];
        self.pluginMap[info.pName] = info;
        [self.lock unlock];
    }
    
}


- (TPJsPlugin *)getPluginWithName:(NSString *)pName {
    if (!pName || pName.length == 0) return nil;
    TPJsPlugin *plugin = self.pluginMap[pName].pInstance;
    if (plugin.service != self.service) {
        plugin.service = self.service;
    }
    return plugin;
}


- (NSString *)getPluginRealMethodWithName:(NSString *)pName provideMethodName:(NSString *)provideMethodName {
    if (!provideMethodName || provideMethodName.length == 0) return nil;
    TPJsPluginInfo *info = self.pluginMap[pName];
    NSString *methodName = info.pExports[provideMethodName] ? : provideMethodName;
    return methodName;
}


#pragma mark - utilities


#pragma mark - lazy
- (NSMutableDictionary<NSString *,TPJsPluginInfo *> *)pluginMap {
    if (_pluginMap == nil) {
        _pluginMap = [[NSMutableDictionary alloc] init];
    }
    return _pluginMap;
}
                          
                          

- (NSLock *)lock {
    if (_lock == nil) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}



@end
