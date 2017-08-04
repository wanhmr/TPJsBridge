//
//  TPJsConfiguration.h
//  Pods
//
//  Created by Tpphha on 2017/8/4.
//
//

#import <Foundation/Foundation.h>
@class TPJsPluginResultEmitter;
@class TPJsPluginManager;
@class TPJsBridgeCodeProvider;

NS_ASSUME_NONNULL_BEGIN

@interface TPJsConfiguration : NSObject
@property (nonatomic, strong) TPJsPluginResultEmitter *pluginResultEmitter;
@property (nonatomic, strong) TPJsPluginManager *pluginManager;
@property (nonatomic, strong) TPJsBridgeCodeProvider *jsBridgeCodeProvider;

- (instancetype)initWithConfigFilePath:(nullable NSString *)configFilePath apiBuildFilePath:(nullable NSString *)apiBuildFilePath;
@end

NS_ASSUME_NONNULL_END
