//
//  ZAccountBalanceViewController.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountBalanceViewController.h"
#import "ZAccountBalanceTableView.h"
#import "ApplePayManager.h"
#import "WechatManager.h"
#import "ZPlaySuccessView.h"

@interface ZAccountBalanceViewController ()

///主面板
@property (strong, nonatomic) ZAccountBalanceTableView *viewMain;
///生成的订单
@property (strong, nonatomic) ModelOrderWT *modelOrder;

@end

@implementation ZAccountBalanceViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kTheBalanceOfTheAccount];
    
    [self innerInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewMain);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.viewMain = [[ZAccountBalanceTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.viewMain setOnRechargeClick:^(NSString *money) {
        [ZProgressHUD showMessage:kCMsgRecharging];
      
        NSString *title = [NSString stringWithFormat:@"%@-%@", APP_PROJECT_NAME, kRecharge];
        [snsV2 getGenerateOrderWithMoney:money type:WTPayTypeRecharge objid:nil title:title payType:(WTPayWayTypeApplePay) resultBlock:^(ModelOrderWT *model, id resultThree, NSDictionary *result) {
            
            [weakSelf sendPayAppleWithOrderModel:model];
        } errorBlock:^(NSString *msg) {
            [ZProgressHUD dismiss];
            [ZAlertView showWithMessage:msg];
        } balanceBlock:nil];
    }];
    
    ModelUser *modelUser = [AppSetting getUserLogin];
    [self.viewMain setBalanceValue:[NSString stringWithFormat:@"%.2f", modelUser.balance]];
    
    [self.view addSubview:self.viewMain];
    
    [super innerInit];
    
    [self innerData];
}
///初始化数据
-(void)innerData
{
    NSArray *arrOrder =  [sqlite getLocalOrderDetailWithUserId:[AppSetting getUserDetauleId] status:0];
    if (arrOrder && arrOrder.count > 0) {
        NSMutableArray *arrOrderId = [NSMutableArray array];
        for (ModelOrderWT *modelO in arrOrder) {
            [arrOrderId addObject:modelO.order_no];
        }
        [snsV2 updOrderStateWithOrderIds:arrOrderId resultBlock:^(NSDictionary *result) {
            
            [sqlite updLocalOrderDetailWithOrderIds:arrOrderId];
        } errorBlock:nil];
    }
}
///向苹果发起支付
-(void)sendPayAppleWithOrderModel:(ModelOrderWT *)model
{
    ZWEAKSELF
    [weakSelf setModelOrder:model];
    
    ///向苹果发起支付请求
    ApplePayManager *payManager = [ApplePayManager sharedHelper];
    [payManager requestProductPrice:model.price];
    ///请求数据回调
    [payManager setOnRequestState:^(NSString *errorMsg) {
        [ZProgressHUD dismiss];
        [ZAlertView showWithMessage:errorMsg];
    }];
    ///支付结果回调
    [payManager setOnBuyProductResult:^(SKPaymentTransaction *payMent) {
        switch (payMent.transactionState) {
            case SKPaymentTransactionStatePurchasing://购买中
                break;
            case SKPaymentTransactionStatePurchased://购买完成
            {
                ///修改订单状态
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    
                    ModelUser *modelU = [AppSetting getUserLogin];
                    modelU.balance += [model.price doubleValue];
                    
                    [AppSetting setUserLogin:modelU];
                    
                    [AppSetting save];
                    
                    [weakSelf.viewMain setBalanceValue:[NSString stringWithFormat:@"%.2f", modelU.balance]];
                    
                    if (weakSelf.preVC != nil) {
                        ZPlaySuccessView *playSuccessView = [[ZPlaySuccessView alloc] initWithType:1];
                        [playSuccessView setOnSubmitClick:^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        [playSuccessView show];
                    } else {
                        ZPlaySuccessView *playSuccessView = [[ZPlaySuccessView alloc] initWithType:0];
                        [playSuccessView show];
                    }
                } errorBlock:^(NSString *msg) {
                    [ZProgressHUD dismiss];
                    
                    [ZAlertView showWithMessage:msg];
                    
                    [sqlite setLocalOrderDetailWithModel:model userId:[AppSetting getUserDetauleId]];
                }];
                break;
            }
            case SKPaymentTransactionStateFailed://购买失败
            {
                [ZProgressHUD dismiss];
                [ZAlertView showWithMessage:kRequestApplePaymentFailed];
                break;
            }
            case SKPaymentTransactionStateRestored://恢复购买
                [ZProgressHUD dismiss];
                break;
            case SKPaymentTransactionStateDeferred://延迟购买
                [ZProgressHUD dismiss];
                break;
        }
    }];
}
///向微信发起支付
-(void)sendPayWeChatWithDictionary:(NSDictionary *)dic
{
    [ZProgressHUD dismiss];
    /*[WechatManager sendPayWithDictionary:dic resultBlock:^(bool isSuccess) {
        if (!isSuccess) {
            [ZProgressHUD showError:kRequestWeChatPaymentFailed];
        }
    }];*/
}
///向支付宝发起支付
-(void)sendPayAliWithDictionary:(NSString *)orderStr
{
    [ZProgressHUD dismiss];
    /*[AlipayManager sendPayWithOrderString:orderStr completionBlock:^(ModelOrderALIResult *result) {
        if (result.resultStatus == 4000) {
            [ZProgressHUD showError:kRequestWeChatPaymentFailed];
        }
    }];*/
}

@end
