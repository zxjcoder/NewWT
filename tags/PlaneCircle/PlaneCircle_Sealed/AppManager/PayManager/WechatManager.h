//
//  WechatManager.h
//  SosoBand
//
//  Created by Daniel on 15/7/6.
//  Copyright (c) 2015年 SSB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
#import "WXApi.h"

@interface WechatManager : NSObject

/**
 *  生成微信支付认证
 *  @param orderNo 订单编号
 *  @param outTradeNo 商户订单号
 *  @param orderName 订单名称
 *  @param orderDesc 订单描述
 *  @param orderPrice 订单价格
 *  @result successBlock 成功回调函数
 *  @result resultBlock 订单重复回调函数
 *  @result errorBlock 失败回调函数
 */
+(void)sendPayWithOrderNo:(NSString*)orderNo outTradeNo:(NSString*)outTradeNo OrderName:(NSString*)orderName orderDesc:(NSString*)orderDesc orderPrice:(NSString*)orderPrice successBlock:(void(^)(NSDictionary *result))successBlock resultBlock:(void(^)(NSString *msg))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发起微信支付
 *  @param signParams 生成证书之后的参数对象
 */
+(void)sendPayWithDictionary:(NSDictionary*)signParams;

@end
