//
//  NSString+TPJsBridge.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TPJsBridge)
@property (nonatomic, readonly) NSString *tp_URLEncodedString;
@property (nonatomic, readonly) NSString *tp_URLDecodedString;

- (NSString *)tp_URLDecodedString:(BOOL)decodePlusAsSpace;

@end
