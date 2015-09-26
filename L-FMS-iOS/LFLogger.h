//
//  LFLogger.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef L_FMS_iOS_LFLogger_h
#define L_FMS_iOS_LFLogger_h

#ifdef DEBUG
#   define QYDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define QYDebugLog(...)
#endif


#endif
