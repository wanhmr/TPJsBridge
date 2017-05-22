//
//  TPJsBridgeMacro.h
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#ifndef TPJsBridgeMacro_h
#define TPJsBridgeMacro_h

#ifdef DEBUG
#define TPJsBridgeLog(...) NSLog(__VA_ARGS__)
#else
#define TPJsBridgeLog(...)
#endif

#endif /* TPJsBridgeMacro_h */
