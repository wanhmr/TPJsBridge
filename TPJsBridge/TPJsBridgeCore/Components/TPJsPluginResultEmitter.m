//
//  TPJsPluginResultEmitter.m
//  Pods
//
//  Created by Tpphha on 2017/8/4.
//
//

#import "TPJsPluginResultEmitter.h"
#import "TPJsService.h"

@interface TPJsPluginResultEmitter ()
@property (nonatomic, weak) TPJsService *service;
@end

@implementation TPJsPluginResultEmitter

- (void)sendPluginResult:(TPJsPluginResult *)result callbackId:(NSString *)callbackId {
    if (!callbackId || callbackId.length == 0 || !result || !self.service) return;
    
    NSString *data = [result toJsonString];
    NSString *js = [NSString stringWithFormat:@"%@.execGlobalCallback('%@', %@, false);", self.service.scheme, callbackId, data];
    [self.service evaluateJavaScript:js completionHandler:nil];
}

- (void)sendPluginResultWithStatus:(TPJsCommandResultStatus)status message:(NSDictionary *)message callbackId:(NSString *)callbackId {
    if (!message || callbackId.length == 0) return;
    
    TPJsPluginResult *result = [TPJsPluginResult resultWithStatus:status message:message];
    [self sendPluginResult:result callbackId:callbackId];
}

- (void)sendPluginResultOKWithMessage:(NSDictionary *)message callbackId:(NSString *)callbackId {
    [self sendPluginResultWithStatus:TPJsCommandResultStatus_OK message:message callbackId:callbackId];
}

- (void)sendPluginResultErrorWithMessage:(NSDictionary *)message callbackId:(NSString *)callbackId {
    [self sendPluginResultWithStatus:TPJsCommandResultStatus_ERROR message:message callbackId:callbackId];
}

@end
