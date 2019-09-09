//
//  ApplePayManager.m
//  Project
//
//  Created by Daniel on 16/1/5.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "ApplePayManager.h"
#import "SQLiteOper.h"

//苹果支付商品ID->Key
#define kApplePay_ProduceKey @"com.dreams9.huhu5."
//共享密钥
#define kApplePay_ShareKey @"5a4392e3dfb2420d8b6b6a7859cd0a4f"

@implementation ApplePayManager

static ApplePayManager * _sharedHelper;

@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

+ (ApplePayManager *) sharedHelper
{
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[ApplePayManager alloc] init];
    return _sharedHelper;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    NSArray *arrMoney = [sqlite getLocalPlayMoney];
    NSMutableArray *arrIdentifiers = [NSMutableArray array];
    NSMutableSet * purchasedProducts = [NSMutableSet set];
    for (NSString *money in arrMoney) {
        NSString *productIdentifier = [NSString stringWithFormat:@"%@%@",kApplePay_ProduceKey,money];
        [arrIdentifiers addObject:productIdentifier];
        
        [purchasedProducts addObject:productIdentifier];
    }
    _productIdentifiers = [NSSet setWithArray:arrIdentifiers];
    self.purchasedProducts = purchasedProducts;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)requestProducts
{
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    self.request.delegate = self;
    [self.request start];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    GBLog(@"recordTransaction...");
}

- (void)provideContent:(SKPaymentTransaction *)transaction
{
    GBLog(@"provideContent productIdentifier: %@", transaction.payment.productIdentifier);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction];
}
///完成购买
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    GBLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
///恢复购买
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
     GBLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
///购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        GBLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
///发起购买
- (void)buyProductIdentifier:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)dismiss
{
    self.request.delegate = nil;
    OBJC_RELEASE(_productIdentifiers);
    OBJC_RELEASE(_products);
    OBJC_RELEASE(_purchasedProducts);
    OBJC_RELEASE(_request);
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)dealloc
{
    [self dismiss];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    GBLog(@"productsRequest didReceiveResponse...");

    NSArray *products = [NSArray arrayWithArray:response.products];
    request.delegate = nil;
    request = nil;
    self.request.delegate = nil;
    self.request = nil;
    if (products.count>0) {
        NSArray *arrProducts = [products sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES]]];
        self.products = [NSArray arrayWithArray:arrProducts];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:self.products];
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    GBLog(@"updatedTransactions...");

    for (SKPaymentTransaction *transaction in transactions) {
        GBLog(@"SKPaymentTransaction transactionState: %d",(int)transaction.transactionState);
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased: [self completeTransaction:transaction]; break;
            case SKPaymentTransactionStateFailed: [self failedTransaction:transaction]; break;
            case SKPaymentTransactionStateRestored: [self restoreTransaction:transaction]; break;
            default:break;
        }
    }
}

@end
