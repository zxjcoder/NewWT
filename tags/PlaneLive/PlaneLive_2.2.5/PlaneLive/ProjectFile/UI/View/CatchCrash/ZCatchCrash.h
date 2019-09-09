//
//  ZCatchCrash.h
//  CatchCrash
//
//  Created by Daniel on 4/7/16.
//  Copyright © 2016 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCatchCrash : NSObject

///设置监听崩溃日志
+ (void)setDefaultHandler;

///获取日志信息
+ (NSString *)getCatchCrashErrorData;

///删除日志信息
+ (void)delCatchCrashErrorData;

@end
