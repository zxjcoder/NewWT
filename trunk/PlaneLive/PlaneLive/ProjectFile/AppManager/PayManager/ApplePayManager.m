//
//  ApplePayManager.m
//  Project
//
//  Created by Daniel on 16/1/5.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "ApplePayManager.h"
#import "SQLiteOper.h"

//共享密钥
#define kApplePay_ShareKey @"125a935bb6e64934b55dc19c99157e5e"

@interface ApplePayManager()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSSet * _productIdentifiers;
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
}

///需要获取的本地商品ID
@property (retain, nonatomic) NSSet *productIdentifiers;
///获取苹果服务器的商品集合
@property (retain, nonatomic) NSArray *products;
///已经购买过的商品
@property (retain, nonatomic) NSMutableSet *purchasedProducts;
///请求苹果服务器商品集合对象
@property (retain, nonatomic) SKProductsRequest *request;

@end

@implementation ApplePayManager

static ApplePayManager * _sharedApplePayHelper;

@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

+ (ApplePayManager *) sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedApplePayHelper = [[ApplePayManager alloc] init];
    });
    return _sharedApplePayHelper;
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
- (void)requestProductPrice:(NSString *)price;
{
    NSString *productId = [NSString stringWithFormat:@"%@%@",kApplePay_ProduceKey, price];
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
    self.request.delegate = self;
    [self.request start];
}
///记录交易
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    GBLog(@"recordTransaction...");
}
///完成购买
- (void)provideContent:(SKPaymentTransaction *)transaction
{
    GBLog(@"provideContent productIdentifier: %@", transaction.payment.productIdentifier);
    
    if (self.onBuyProductResult) {
        self.onBuyProductResult(transaction);
    }
}
///完成购买
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    GBLog(@"completeTransaction...");
    
    [self provideContent: transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
///恢复购买
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
     GBLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
///购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    GBLog(@"failedTransaction error: %@", transaction.error.localizedDescription);
    if (self.onBuyProductResult) {
        self.onBuyProductResult(transaction);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
///发起购买
- (void)sendBuyProductIdentifier:(SKProduct *)product
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
        
        [self sendBuyProductIdentifier:products.firstObject];
    } else {
        if (self.onRequestState) {
            self.onRequestState(kRequestApplePaymentTimeout);
        }
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    GBLog(@"productsRequest didFailWithError...");
    
    if (self.onRequestState) {
        self.onRequestState(error.localizedDescription);
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    GBLog(@"updatedTransactions...");

    for (SKPaymentTransaction *transaction in transactions) {
        //GBLog(@"SKPaymentTransaction transactionState: %d",(int)transaction.transactionState);
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
