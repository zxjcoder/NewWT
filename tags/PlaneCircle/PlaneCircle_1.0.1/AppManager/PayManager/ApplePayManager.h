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

#define kProductsLoadedNotification         @"ZProductsLoadedNotification"
#define kProductPurchasedNotification       @"ZProductPurchasedNotification"
#define kProductPurchaseFailedNotification  @"ZProductPurchaseFailedNotification"

///苹果支付管理类
@interface ApplePayManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSSet * _productIdentifiers;
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
}

///初始化
+ (ApplePayManager *) sharedHelper;

///需要获取的本地商品ID
@property (retain, nonatomic) NSSet *productIdentifiers;
///获取苹果服务器的商品集合
@property (retain, nonatomic) NSArray * products;
///已经购买过的商品
@property (retain, nonatomic) NSMutableSet *purchasedProducts;
///请求苹果服务器商品集合对象
@property (retain, nonatomic) SKProductsRequest *request;

///请求苹果服务器商品集合
- (void)requestProducts;
///发起购买商品
- (void)buyProductIdentifier:(SKProduct *)product;
///释放交易对象
- (void)dismiss;

@end
