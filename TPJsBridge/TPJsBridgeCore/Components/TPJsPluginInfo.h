//
//  TPJsPluginInfo.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TPJsPlugin;

@interface TPJsPluginInfo : NSObject

/**
 插件的名字
 */
@property (nonatomic, readonly) NSString *pName;

/**
 插件的类
 */
@property (nonatomic, readonly) Class pClass;

/**
 插件的方法输出：eg: "provideMethodName" : "realMethodName"
 provideMethodName: 是提供给使用者的方法名称
 realMethodName: 真实的方法名称
 */
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *pExports;

/**
 插件的实例对象
 */
@property (nonatomic, readonly) TPJsPlugin *pInstance;

- (instancetype)initWithName:(NSString *)pName class:(Class)pClass exports:(NSDictionary<NSString *, NSString *> *)pExports;
@end
