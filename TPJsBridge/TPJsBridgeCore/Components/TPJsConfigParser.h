//
//  TPJsConfigFileParser.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/21.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPJsConfigParser : NSObject
@property (nonatomic, readonly) NSString *scheme;
@property (nonatomic, readonly) NSString *jsBridgeDidReadyEventName;
@property (nonatomic, readonly) NSArray<NSDictionary *> *plugins;
@property (nonatomic, readonly) NSString *apiBuildUpdateUrl;

- (instancetype)initWithConfigFilePath:(NSString *)configFilePath;
@end
