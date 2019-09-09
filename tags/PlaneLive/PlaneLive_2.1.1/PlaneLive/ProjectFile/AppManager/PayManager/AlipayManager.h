//
//  AlipayManager.h
//  SosoBand
//
//  Created by Daniel.ZWW on 15/6/5.
//  Copyright (c) 2015年 SSB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelEntity.h"

typedef NS_ENUM(NSInteger, AlipayOrderStatus)
{
    AlipayOrderStatusSuccess = 9000,//订单支付成功
    AlipayOrderStatusHandling = 8000,//正在处理中
    AlipayOrderStatusFailure = 4000,//订单支付失败
    AlipayOrderStatusCancel = 6001,//用户中途取消
    AlipayOrderStatusConnect = 6002,//网络连接出错
};

@interface AlipayManager : NSObject

/**
 *  支付宝付款
 *  @param orderDescription ModelOrderALI对象转换成JSON字符串
 *  @param completionBlock 支付结果回调函数
 *  @param errorBlock  调用支付宝失败的回调函数
 */
+(void)payOrderWithOrderDescription:(NSString*)orderDescription completionBlock:(void(^)(ModelOrderALIResult *result))completionBlock errorBlock:(void(^)(void))errorBlock;

/**
 *  支付宝付款
 *  @param orderString 生成认证之后的订单字符串
 *  @param completionBlock 支付结果回调函数
 */
+(void)sendPayWithOrderString:(NSString*)orderString completionBlock:(void(^)(ModelOrderALIResult *result))completionBlock;

/**
 *  支付宝回调接口
 *  @param url 回调接口
 *  @param standbyCallback 返回支付回调函数
 */
+(void)processOrderWithPaymentResult:(NSURL*)url standbyCallback:(void(^)(ModelOrderALIResult *result))standbyCallback;

@end
