//
//  ApplePayManager.h
//  Project
//
//  Created by Daniel on 16/1/5.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>

//苹果支付商品ID->Key
#define kApplePay_ProduceKey @"com.wutongsx.money."

///苹果支付管理类
@interface ApplePayManager : NSObject

///初始化
+ (ApplePayManager *) sharedHelper;

///支付结果
@property (copy, nonatomic) void(^onBuyProductResult)(SKPaymentTransaction *payment);
///请求集合回调
@property (copy, nonatomic) void(^onRequestState)(NSString *errorMsg);

///请求苹果服务器商品
- (void)requestProductPrice:(NSString *)price;
///发起购买商品
- (void)sendBuyProductIdentifier:(SKProduct *)product;
///释放交易对象
- (void)dismiss;

@end
