//
//  ZPayCartViewController.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPayCartViewController.h"
#import "ZPayCartTableView.h"
#import "ZPayCartFooterView.h"
#import "ZPlayToolView.h"
#import "ZAccountBalanceViewController.h"

@interface ZPayCartViewController ()

@property (strong, nonatomic) ZPayCartTableView *tvMain;

@property (strong, nonatomic) ZPayCartFooterView *viewFooter;

@end

@implementation ZPayCartViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kShoppingCart];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshHeader];
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageUserShoppingCartKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageUserShoppingCartKey dictionary:nil];
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
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_viewFooter);
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
    CGRect tvFrame = VIEW_ITEM_FRAME;
    tvFrame.size.height -= APP_TABBAR_HEIGHT;
    self.tvMain = [[ZPayCartTableView alloc] initWithFrame:tvFrame];
    [self.tvMain setOnDeleteClick:^(ModelPayCart *model) {
        [weakSelf setDeletePayCart:model];
    }];
    [self.tvMain setOnCheckedClick:^(BOOL check, NSInteger row, NSInteger selCount, BOOL isMaxSel, CGFloat selMaxPrice) {
        [weakSelf.viewFooter setViewCheckStatus:isMaxSel];
        [weakSelf.viewFooter setViewDataWithCount:selCount maxPrice:selMaxPrice];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.view addSubview:self.tvMain];
    
    self.viewFooter = [[ZPayCartFooterView alloc] initWithFrame:CGRectMake(0, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT, APP_FRAME_WIDTH, APP_TABBAR_HEIGHT)];
    [self.viewFooter setOnBuyClick:^{
        [weakSelf setBuyClick];
    }];
    [self.viewFooter setOnCheckClick:^(BOOL checkAll) {
        [weakSelf.tvMain setCheckedAll:checkAll];
        if (checkAll) {
            CGFloat maxPrice = 0;
            for (ModelPayCart *model in weakSelf.tvMain.getMainArray) {
                maxPrice += [model.price floatValue];
            }
            [weakSelf.viewFooter setViewDataWithCount:weakSelf.tvMain.getMainArray.count maxPrice:maxPrice];
        } else {
            [weakSelf.viewFooter setViewDataWithCount:0 maxPrice:0];
        }
    }];
    [self.view addSubview:self.viewFooter];
    
    [super innerInit];
    
    [self innerData];
}
-(void)innerData
{
    NSArray *arrPayCart = [sqlite getLocalPayCartPracticeArrayWithUserId:kLoginUserId];
    if (arrPayCart && arrPayCart.count > 0) {
        [self.tvMain setViewDataWithArray:arrPayCart];
        CGFloat maxPrice = 0;
        for (ModelPayCart *model in arrPayCart) {
            maxPrice += [model.price floatValue];
        }
        [self.viewFooter setViewDataWithCount:arrPayCart.count maxPrice:maxPrice];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getPayCartPracticeArrayResultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf.tvMain endRefreshHeader];
        
        [weakSelf.tvMain setViewDataWithArray:array];
        
        CGFloat maxPrice = 0;
        for (ModelPayCart *model in array) {
            maxPrice += [model.price floatValue];
        }
        [weakSelf.viewFooter setViewDataWithCount:array.count maxPrice:maxPrice];
        
        [weakSelf.viewFooter setViewCheckStatus:YES];
        
        ModelUser *modelU = [AppSetting getUserLogin];
        [modelU setShoppingCartCount:(int)array.count];
        [AppSetting setUserLogin:modelU];
        [AppSetting save];
        
        [sqlite setLocalPayCartPracticeWithArray:array userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        
        [weakSelf.viewFooter setViewDataWithCount:0 maxPrice:0];
        
        [weakSelf.viewFooter setViewCheckStatus:NO];
        
        [weakSelf.tvMain setViewDataWithArray:nil];
    }];
}
///删除购物车单条实务
-(void)setDeletePayCart:(ModelPayCart *)model
{
    CGFloat maxPrice = 0;
    for (ModelPayCart *model in self.tvMain.getMainArray) {
        maxPrice += [model.price floatValue];
    }
    [self.viewFooter setViewDataWithCount:self.tvMain.getMainArray.count maxPrice:maxPrice];
    [snsV2 postRemovePracticeByCartWithPracticeIds:model.ids resultBlock:nil errorBlock:nil];
    
    ModelUser *modelU = [AppSetting getUserLogin];
    [modelU setShoppingCartCount:(int)self.tvMain.getMainArray.count];
    [AppSetting setUserLogin:modelU];
    [AppSetting save];
}
///结算
-(void)setBuyClick
{
    [StatisticsManager event:kPractice_PayDetails_Join_ShoppingCart_Settlement];
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        if (self.tvMain.getMainArray.count == 0) {
            [ZProgressHUD showError:kAbsolutelyEmptyCart];
            return;
        }
        NSArray *arrCheck = [self.tvMain getCheckArray];
        if (arrCheck == nil || arrCheck.count == 0) {
            [ZProgressHUD showError:kPleaseAtLeastSelectedPractice];
            return;
        }
        ZWEAKSELF
        ZPlayToolView *viewPlayTool = [[ZPlayToolView alloc] initWithPracticeTitle:kJoinedPayCartDePractice];
        [viewPlayTool setOnBalanceClick:^{
            CGFloat totalPrice = 0;
            NSMutableArray *arrObjIds = [NSMutableArray array];
            for (ModelPayCart *modelP in arrCheck) {
                [arrObjIds addObject:modelP.ids];
                totalPrice += [modelP.price floatValue];
            }
            if ([AppSetting getUserLogin].balance < totalPrice) {
                [ZAlertView showWithTitle:kPrompt message:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    switch (selectIndex) {
                        case 1: [weakSelf setShowAccountBalanceVC]; break;
                        default:break;
                    }
                } cancelTitle:kCancel doneTitle:kToRecharge];
                return;
            }
            [ZProgressHUD showMessage:kCMsgPaying];
            [StatisticsManager event:kPractice_PayDetails_Join_ShoppingCart_Settlement_Balancepay];
            ///下订单
            [snsV2 getGenerateOrderClearingWithMoney:[NSString stringWithFormat:@"%.2f", totalPrice] type:WTPayTypePractice objid:[arrObjIds toString] title:kEmpty payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    
                    [weakSelf.tvMain removeDataWithArray:arrCheck];
                    
                    NSArray *arrayNewMain = [weakSelf.tvMain getMainArray];
                    
                    [sqlite setLocalPayCartPracticeWithArray:arrayNewMain userId:kLoginUserId];
                    
                    [weakSelf.viewFooter setViewCheckStatus:YES];
                    
                    ModelUser *modelU = [AppSetting getUserLogin];
                    [modelU setShoppingCartCount:(int)arrayNewMain.count];
                    [AppSetting setUserLogin:modelU];
                    [AppSetting save];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZCartPaySuccessNotification object:nil];
                    if (arrayNewMain.count > 0) {
                        CGFloat priceCount = 0;
                        for (ModelPayCart *modelP in arrayNewMain) {
                            priceCount += [modelP.price floatValue];
                        }
                        [weakSelf.viewFooter setViewDataWithCount:arrayNewMain.count maxPrice:priceCount];
                        
                        [ZAlertView showWithMessage:kCMsgPurchaseSuccess];
                    } else {
                        [weakSelf.viewFooter setViewDataWithCount:0 maxPrice:0];
                        ///TODO:ZWW-备注购物车清空成功,跳转到已购界面
                        [ZAlertView showWithMessage:kCMsgPurchaseSuccess completion:^{
                            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                            [[AppDelegate getTabBarVC] setShowPurchaseVC];
                        }];
                    }
                } errorBlock:^(NSString *msg) {
                    [ZProgressHUD dismiss];
                    [ZAlertView showWithMessage:msg];
                }];
            } errorBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [ZAlertView showWithMessage:msg];
            } balanceBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [ZAlertView showWithTitle:kPrompt message:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    switch (selectIndex) {
                        case 1: [weakSelf setShowAccountBalanceVC]; break;
                        default:break;
                    }
                } cancelTitle:kCancel doneTitle:kToRecharge];
            }];
        }];
        [viewPlayTool show];
    } else {
        [self showLoginVC];
    }
}
///显示充值页面
-(void)setShowAccountBalanceVC
{
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
