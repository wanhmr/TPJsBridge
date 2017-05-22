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

@interface TPJsPlugin ()
@property (nonatomic, assign) BOOL isReady;
@end

@implementation TPJsPlugin
- (instancetype)init {
    self = [super init];
    if (self) {
        [self didInitialize];
    }
    return self;
}


- (void)dealloc {
    [self unregisterNotification];
}

#pragma mark - notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onConnect:)
                                                 name:kTPJsBridgeDidConnectNotification
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTPJsBridgeDidConnectNotification object:self.service];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTPJsBridgeDidCloseNotification object:self.service];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTPJsBridgeDidReadyNotification object:self.service];
}

- (void)setService:(TPJsService *)service {
    if (_service != service) {
        [self unregisterNotification];
    }
    
    _service = service;
    
    [self registerNotification];
}

#pragma mark - public

- (void)didInitialize {
    
}

- (void)onConnect:(NSNotification *)notification {
    
}

- (void)onClose:(NSNotification *)notification {
    
}

- (void)onReady:(NSNotification *)notification {
    self.isReady = YES;
}

- (id<TPJsCommandDelegate>)commandDelegate
{
    if (self.service) {
        return self.service.commandDelegate;
    } else {
        NSAssert(NO, @"the bridge Service is not connected");
        return nil;
    }
}

@end
