//
//  TPJsCommandQueue.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsCommandQueue.h"
#import "TPJsService.h"
#import "TPJsInvokedUrlCommand.h"
#import "TPJsBridgeMacro.h"
#import "TPJsPluginManager.h"
#import "TPJsPlugin.h"
#import <objc/message.h>
#import "TPJsConfiguration.h"
#import "TPJsBridgePrivate.h"

@interface TPJsCommandQueue ()
@property (nonatomic, weak) TPJsService *service;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation TPJsCommandQueue

- (instancetype)initWithService:(TPJsService *)servie {
    self = [super init];
    if (self) {
        self.service = servie;
    }
    return self;
}

- (void)excuteCommand:(TPJsInvokedUrlCommand *)command {
    if ((command.pluginName == nil) || (command.pluginProvideMethod == nil)) {
        TPJsBridgeLog(@"ERROR: pluginName and/or pluginShowMethod not found for command.");
        return;
    }
    
    TPJsPluginManager *pluginManager = [self pluginManager];
    
    [self.operationQueue addOperationWithBlock:^{
        TPJsPlugin *plugin = [pluginManager getPluginWithName:command.pluginName];
        
        NSString *realMethodName = [pluginManager getPluginRealMethodWithName:command.pluginName provideMethodName:command.pluginProvideMethod];
        
        SEL selector = NSSelectorFromString([realMethodName stringByAppendingString:@":"]);
        if (selector && [plugin respondsToSelector:selector]) {
            // 目前都是放到主线程操作，如果有大量耗时操作，这里其实是有问题的。
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                ((void (*)(id, SEL, id))objc_msgSend)(plugin, selector, command);
            }];
            
        }else {
            TPJsBridgeLog(@"%@ is not suport for %@", command.pluginProvideMethod, command.pluginName);
        }
    }];

}

- (TPJsPluginManager *)pluginManager {
    return self.service.configuration.pluginManager;
}

- (void)setService:(TPJsService *)service {
    if (_service == service) {
        return;
    }
    _service = service;
    
    for (TPJsPlugin *plugin in [[self pluginManager] getAllPlugins]) {
        plugin.service = service;
    }
}

#pragma mark - lazy
- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
