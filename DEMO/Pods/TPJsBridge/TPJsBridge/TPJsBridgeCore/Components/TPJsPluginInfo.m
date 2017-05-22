//
//  TPJsPluginInfo.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsPluginInfo.h"


@interface TPJsPluginInfo ()
@property (nonatomic, copy) NSString *pName;
@property (nonatomic, assign) Class pClass;
@property (nonatomic, copy) NSDictionary *pExports;

@end

@implementation TPJsPluginInfo {
    TPJsPlugin *_pInstance;
}

- (instancetype)initWithName:(NSString *)pName class:(Class)pClass exports:(NSDictionary<NSString *, NSString *> *)pExports {
    if (self = [super init]) {
        self.pName = pName;
        self.pClass = pClass;
        self.pExports = pExports;
    }
    return self;
}


- (TPJsPlugin *)pInstance {
    if (!_pInstance) {
        _pInstance = [[self.pClass alloc] init];
    }
    return _pInstance;
}


@end

