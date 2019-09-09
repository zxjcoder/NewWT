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
#import "ZAccountBalanceAlertView.h"
#import "ZContactServiceViewController.h"
#import "ZWebViewController.h"

@interface ZAccountBalanceViewController ()

///主面板
@property (strong, nonatomic) ZAccountBalanceTableView *viewMain;
///生成的订单
@property (strong, nonatomic) ModelOrderWT *modelOrder;
///标题
@property (strong, nonatomic) ZLabel *lbTitleNav;
@property (assign, nonatomic) CGFloat navLastAlpha;

@end

@implementation ZAccountBalanceViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAlpha:0];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:false];
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageUserBalanceKey];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageUserBalanceKey dictionary:nil];
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
    self.lbTitleNav = [[UILabel alloc] initWithFrame:(CGRectMake(65, 0,APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT))];
    [self.lbTitleNav setTextColor:WHITECOLOR];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setFont:[UIFont boldSystemFontOfSize:kFont_Huge_Size]];
    [self.lbTitleNav setText:kTheBalanceOfTheAccount];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    
    ZWEAKSELF
    self.viewMain = [[ZAccountBalanceTableView alloc] initWithFrame:VIEW_MAIN_FRAME];
    self.viewMain.bounces = false;
    [self.viewMain setOnRechargeClick:^(NSString *money) {
        if ([AppSetting getAutoLogin]) {
            if ([[AppSetting getUserId] isEqualToString:kUserAuditId]) {
                ZAccountBalanceAlertView *alertView = [[ZAccountBalanceAlertView alloc] init];
                [alertView setOnLoginClick:^{
                    [weakSelf showLoginVC];
                }];
                [alertView setOnSubmitClick:^{
                    [weakSelf getOrderWithMoney:money];
                }];
                [alertView show];
            } else {
                [weakSelf getOrderWithMoney:money];
            }
        } else {
            [weakSelf showLoginVC];
        }
    }];
    [self.viewMain setOnLinkClick:^{
        NSString *weburl = [NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_RechargeGuideUrl];
        [weakSelf showWebVCWithUrl:weburl title:kRechargeProcessDescription];
    }];
    [self.viewMain setOnWeChatLinkClick:^{
        [weakSelf setContactServiceVC];
    }];
    [self.view addSubview:self.viewMain];
    
    [super innerInit];
    
    ModelUser *modelUser = [AppSetting getUserLogin];
    [self.viewMain setBalanceValue:[NSString stringWithFormat:@"%.2f", modelUser.balance]];
    [self innerData];
}
///初始化数据
-(void)innerData
{
    NSArray *arrOrder =  [sqlite getLocalOrderDetailWithUserId:kLoginUserId status:0];
    if (arrOrder && arrOrder.count > 0) {
        NSMutableArray *arrOrderId = [NSMutableArray array];
        for (ModelOrderWT *modelO in arrOrder) {
            [arrOrderId addObject:modelO.order_no];
        }
        [snsV2 updOrderStateWithOrderIds:arrOrderId resultBlock:^(NSDictionary *result) {
            
            [sqlite updLocalOrderDetailWithOrderIds:arrOrderId];
        } errorBlock:nil];
    }
    ZWEAKSELF
    [snsV1 postGetUserInfoWithUserId:kLoginUserId resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
        NSString *balance = [NSString stringWithFormat:@"%.2f", resultModel.balance];
        [AppSetting setUserLogin:resultModel];
        [AppSetting save];
        GCDMainBlock(^{
            [weakSelf.viewMain setBalanceValue:balance];
        });
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD showError:msg];
    }];
}
-(void)setContactServiceVC
{
    //ZContactServiceViewController *itemVC = [[ZContactServiceViewController alloc] init];
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setTitle:kCustomerService];
    [itemVC setWebUrl:[NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_WeChatServiceUrl]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
-(void)getOrderWithMoney:(NSString *)money
{
    [ZProgressHUD showMessage:kCMsgRecharging];
    ZWEAKSELF
    NSString *title = [NSString stringWithFormat:@"%@-%@", APP_PROJECT_NAME, kRecharge];
    [snsV2 getGenerateOrderWithMoney:money type:WTPayTypeRecharge objid:nil title:title payType:(WTPayWayTypeApplePay) resultBlock:^(ModelOrderWT *model, id resultThree, NSDictionary *result) {
        
        [weakSelf sendPayAppleWithOrderModel:model];
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD dismiss];
        [ZAlertPromptView showWithMessage:msg];
    } balanceBlock:nil];
}
///向苹果发起支付
-(void)sendPayAppleWithOrderModel:(ModelOrderWT *)model
{
    ZWEAKSELF
    [weakSelf setModelOrder:model];
    
    [StatisticsManager event:kUser_Balance_Recharge dictionary:@{kObjectTitle: kRecharge, kObjectPrice: model.price, kObjectUser: kUserDefaultId}];
    
    ///向苹果发起支付请求
    ApplePayManager *payManager = [ApplePayManager sharedHelper];
    [payManager requestProductPrice:model.price];
    ///请求数据回调
    [payManager setOnRequestState:^(NSString *errorMsg) {
        [ZProgressHUD dismiss];
        [ZAlertPromptView showWithMessage:errorMsg];
    }];
    /// TODO: ZWW - 诸葛IO
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    [dicParams setObject:@"ApplePay" forKey:kZhugeIOPayTypeKey];
    [dicParams setObject:model.price == nil ? kEmpty : model.price forKey:kZhugeIOPayMoneyKey];
    [dicParams setObject:model.ids == nil ? kEmpty : model.ids forKey:kZhugeIOOrderNumberKey];
    [dicParams setObject:model.title == nil ? kEmpty : model.title forKey:kZhugeIOGoodsNameKey];
    ///支付结果回调
    [payManager setOnBuyProductResult:^(SKPaymentTransaction *payMent) {
        switch (payMent.transactionState) {
            case SKPaymentTransactionStatePurchasing://购买中
                break;
            case SKPaymentTransactionStatePurchased://购买完成
            {
                [StatisticsManager eventIOTrackWithKey:kZhugeIORechargeSuccessKey dictionary:dicParams];
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
                    [ZAlertPromptView showWithMessage:msg];
                    [sqlite setLocalOrderDetailWithModel:model userId:kLoginUserId];
                }];
                break;
            }
            case SKPaymentTransactionStateFailed://购买失败
            {
                [StatisticsManager eventIOTrackWithKey:kZhugeIORechargeFailKey dictionary:dicParams];
                
                [ZProgressHUD dismiss];
                [ZAlertPromptView showWithMessage:kRequestApplePaymentFailed];
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
