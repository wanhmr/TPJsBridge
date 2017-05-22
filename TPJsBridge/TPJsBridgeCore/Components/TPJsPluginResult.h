//
//  TPJsPluginResult.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TPJsCommandResultStatus) {
    TPJsCommandResultStatus_NO_RESULT = 0,
    TPJsCommandResultStatus_OK,
    TPJsCommandResultStatus_CLASS_NOT_FOUND_EXCEPTION,
    TPJsCommandResultStatus_ILLEGAL_ACCESS_EXCEPTION,
    TPJsCommandResultStatus_INSTANTIATION_EXCEPTION,
    TPJsCommandResultStatus_MALFORMED_URL_EXCEPTION,
    TPJsCommandResultStatus_IO_EXCEPTION,
    TPJsCommandResultStatus_INVALID_ACTION,
    TPJsCommandResultStatus_JSON_EXCEPTION,
    TPJsCommandResultStatus_ERROR
};


@interface TPJsPluginResult : NSObject
- (instancetype)initWithStatus:(TPJsCommandResultStatus)status message:(NSDictionary *)message;

+ (instancetype)resultWithStatus:(TPJsCommandResultStatus)status message:(NSDictionary *)message;

- (NSString *)toJsonString;
@end
