//
//  NSString+TPJsBridge.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "NSString+TPJsBridge.h"

@implementation NSString (TPJsBridge)


#pragma mark URLEncoding

- (NSString *)tp_URLEncodedString
{
    static NSString *const unsafeChars = @"!*'\"();:@&=+$,/?%#[]% ";
    
#if !(__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9) && !(__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
    
    if (![self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)])
    {
        CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      (__bridge CFStringRef)self,
                                                                      NULL,
                                                                      (__bridge CFStringRef)unsafeChars,
                                                                      kCFStringEncodingUTF8);
        return (__bridge_transfer NSString *)encoded;
    }
    
#endif
    
    static NSCharacterSet *allowedChars;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSCharacterSet *disallowedChars = [NSCharacterSet characterSetWithCharactersInString:unsafeChars];
        allowedChars = [disallowedChars invertedSet];
    });
    
    return (NSString *)[self stringByAddingPercentEncodingWithAllowedCharacters:allowedChars];
}

- (NSString *)tp_URLDecodedString
{
    return [self tp_URLDecodedString:NO];
}

- (NSString *)tp_URLDecodedString:(BOOL)decodePlusAsSpace
{
    NSString *string = self;
    if (decodePlusAsSpace)
    {
        string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
#if !(__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9) && !(__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
    
    if (![self respondsToSelector:@selector(stringByRemovingPercentEncoding)])
    {
        return (NSString *)[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
#endif
    
    return (NSString *)[string stringByRemovingPercentEncoding];
}
@end
