//
//  TPJsConfiguration.m
//  Pods
//
//  Created by Tpphha on 2017/8/4.
//
//

#import "TPJsConfiguration.h"
#import "TPJsService.h"
#import "TPJsConfigParser.h"
#import "TPJsPluginManager.h"
#import "TPJsPluginResultEmitter.h"
#import "TPJsBridgeCodeProvider.h"
#import "TPJsBridgePrivate.h"

@interface TPJsConfiguration ()
@property (nonatomic, weak) TPJsService *service;
@end

@implementation TPJsConfiguration

- (instancetype)initWithConfigFilePath:(NSString *)configFilePath apiBuildFilePath:(NSString *)apiBuildFilePath {
    self = [super init];
    if (self) {
        TPJsConfigParser *configParser = [[TPJsConfigParser alloc] initWithConfigFilePath:configFilePath];
        self.pluginManager = [[TPJsPluginManager alloc] initWithPlugins:configParser.plugins];
        self.jsBridgeCodeProvider = [[TPJsBridgeCodeProvider alloc] initWithJsBridgeScheme:configParser.scheme apiBuildFilePath:apiBuildFilePath apiBuildFileUpdateUrl:nil];
        self.pluginResultEmitter = [[TPJsPluginResultEmitter alloc] init];
    }
    return self;
}

- (void)setService:(TPJsService *)service {
    _service = service;
    self.pluginResultEmitter.service = service;
}

- (void)setPluginResultEmitter:(TPJsPluginResultEmitter *)pluginResultEmitter {
    _pluginResultEmitter = pluginResultEmitter;
    _pluginResultEmitter.service = self.service;
}

@end
