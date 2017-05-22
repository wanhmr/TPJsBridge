//
//  NSBundle+TPJsBridge.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "NSBundle+TPJsBridge.h"

@implementation NSBundle (TPJsBridge)
+ (instancetype)tp_jsBridgeBundle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TPJsBridge" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}
@end
