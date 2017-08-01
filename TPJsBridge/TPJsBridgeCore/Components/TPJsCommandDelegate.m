//
//  TPJsCommandDelegate.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsCommandDelegate.h"
#import "TPJsService.h"
#import "TPJsPluginResult.h"
#import "TPJsBridgeConst.h"

@interface TPJsCommandDelegateImpl ()
@property (nonatomic, weak) TPJsService *service;
@end

@implementation TPJsCommandDelegateImpl


- (instancetype)initWithService:(TPJsService *)service {
    if (self = [super init]) {
        self.service = service;
    }
    return self;
}

- (void)sendPluginResult:(TPJsPluginResult *)result callbackId:(NSString *)callbackId {
    if (!callbackId || callbackId.length == 0 || !result) return;
    
    NSString *data = [result toJsonString];
    NSString *js = [NSString stringWithFormat:@"%@.execGlobalCallback('%@', %@, false);", self.service.scheme, callbackId, data];
    [self.service evaluateJavaScript:js completionHandler:nil];
}

@end
