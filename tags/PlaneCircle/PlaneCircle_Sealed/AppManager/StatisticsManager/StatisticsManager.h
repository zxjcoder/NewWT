//
//  StatisticsManager.h
//  PlaneCircle
//
//  Created by Daniel on 9/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsManager : NSObject

///开始页面访问
+(void)beginRecordPage:(NSString *)name;
///结束页面访问
+(void)endRecordPage:(NSString *)name;

///注册事件
+(void)event:(NSString *)key category:(NSString *)category;
///注册事件
+(void)event:(NSString *)key category:(NSString *)category dictionary:(NSDictionary*)dictionary;
///注册计算事件
+(void)event:(NSString*)key category:(NSString*)category value:(long)value dictionary:(NSDictionary*)dictionary;

@end
