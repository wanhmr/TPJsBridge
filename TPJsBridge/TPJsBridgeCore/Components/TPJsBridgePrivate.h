//
//  TPJsBridgePrivate.h
//  Pods
//
//  Created by Tpphha on 2017/8/4.
//
//

#ifndef TPJsBridgePrivate_h
#define TPJsBridgePrivate_h
#import "TPJsConfiguration.h"
#import "TPJsPluginResultEmitter.h"
#import "TPJsPlugin.h"

@interface TPJsConfiguration (TPJsPrivate)
@property (nonatomic, weak) TPJsService *service;
@end

@interface TPJsPluginResultEmitter (QLJsPrivate)
@property (nonatomic, weak) TPJsService *service;
@end


@interface TPJsPlugin (QLJsPrivate)
@property (nonatomic, weak) TPJsService *service;
@end

#endif /* TPJsBridgePrivate_h */
