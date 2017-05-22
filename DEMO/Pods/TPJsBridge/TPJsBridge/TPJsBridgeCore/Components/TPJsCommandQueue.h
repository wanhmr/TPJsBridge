//
//  TPJsCommandQueue.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TPJsInvokedUrlCommand;
@class TPJsService;

@interface TPJsCommandQueue : NSObject

- (instancetype)initWithService:(TPJsService *)servie;

- (void)excuteCommand:(TPJsInvokedUrlCommand *)command;

@end
