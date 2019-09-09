//
//  PushManager.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "PushManager.h"
#import "Utils.h"
#import "SQLiteOper.h"
#import "AppDelegate.h"

@implementation PushManager

/**
 *  设置推送内容
 *  @param  接收内容
 */
+(void)setPushContentWithUserInfo:(NSDictionary*)userInfo
{
    GBLog(@"setPushContentWithUserInfo: %@", userInfo);
    if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
        id customData = [userInfo objectForKey:@"custom"];
        NSDictionary *dicCustom = nil;
        if (customData && [customData isKindOfClass:[NSDictionary class]]) {
            dicCustom = (NSDictionary *)customData;
        } else if (customData && [customData isKindOfClass:[NSString class]]) {
            dicCustom = [NSJSONSerialization JSONObjectWithData:[customData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }
        if (dicCustom && [dicCustom isKindOfClass:[NSDictionary class]]) {
            NSString *type = [dicCustom objectForKey:@"type"];
            if (type && type.integerValue >= 0) {
                NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
                [dicParam setObject:type forKey:@"type"];
                NSString *title = [dicCustom objectForKey:@"title"];
                if (title) {
                    [dicParam setObject:title forKey:@"title"];
                }
                NSString *ids = [dicCustom objectForKey:@"id"];
                if (ids) {
                    [dicParam setObject:ids forKey:@"ids"];
                }
                NSString *aid = [dicCustom objectForKey:@"aid"];
                if (aid) {
                    [dicParam setObject:aid forKey:@"aid"];
                }
                NSString *url = [dicCustom objectForKey:@"url"];
                if (url) {
                    [dicParam setObject:url forKey:@"url"];
                }
                NSError *err;
                NSData *dataParam = [NSJSONSerialization dataWithJSONObject:dicParam options:(NSJSONWritingPrettyPrinted) error:&err];
                if (dataParam && dataParam.length > 0) {
                    NSString *strParam = [[NSString alloc] initWithData:dataParam encoding:(NSUTF8StringEncoding)];
                    [sqlite setSysParam:kSQLITE_LAST_PUSHDATA value:strParam];
                }
                if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
                    [[AppDelegate getTabBarVC] setShowViewControllerWithParam:dicParam];
                }
            }
        }
    }
}

/**
 *  设置推送对应模块的页面
 *  @param  url URL地址
 */
+(void)setPushViewControllerWithUrl:(NSURL *)url
{
    if ([url.host isEqualToString:kMy_AppScheme_Host]) {
        NSString *type = [Utils getParamValueFromUrl:url.absoluteString paramName:@"type"];
        NSString *ids = [Utils getParamValueFromUrl:url.absoluteString paramName:@"id"];
        if (type && type.integerValue >= 0 && ids) {
            NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
            NSString *aid = [Utils getParamValueFromUrl:url.absoluteString paramName:@"aid"];
            [dicParam setObject:type forKey:@"type"];
            if (ids) {
                [dicParam setObject:ids forKey:@"ids"];
            }
            if (aid) {
                [dicParam setObject:aid forKey:@"aid"];
            }
            NSString *urlValue = [Utils getParamValueFromUrl:url.absoluteString paramName:@"url"];
            if (urlValue) {
                [dicParam setObject:urlValue forKey:@"url"];
            }
            NSString *title = [Utils getParamValueFromUrl:url.absoluteString paramName:@"title"];
            if (title) {
                [dicParam setObject:title forKey:@"title"];
            }
            NSError *err;
            NSData *dataParam = [NSJSONSerialization dataWithJSONObject:dicParam options:(NSJSONWritingPrettyPrinted) error:&err];
            if (dataParam && dataParam.length > 0) {
                [sqlite setSysParam:kSQLITE_LAST_PUSHDATA value:[[NSString alloc] initWithData:dataParam encoding:(NSUTF8StringEncoding)]];
            }
            if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
                [[AppDelegate getTabBarVC] setShowViewControllerWithParam:dicParam];
            }
        }
    }
}

/**
 *  获取上次弹出的内容
 */
+(NSDictionary *)getPushViewControllerLastUrlParam
{
    NSString *strUrl = [sqlite getSysParamWithKey:kSQLITE_LAST_SHOWVCURL];
    if (strUrl) {
        NSURL *url = [NSURL URLWithString:strUrl];
        if (url && [url.host isEqualToString:kMy_AppScheme_Host]) {
            
            NSString *type = [Utils getParamValueFromUrl:url.absoluteString paramName:@"type"];
            NSString *ids = [Utils getParamValueFromUrl:url.absoluteString paramName:@"id"];
            if (type && [type integerValue] <= WTOpenParamTypeMax && ids) {
                NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
                NSString *aid = [Utils getParamValueFromUrl:url.absoluteString paramName:@"aid"];
                [dicParam setObject:type forKey:@"type"];
                if (ids) {
                    [dicParam setObject:ids forKey:@"ids"];
                }
                if (aid) {
                    [dicParam setObject:aid forKey:@"aid"];
                }
                NSString *urlValue = [Utils getParamValueFromUrl:url.absoluteString paramName:@"url"];
                if (urlValue) {
                    [dicParam setObject:urlValue forKey:@"url"];
                }
                NSString *title = [Utils getParamValueFromUrl:url.absoluteString paramName:@"title"];
                if (title) {
                    [dicParam setObject:title forKey:@"title"];
                }
                return dicParam;
            }
        }
    }
    return nil;
}

@end
