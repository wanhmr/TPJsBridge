//
//  TPJsConfigFileParser.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/21.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsConfigParser.h"
#import "NSBundle+TPJsBridge.h"

#define kDefaultConfigFileName @"TPJsBridgeConfig.json"

@interface TPJsConfigParser ()
@property (nonatomic, copy) NSString *configFilePath;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSArray<NSDictionary *> *plugins;
@property (nonatomic, copy) NSString *apiBuildUpdateUrl;
@end

@implementation TPJsConfigParser

- (instancetype)initWithConfigFilePath:(NSString *)configFilePath {
    if (self = [super init]) {
        self.configFilePath = configFilePath;
        [self parseConfigFile];
    }
    return self;
}

- (void)parseConfigFile {
    if (!self.configFilePath || self.configFilePath.length == 0) {
        self.configFilePath = [[NSBundle tp_jsBridgeBundle] pathForResource:kDefaultConfigFileName
                                                                     ofType:nil];
    }
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:self.configFilePath] options:NSJSONReadingMutableContainers error:nil];
    self.scheme = config[@"scheme"];
    self.plugins = config[@"plugins"];
    self.apiBuildUpdateUrl = config[@"apiBuildFileUpdateUrl"];
}

@end
