//
//  LDJSPluginManager.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TPJsPlugin;
@class TPJsService;

@interface TPJsPluginManager : NSObject
- (instancetype)initWithService:(TPJsService *)service plugins:(NSArray<NSDictionary *> *)plugins;

- (TPJsPlugin *)getPluginWithName:(NSString *)pName;

- (NSString *)getPluginRealMethodWithName:(NSString *)pName provideMethodName:(NSString *)provideMethodName;
@end
