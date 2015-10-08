//
//  LFCommonDefine.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef L_FMS_iOS_LFCommonDefine_h
#define L_FMS_iOS_LFCommonDefine_h

#define LFWEAKSELF  typeof(self) __weak weakSelf=self ;

#import "LFLogger.h"

#define LFRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LFRGB(r,g,b) LFRGBA(r,g,b,1.0)

#endif
