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
+(void)event:(NSString *)key;
///注册计算事件
+(void)event:(NSString*)key value:(long)value;
///注册事件
+(void)event:(NSString *)key dictionary:(NSDictionary*)dictionary;
///注册计算事件
+(void)event:(NSString*)key value:(long)value dictionary:(NSDictionary*)dictionary;

/// 诸葛IO用户存储
+(void)eventIOUserInfo;
/// 诸葛IO用户刷新
+(void)eventIORefreshUserInfo;
/// 诸葛IO用户参数
+(NSMutableDictionary *)getIOUserInfoParams;
/// 诸葛IO自定义事件
+(void)eventIOTrackWithKey:(NSString *)key dictionary:(NSDictionary *)dictionary;
/// 诸葛IO自定义事件
+(void)eventIOTrackWithKey:(NSString *)key
                     title:(NSString *)title
                      type:(NSString *)type
                      name:(NSString *)name
                      team:(NSString *)team
                   paytype:(NSString *)paytype
                     price:(NSString *)price;

/// 诸葛IO事件时长开始
+(void)eventIOBeginPageWithName:(NSString *)title;
/// 诸葛IO事件时长结束
+(void)eventIOEndPageWithName:(NSString *)title dictionary:(NSDictionary *)dictionary;

@end
