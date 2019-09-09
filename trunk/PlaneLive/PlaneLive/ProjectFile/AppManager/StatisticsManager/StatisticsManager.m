//
//  StatisticsManager.m
//  PlaneCircle
//
//  Created by Daniel on 9/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "StatisticsManager.h"
#import <UMAnalytics/MobClick.h>
#import "AppSetting.h"
#import <Zhugeio/Zhuge.h>
#import "LocationManager.h"

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

/// 诸葛IO用户存储
+(void)eventIOUserInfo
{
    if ([AppSetting getAutoLogin] &&
        [AppSetting getUserId].length > 0 &&
        ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        
        [[Zhuge sharedInstance] identify:[AppSetting getUserId] properties:[StatisticsManager getIOUserInfoParams]];
    }
}
/// 诸葛IO用户刷新
+(void)eventIORefreshUserInfo
{
    if ([AppSetting getAutoLogin] &&
        [AppSetting getUserId].length > 0 &&
        ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        
        [[Zhuge sharedInstance] updateIdentify:[StatisticsManager getIOUserInfoParams]];
    }
}
/// 诸葛IO用户参数
+(NSMutableDictionary *)getIOUserInfoParams
{
    ModelUser *modelU = [AppSetting getUserLogin];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[kZhugeIOTypeKey] = kZhugeIONormalKey;
    NSString *sex = kEmpty;
    switch (modelU.sex) {
        case WTSexTypeFeMale: sex = kCFemale; break;
        case WTSexTypeMale: sex = kCMale; break;
        default: sex = kCGenderSecrecy; break;
    }
    dicParams[kCGender] = sex;
    dicParams[kCNickName] = modelU.nickname;
    NSString *userId = kEmpty;
    switch (modelU.type) {
        case WTAccountTypePhone: userId = modelU.phone; break;
        default: break;
    }
    dicParams[kZhugeIOUserIdKey] = userId == nil ? kEmpty: userId;
    NSString *country = [LocationManager sharedSingleton].country;
    dicParams[kZhugeIOCountryKey] = country == nil ? kEmpty: country;
    NSString *province = [LocationManager sharedSingleton].province;
    dicParams[kZhugeIOProvinceKey] = province == nil ? kEmpty: province;
    NSString *city = [LocationManager sharedSingleton].city;
    dicParams[kZhugeIOCityKey] = city == nil ? kEmpty: city;
    NSString *district = [LocationManager sharedSingleton].district;
    dicParams[kZhugeIODistrictKey] = district == nil ? kEmpty: district;
    dicParams[kZhugeIODeviceTypeKey] = [[UIDevice currentDevice] getDeviceName];
    
    return dicParams;
}
/// 诸葛IO自定义事件
+(void)eventIOTrackWithKey:(NSString *)key dictionary:(NSDictionary *)dictionary
{
    [[Zhuge sharedInstance] track:key properties:dictionary];
}

/// 诸葛IO自定义事件
+(void)eventIOTrackWithKey:(NSString *)key
                     title:(NSString *)title
                      type:(NSString *)type
                      name:(NSString *)name
                      team:(NSString *)team
                   paytype:(NSString *)paytype
                     price:(NSString *)price
{
    if ([AppSetting getAutoLogin] &&
        [AppSetting getUserId].length > 0 &&
        ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
        [dicParams setObject:title == nil ? kEmpty : title forKey:kZhugeIOCourseNameKey];
        [dicParams setObject:type == nil ? kEmpty : type forKey:kZhugeIOCourseTypeKey];
        [dicParams setObject:name == nil ? kEmpty : name forKey:kZhugeIOLecturerNameKey];
        [dicParams setObject:team == nil ? kEmpty : team forKey:kZhugeIOLecturerTitleKey];
        if (paytype) {
            [dicParams setObject:paytype forKey:kZhugeIOPayTypeKey];
        }
        [dicParams setObject:price == nil ? kEmpty : price forKey:kZhugeIOPriceKey];
        
        [[Zhuge sharedInstance] track:key properties:dicParams];
    }
}

/// 诸葛IO事件时长开始
+(void)eventIOBeginPageWithName:(NSString *)title
{
    if ([AppSetting getAutoLogin] &&
        [AppSetting getUserId].length > 0 &&
        ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        [[Zhuge sharedInstance] startTrack:title];
    }
}
/// 诸葛IO事件时长结束
+(void)eventIOEndPageWithName:(NSString *)title dictionary:(NSDictionary *)dictionary
{
    if ([AppSetting getAutoLogin] &&
        [AppSetting getUserId].length > 0 &&
        ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        [[Zhuge sharedInstance] endTrack:title properties:dictionary];
    }
}

@end
