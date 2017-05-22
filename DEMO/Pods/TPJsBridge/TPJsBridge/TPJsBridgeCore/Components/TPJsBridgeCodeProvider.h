//
//  TPJsBridgeCodeManager.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPJsBridgeCodeProvider : NSObject
@property (nonatomic, readonly) NSString *scheme;

- (instancetype)initWithJsBridgeScheme:(NSString *)scheme apiBuildFilePath:(NSString *)apiBuildfilePath apiBuildFileUpdateUrl:(NSURL *)apiBuildFileUpdateUrl;

- (NSString *)jsBridgeCode;
@end
