//
//  TPJsConfigFileParser.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/21.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsConfigParser.h"
#import "NSBundle+TPJsBridge.h"
#import "TPJsBridgeConst.h"

static NSString* const kTPJsConfigDefaultConfigFileName = @"TPJsBridgeConfig.json";

@interface TPJsConfigParser ()
@property (nonatomic, copy) NSString *configFilePath;
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
    if (self.configFilePath.length == 0) {
        self.configFilePath =
        [[NSBundle tp_jsBridgeBundle] pathForResource:kTPJsConfigDefaultConfigFileName
                                               ofType:nil];
    }
    NSDictionary *config =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:self.configFilePath]
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
    _scheme = config[kTPJsBridgeSchemeKey];
    _plugins = config[kTPJsBridgePluginsKey];
    _apiBuildUpdateUrl = config[kTPJsBridgeApiBuildFileUpdateUrlKey];
    
    if (_scheme.length == 0) {
        _scheme = @"TPJsBridge";
    }
    
}

@end
