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
    
    __weak typeof(self) weak_self = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong typeof(weak_self) strong_self = weak_self;
        TPJsPlugin *plugin = [strong_self.service.pluginManager getPluginWithName:command.pluginName];
        NSString *realMethodName = [strong_self.service.pluginManager getPluginRealMethodWithName:command.pluginName provideMethodName:command.pluginProvideMethod];
        SEL selector = NSSelectorFromString([realMethodName stringByAppendingString:@":"]);
        if (selector && [plugin respondsToSelector:selector]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                ((void (*)(id, SEL, id))objc_msgSend)(plugin, selector, command);
            }];
            [[NSOperationQueue mainQueue] waitUntilAllOperationsAreFinished];
        }else {
            TPJsBridgeLog(@"%@ is not suport for %@", command.pluginProvideMethod, command.pluginName);
        }
    }];

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
