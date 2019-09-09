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

@implementation PushManager

/**
 *  设置推送内容
 *  @param  接收内容
 */
+(void)setPushContentWithUserInfo:(NSDictionary*)userInfo
{
    GBLog(@"setPushContentWithUserInfo: %@",userInfo);
}

/**
 *  设置推送对应模块的页面
 *  @param  URL地址
 */
+(void)setPushViewControllerWithUrl:(NSURL *)url
{
    GBLog(@"setPushViewControllerWithUrl: %@",url.absoluteString);
    if ([url.host isEqualToString:kMy_AppScheme_Host]) {
        NSString *type = [Utils getParamValueFromUrl:url.absoluteString paramName:@"type"];
        NSString *ids = [Utils getParamValueFromUrl:url.absoluteString paramName:@"id"];
        if (type && [type integerValue] <= WTOpenParamTypeRankLawyer && ids) {
            NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
            NSString *aid = [Utils getParamValueFromUrl:url.absoluteString paramName:@"aid"];
            [dicParam setObject:type forKey:@"type"];
            if (ids) {
                [dicParam setObject:ids forKey:@"ids"];
            }
            if (aid) {
                [dicParam setObject:aid forKey:@"aid"];
            }
            GCDAfterBlock(0.5, ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:ZShowViewControllerNotification object:dicParam];
            });
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
            if (type && [type integerValue] <= WTOpenParamTypeRankLawyer && ids) {
                NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
                NSString *aid = [Utils getParamValueFromUrl:url.absoluteString paramName:@"aid"];
                [dicParam setObject:type forKey:@"type"];
                if (ids) {
                    [dicParam setObject:ids forKey:@"ids"];
                }
                if (aid) {
                    [dicParam setObject:aid forKey:@"aid"];
                }
                return dicParam;
            }
        }
    }
    return nil;
}

@end
