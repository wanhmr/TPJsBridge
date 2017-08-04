//
//  TPJsPlugin.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPlugin.h"
#import "TPJsService.h"
#import "TPJsBridgeConst.h"
#import "TPJsConfiguration.h"

@interface TPJsPlugin ()
@property (nonatomic, weak) TPJsService *service;
@end

@implementation TPJsPlugin
@dynamic isReady, pluginResultEmitter;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self didInitialize];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onConnecting:)
                                                 name:kTPJsBridgeDidConnectingNotification
                                               object:self.service];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onClose:)
                                                 name:kTPJsBridgeDidCloseNotification
                                               object:self.service];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReady:)
                                                 name:kTPJsBridgeDidReadyNotification
                                               object:self.service];
    
}


- (void)unregisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTPJsBridgeDidConnectingNotification object:self.service];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTPJsBridgeDidCloseNotification object:self.service];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTPJsBridgeDidReadyNotification object:self.service];
}

- (void)setService:(TPJsService *)service {
    [self unregisterNotification];
    
    _service = service;
    
    [self registerNotification];
}

#pragma mark - public

- (void)didInitialize {
    
}

- (void)onConnecting:(NSNotification *)notification {
    
}

- (void)onClose:(NSNotification *)notification {
    
}

- (void)onReady:(NSNotification *)notification {
    
}

- (BOOL)isReady {
    return self.service.isReady;
}


- (TPJsPluginResultEmitter *)pluginResultEmitter {
    return self.service.configuration.pluginResultEmitter;
}


@end
