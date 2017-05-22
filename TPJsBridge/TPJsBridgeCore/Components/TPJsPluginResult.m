//
//  TPJsPluginResult.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPluginResult.h"
#import "TPJsBridgeMacro.h"
#import "TPJsBridgeConst.h"

@interface TPJsPluginResult ()
@property (nonatomic, assign) TPJsCommandResultStatus status;
@property (nonatomic, copy) NSDictionary *message;

@end

@implementation TPJsPluginResult

- (instancetype)initWithStatus:(TPJsCommandResultStatus)status message:(NSDictionary *)message {
    self = [super init];
    if (self) {
        self.status = status;
        self.message = message;
    }
    return self;
}

+ (instancetype)resultWithStatus:(TPJsCommandResultStatus)status message:(NSDictionary *)message {
    return [[self alloc] initWithStatus:status message:message];
}

- (NSString *)toJsonString {
    NSMutableDictionary *result = [NSMutableDictionary new];
    result[kTPJsBridgeResultStatusKey] = @(self.status);
    result[kTPJsBridgeResultMessageKey] = self.message;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *resultString = nil;
    if (error != nil) {
        TPJsBridgeLog(@"toJSONString error: %@", error);
    } else {
        resultString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return resultString;
}

@end
