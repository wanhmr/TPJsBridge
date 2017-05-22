//
//  TPJsCommandDelegate.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPJsPluginResult;
@class TPJsService;

@protocol TPJsCommandDelegate <NSObject>

- (void)sendPluginResult:(TPJsPluginResult *)result callbackId:(NSString *)callbackId;

@end

@interface TPJsCommandDelegateImpl : NSObject <TPJsCommandDelegate>

- (instancetype)initWithService:(TPJsService *)service;

@end
