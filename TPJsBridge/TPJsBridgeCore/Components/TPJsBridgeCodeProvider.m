//
//  TPJsBridgeCodeManager.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "TPJsBridgeCodeProvider.h"
#import "TPJsBridgeMacro.h"
#import "NSBundle+TPJsBridge.h"
#import "TPJsService.h"
#import "TPJsBridgeConst.h"

#define kDefaultJsBridgeCoreFileName @"TPJsBridge.js"
#define kDefaultJsBridgeApiBulidFileName @"TPJsBridgeApiBuild.js"

@interface TPJsBridgeCodeProvider ()
@property (nonatomic, copy) NSString *jsBridgeCoreCode;
@property (nonatomic, copy) NSString *jsBridgeApiBuildCode;
@property (nonatomic, copy) NSString *apiBuildFilePath;
@property (nonatomic, assign) BOOL apiBuildFileUpdated;
@property (nonatomic, copy) NSURL *apiBuildFileUpdateUrl;
@property (nonatomic, copy) NSString *scheme;
@end

@implementation TPJsBridgeCodeProvider

- (instancetype)initWithJsBridgeScheme:(NSString *)scheme apiBuildFilePath:(NSString *)apiBuildFilePath apiBuildFileUpdateUrl:(NSURL *)apiBuildFileUpdateUrl {
    self = [super init];
    if (self) {
        self.scheme = scheme;
        self.apiBuildFilePath = apiBuildFilePath;
        if (apiBuildFilePath && apiBuildFilePath.length != 0) {
            self.apiBuildFilePath = apiBuildFilePath;
        }else {
            NSString *path = [[NSBundle tp_jsBridgeBundle] pathForResource:kDefaultJsBridgeApiBulidFileName ofType:nil];
            self.apiBuildFilePath = path;
        }
        [self updateJsBridgeCode];
    }
    return self;
}


- (void)updateJsBridgeCode {
    if (self.apiBuildFileUpdated || !self.apiBuildFileUpdateUrl) return;
    
    [[NSURLSession sharedSession] downloadTaskWithURL:self.apiBuildFileUpdateUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *cachePathForJsBridgeCoreFile = [self cachePathForJsBridgeApiBuildFile];
            NSError *fileError;
            [[NSFileManager defaultManager] removeItemAtPath:cachePathForJsBridgeCoreFile error:&fileError];
            if (!fileError) {
                NSURL *cacheFileUrl = [NSURL fileURLWithPath:cachePathForJsBridgeCoreFile isDirectory:NO];
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:cacheFileUrl error:&fileError];
                
                if (!fileError) {
                    self.apiBuildFileUpdated = YES;
                    self.apiBuildFilePath = cachePathForJsBridgeCoreFile;
                }else {
                    TPJsBridgeLog(@"move file error: %@", fileError);
                }
                
            }else {
                TPJsBridgeLog(@"remove file error: %@", fileError);
            }
            
        }else {
            TPJsBridgeLog(@"update plugin config file error: %@", error);
        }
    }];
}

- (NSString *)jsBridgeCode {
    NSString *core = [self jsBridgeCoreCode];
    NSString *apiBuild = [self jsBridgeApiBuildCode];
    if (apiBuild) {
         return [core stringByAppendingString:apiBuild];
    }else {
        return core;
    }
   
}

#pragma mark - setter & getter
- (void)setapiBuildFileUpdated:(BOOL)apiBuildFileUpdated {
    _apiBuildFileUpdated = apiBuildFileUpdated;
    if (apiBuildFileUpdated) {
        self.jsBridgeApiBuildCode = nil;
    }
}

- (NSString *)jsBridgeCoreCode {
    if (!_jsBridgeCoreCode) {
        NSString *path = [[NSBundle tp_jsBridgeBundle] pathForResource:kDefaultJsBridgeCoreFileName ofType:nil];
        _jsBridgeCoreCode = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil];
        _jsBridgeCoreCode = [_jsBridgeCoreCode stringByReplacingOccurrencesOfString:KTPJsBridgeSchemeToken withString:self.scheme];
    }
    return _jsBridgeCoreCode;
}

- (NSString *)jsBridgeApiBuildCode {
    if (!_jsBridgeApiBuildCode) {
        BOOL hasFilePath = [[NSFileManager defaultManager] fileExistsAtPath:self.apiBuildFilePath];
        if (hasFilePath) {
            _jsBridgeApiBuildCode = [NSString stringWithContentsOfFile:self.apiBuildFilePath
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
        }else {
            TPJsBridgeLog(@"jsBridge file is empty");
        }
    }
    return _jsBridgeApiBuildCode;
}

#pragma mark - utilities
- (NSString *)cachePathForJsBridgeApiBuildFile {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *jsBridgePath = [cachePath stringByAppendingPathComponent:[self.scheme stringByAppendingString:@"_jsbridge"]];
    NSError *fileError;
    [[NSFileManager defaultManager] createDirectoryAtPath:jsBridgePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&fileError];
    if (!fileError) {
        return [jsBridgePath stringByAppendingPathComponent:kDefaultJsBridgeApiBulidFileName];
    }else {
        TPJsBridgeLog(@"create directory error: %@", fileError);
        return nil;
    }
    
}


@end
