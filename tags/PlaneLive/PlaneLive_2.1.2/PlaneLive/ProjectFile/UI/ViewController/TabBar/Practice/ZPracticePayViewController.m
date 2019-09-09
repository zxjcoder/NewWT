//
//  ZPracticePayViewController.m
//  PlaneLive
//
//  Created by Daniel on 03/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayViewController.h"
#import "ZPracticePayInfoTableView.h"
#import "ZPracticePayFooterView.h"
#import "ZPayCartViewController.h"
#import "ZPlayToolView.h"
#import "ZAccountBalanceViewController.h"

@interface ZPracticePayViewController ()

@property (strong, nonatomic) ZPracticePayInfoTableView *tvMain;

@property (strong, nonatomic) ZPracticePayFooterView *viewFooter;

@property (strong, nonatomic) ModelPractice *model;

@property (assign, nonatomic) CGRect tvFrame;

@property (assign, nonatomic) CGRect footerFrame;

@property (assign, nonatomic) BOOL isJoing;

@property (assign, nonatomic) BOOL isBuying;

@end

@implementation ZPracticePayViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshPractice];
    
    [self setCartCount];
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
    OBJC_RELEASE(_model);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    CGRect tvFrame = VIEW_ITEM_FRAME;
    tvFrame.size.height -= APP_TABBAR_HEIGHT;
    self.tvFrame = tvFrame;
    ZWEAKSELF
    self.tvMain = [[ZPracticePayInfoTableView alloc] initWithFrame:self.tvFrame];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshPractice];
    }];
    [self.view addSubview:self.tvMain];
    
    self.footerFrame = CGRectMake(0, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT, APP_FRAME_WIDTH, APP_TABBAR_HEIGHT);
    self.viewFooter = [[ZPracticePayFooterView alloc] initWithFrame:self.footerFrame];
    [self.viewFooter setOnBuyClick:^{
        [weakSelf setBuyClick];
    }];
    [self.viewFooter setOnJoinCartClick:^{
        [weakSelf setJoinCartClick];
    }];
    [self.view addSubview:self.viewFooter];
    
    [super innerInit];
    
    ModelPractice *modelP = [sqlite getLocalPracticeDetailModelWithId:self.model.ids userId:[AppSetting getUserDetauleId]];
    if (modelP) {
        [self.tvMain setViewDataWithModel:modelP];
        [self.viewFooter setViewDataWithModel:modelP];
    } else {
        [self.tvMain setViewDataWithModel:self.model];
        [self.viewFooter setViewDataWithModel:self.model];
    }
}
-(void)setRefreshPractice
{
    ZWEAKSELF
    [snsV2 getPracticeDetailWithPracticeId:self.model.ids resultBlock:^(ModelPractice *resultModel) {
        [weakSelf.tvMain endRefreshHeader];
        if (resultModel) {
            [weakSelf setModel:resultModel];
            
            [weakSelf.tvMain setViewDataWithModel:resultModel];
            [weakSelf.viewFooter setViewDataWithModel:resultModel];
        }
        [sqlite setLocalPracticeDetailWithModel:resultModel userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
    }];
}
///立即购买
-(void)setBuyClick
{
    [StatisticsManager event:kPractice_Detail_Pay];
    if ([AppSetting getAutoLogin]) {
        if (self.model.buyStatus == 1) {
            [ZProgressHUD showError:kYouHavePurchasedThisPractice];
            return;
        }
        ZWEAKSELF
        ZPlayToolView *viewPlayTool = [[ZPlayToolView alloc] initWithPracticeTitle:self.model.title];
        [viewPlayTool setOnBalanceClick:^{
            [ZProgressHUD showMessage:kCMsgPaying];
            ///下订单
            [snsV2 getGenerateOrderWithMoney:weakSelf.model.price type:WTPayTypePractice objid:weakSelf.model.ids title:weakSelf.model.title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    
                    [ZAlertView showWithMessage:kCMsgPurchaseSuccess];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZCartPaySuccessNotification object:nil];
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
                        case 1:
                        {
                            [weakSelf setShowAccountVC];
                            break;
                        }
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
-(void)setShowAccountVC
{
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///加入购物车
-(void)setJoinCartClick
{
    [StatisticsManager event:kPractice_Detail_ShoppingCart];
    if ([AppSetting getAutoLogin]) {
        if (self.model.buyStatus == 1) {
            [ZProgressHUD showError:kYouHavePurchasedThisPractice];
            return;
        }
        if (self.isJoing) {
            [ZProgressHUD showError:kJoinPayCarting];
            return;
        }
        ZWEAKSELF
        [self setIsJoing:YES];
        [snsV2 postJoinPracticeToCartWithPracticeIds:self.model.ids resultBlock:^(NSDictionary *result) {
            [weakSelf setIsJoing:NO];
            [weakSelf.model setJoinCart:1];
            [weakSelf setChangeCartCount];
            [weakSelf.viewFooter setViewDataWithModel:weakSelf.model];
        } errorBlock:^(NSString *msg) {
            [weakSelf setIsJoing:NO];
            [ZProgressHUD showError:msg];
        }];
    } else {
        [self showLoginVC];
    }
}
-(void)setChangeCartCount
{
    ModelUser *modelU = [AppSetting getUserLogin];
    modelU.shoppingCartCount += 1;
    [AppSetting setUserLogin:modelU];
    [AppSetting save];
    
    UILabel *lbCount = [[[[self.navigationItem rightBarButtonItem] customView] viewWithTag:1003] viewWithTag:1];
    if (lbCount && [lbCount isKindOfClass:[UILabel class]]) {
        [lbCount setHidden:modelU.shoppingCartCount==0];
        if (modelU.shoppingCartCount > kNumberMaxCount) {
            [lbCount setText:[NSString stringWithFormat:@"%d", kNumberMaxCount]];
        } else {
            [lbCount setText:[NSString stringWithFormat:@"%d", modelU.shoppingCartCount]];
        }
    }
}
-(void)setCartCount
{
    ModelUser *modelU = [AppSetting getUserLogin];
    UILabel *lbCount = [[[[self.navigationItem rightBarButtonItem] customView] viewWithTag:1003] viewWithTag:1];
    if (lbCount && [lbCount isKindOfClass:[UILabel class]]) {
        [lbCount setHidden:modelU.shoppingCartCount==0];
        if (modelU.shoppingCartCount > kNumberMaxCount) {
            [lbCount setText:[NSString stringWithFormat:@"%d", kNumberMaxCount]];
        } else {
            [lbCount setText:[NSString stringWithFormat:@"%d", modelU.shoppingCartCount]];
        }
    }
}
-(void)btnCartClick
{
    if ([AppSetting getAutoLogin]) {
        ZPayCartViewController *itemVC = [[ZPayCartViewController alloc] init];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [self showLoginVC];
    }
}
-(void)btnShareClick
{
    ZWEAKSELF
    ZShareView *shareView = nil;
    shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [weakSelf btnQZoneClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.model.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    
    NSString *content = self.model.share_content;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    
    NSString *imageUrl = [Utils getMinPicture:self.model.speech_img];
    NSString *webUrl = kShare_VoiceUrl(self.model.ids);
    
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
}

@end
