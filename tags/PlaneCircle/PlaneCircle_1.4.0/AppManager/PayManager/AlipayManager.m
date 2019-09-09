//
//  AlipayManager.m
//  SosoBand
//
//  Created by Daniel.ZWW on 15/6/5.
//  Copyright (c) 2015年 SSB. All rights reserved.
//

#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Utils.h"

@implementation AlipayManager

/**
 *  支付宝付款
 *  @param orderDescription ModelOrderALI对象转换成JSON字符串
 *  @result completionBlock 支付结果回调函数
 *  @result errorBlock  调用支付宝失败的回调函数
 */
+(void)payOrderWithOrderDescription:(NSString*)orderDescription completionBlock:(void(^)(ModelOrderALIResult *result))completionBlock errorBlock:(void(^)(void))errorBlock
{
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = [CreateRSADataSigner(kALI_Private_Key) signString:orderDescription];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString != nil) {
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderDescription, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:kALI_AppScheme callback:^(NSDictionary *resultDic) {
            completionBlock([[ModelOrderALIResult alloc] initWithCustom:resultDic]);
        }];
    } else {
        errorBlock();
    }
}

/**
 *  支付宝付款
 *  @param orderString 生成认证之后的订单字符串
 *  @result completionBlock 支付结果回调函数
 */
+(void)sendPayWithOrderString:(NSString*)orderString completionBlock:(void(^)(ModelOrderALIResult *result))completionBlock
{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kALI_AppScheme callback:^(NSDictionary *resultDic) {
        completionBlock([[ModelOrderALIResult alloc] initWithCustom:resultDic]);
    }];
}

/**
 *  支付宝回调接口
 *  @param url 回调接口
 *  @result standbyCallback 返回支付回调函数
 */
+(void)processOrderWithPaymentResult:(NSURL*)url standbyCallback:(void(^)(ModelOrderALIResult *result))standbyCallback
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        standbyCallback([[ModelOrderALIResult alloc] initWithCustom:resultDic]);
    }];
}

@end
