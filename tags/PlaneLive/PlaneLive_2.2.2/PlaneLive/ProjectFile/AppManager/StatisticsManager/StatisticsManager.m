//
//  StatisticsManager.m
//  PlaneCircle
//
//  Created by Daniel on 9/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "StatisticsManager.h"
#import <UMMobClick/MobClick.h>

@implementation StatisticsManager

///开始页面访问
+(void)beginRecordPage:(NSString *)name
{
    [MobClick beginLogPageView:name];
}
///结束页面访问
+(void)endRecordPage:(NSString *)name
{
    [MobClick endLogPageView:name];
}
///注册事件
+(void)event:(NSString *)key;
{
    [MobClick event:key];
}
///注册事件
+(void)event:(NSString *)key dictionary:(NSDictionary*)dictionary
{
    [MobClick event:key attributes:dictionary];
}
///注册计算事件
+(void)event:(NSString*)key value:(long)value
{
    [MobClick event:key durations:(int)value];
}
///注册计算事件
+(void)event:(NSString*)key value:(long)value dictionary:(NSDictionary*)dictionary
{
    [MobClick event:key attributes:dictionary durations:(int)value];
}

@end
