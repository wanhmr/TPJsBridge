//
//  LDJSPluginManager.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TPJsPlugin;

@interface TPJsPluginManager : NSObject
- (instancetype)initWithPlugins:(NSArray<NSDictionary *> *)plugins;

- (NSArray<TPJsPlugin *> *)getAllPlugins;

- (TPJsPlugin *)getPluginWithName:(NSString *)pName;


- (NSString *)getPluginRealMethodWithName:(NSString *)pName provideMethodName:(NSString *)provideMethodName;
@end
