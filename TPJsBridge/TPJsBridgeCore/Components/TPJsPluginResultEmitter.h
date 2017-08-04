//
//  TPJsPluginResultEmitter.h
//  Pods
//
//  Created by Tpphha on 2017/8/4.
//
//

#import <Foundation/Foundation.h>
#import "TPJsPluginResult.h"

@interface TPJsPluginResultEmitter : NSObject

- (void)sendPluginResult:(TPJsPluginResult *)result callbackId:(NSString *)callbackId;

- (void)sendPluginResultWithStatus:(TPJsCommandResultStatus)status message:(NSDictionary *)message callbackId:(NSString *)callbackId;

- (void)sendPluginResultOKWithMessage:(NSDictionary *)message callbackId:(NSString *)callbackId;

- (void)sendPluginResultErrorWithMessage:(NSDictionary *)message callbackId:(NSString *)callbackId;

@end
