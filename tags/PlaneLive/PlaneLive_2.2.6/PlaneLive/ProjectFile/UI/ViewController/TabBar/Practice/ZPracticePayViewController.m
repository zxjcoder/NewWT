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
#import "ZAlertPayView.h"
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
    [self setTitle:kPractice];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPracticePaySuccess:) name:ZPracticePaySuccessNotification object:nil];
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightShareCartButton];
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageHomePracticeKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    [dicParams setObject:self.model.title == nil ? kEmpty : self.model.title forKey:@"微课标题"];
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageHomePracticeKey dictionary:dicParams];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticePaySuccessNotification object:nil];
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
    //TODO:ZWW备注-统计
    [StatisticsManager event: kPractice_PayDetails];
    self.tvFrame = VIEW_ITEM_FRAME;
    ZWEAKSELF
    self.tvMain = [[ZPracticePayInfoTableView alloc] initWithFrame:self.tvFrame];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshPractice];
    }];
    [self.view addSubview:self.tvMain];
    
    self.footerFrame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, APP_TABBAR_HEIGHT);
    self.viewFooter = [[ZPracticePayFooterView alloc] initWithFrame:self.footerFrame];
    [self.viewFooter setOnBuyClick:^{
        [weakSelf setBuyClick];
    }];
    [self.viewFooter setOnJoinCartClick:^{
        [weakSelf setJoinCartClick];
    }];
    [self.view addSubview:self.viewFooter];
    
    [super innerInit];
    
    [self.tvMain setViewDataWithModel:self.model];
    [self.viewFooter setViewDataWithModel:self.model];
    if (self.model.unlock == 0 || (self.model.unlock == 1 && self.model.buyStatus == 1)) {
        [self setFooterViewHidden];
    } else {
        [self setFooterViewShow];
    }
    [self setRefreshPractice];
}
-(void)setFooterViewShow
{
    CGRect footerFrame = self.footerFrame;
    footerFrame.origin.y = footerFrame.origin.y - footerFrame.size.height;
    
    CGRect tvFrame = self.tvFrame;
    tvFrame.size.height -= APP_TABBAR_HEIGHT;
    
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewFooter setFrame:footerFrame];
        [self.tvMain setFrame:tvFrame];
    }];
}
-(void)setFooterViewHidden
{
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewFooter setFrame:self.footerFrame];
        [self.tvMain setFrame:self.tvFrame];
    }];
}
///刷新微课数据
-(void)setRefreshPractice
{
    ZWEAKSELF
    [snsV2 getPracticeDetailWithPracticeId:self.model.ids resultBlock:^(ModelPractice *resultModel) {
        [weakSelf.tvMain endRefreshHeader];
        if (resultModel) {
            [weakSelf setModel:resultModel];
            
            [weakSelf.tvMain setViewDataWithModel:resultModel];
            [weakSelf.viewFooter setViewDataWithModel:resultModel];
            if (resultModel.unlock == 0 || (resultModel.unlock == 1 && resultModel.buyStatus == 1)) {
                [weakSelf setFooterViewHidden];
            } else {
                [weakSelf setFooterViewShow];
            }
        }
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
    }];
}
///立即购买
-(void)setBuyClick
{
    [StatisticsManager event: kPractice_PayDetails_Pay];
    // 只需要登录就可以购买
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        if (self.model.buyStatus == 1) {
            [ZProgressHUD showError:kYouHavePurchasedThisPractice];
            return;
        }
        ZAlertPayView *viewPlayTool = [[ZAlertPayView alloc] initWithTitle:self.model.title];
        [viewPlayTool setOnBalanceClick:^{
            if ([AppSetting getUserLogin].balance < [weakSelf.model.price floatValue]) {
                [ZAlertPromptView showWithMessage:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription buttonText:kToRecharge completionBlock:^{
                    [weakSelf setShowAccountBalanceVC];
                } closeBlock:nil];
                return;
            }
            [ZProgressHUD showMessage:kCMsgPaying];
            
            // TODO: ZWW - 开始支付微课
            NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
            [dicParams setObject:@"ApplePay" forKey:kZhugeIOPayTypeKey];
            [dicParams setObject:weakSelf.model.price == nil ? kEmpty : weakSelf.model.price forKey:kZhugeIOPayMoneyKey];
            [dicParams setObject:weakSelf.model.ids == nil ? kEmpty : weakSelf.model.ids forKey:kZhugeIOOrderNumberKey];
            [dicParams setObject:weakSelf.model.title == nil ? kEmpty : weakSelf.model.title forKey:kZhugeIOGoodsNameKey];
            [StatisticsManager eventIOTrackWithKey:kZhugeIOPayStartKey title:weakSelf.model.title type:kPractice name:weakSelf.model.nickname team:weakSelf.model.person_title paytype:kBalance price:weakSelf.model.price];
            ///下订单
            [snsV2 getGenerateOrderWithMoney:weakSelf.model.price type:WTPayTypePractice objid:weakSelf.model.ids title:weakSelf.model.title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    [weakSelf.model setBuyStatus:1];
                    // TODO: ZWW - 诸葛IO支付成功
                    [StatisticsManager eventIOTrackWithKey:kZhugeIOPaySuccessKey dictionary:dicParams];
                    ///TODO:ZWW-备注购买单个微课成功,跳转到播放界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZPracticePaySuccessNotification object:weakSelf.model];
                    [ZAlertPromptView showWithMessage:kCMsgPurchaseSuccess completionBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        [[AppDelegate getTabBarVC] setShowPlayVCWithPractice:weakSelf.model];
                    } closeBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        [[AppDelegate getTabBarVC] setShowPlayVCWithPractice:weakSelf.model];
                    }];
                } errorBlock:^(NSString *msg) {
                    // TODO: ZWW - 诸葛IO支付失败
                    [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                    [StatisticsManager eventIOTrackWithKey:kZhugeIOPayFailKey dictionary:dicParams];
                    
                    [ZProgressHUD dismiss];
                    [ZAlertPromptView showWithMessage:msg];
                }];
            } errorBlock:^(NSString *msg) {
                // TODO: ZWW - 诸葛IO支付失败
                [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                [StatisticsManager eventIOTrackWithKey:kZhugeIOPayFailKey dictionary:dicParams];
                
                [ZProgressHUD dismiss];
                [ZAlertPromptView showWithMessage:msg];
            } balanceBlock:^(NSString *msg) {
                // TODO: ZWW - 诸葛IO支付失败
                [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                [StatisticsManager eventIOTrackWithKey:kZhugeIOPayFailKey dictionary:dicParams];
                
                [ZProgressHUD dismiss];
                [ZAlertPromptView showWithMessage:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription buttonText:kToRecharge completionBlock:^{
                    [weakSelf setShowAccountBalanceVC];
                } closeBlock:nil];
            }];
        }];
        [viewPlayTool show];
    } else {
        [self showLoginVC];
    }
}
-(void)setPracticePaySuccess:(NSNotification *)sender
{
    if (sender.object && [sender.object isKindOfClass:[NSString class]] && [sender.object isEqualToString:kZero]) {
        GCDMainBlock(^{
            [self.viewFooter setFrame:self.footerFrame];
            [self.tvMain setFrame:self.tvFrame];
        });
    }
}
///显示充值页面
-(void)setShowAccountBalanceVC
{
    [StatisticsManager event:  kPractice_PayDetails_Pay_Balancepay];
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///加入购物车
-(void)setJoinCartClick
{
    [StatisticsManager event: kPractice_PayDetails_Join];
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZWEAKSELF
        if (self.model.buyStatus == 1) {
            [ZProgressHUD showError:kYouHavePurchasedThisPractice];
            return;
        }
        if (self.isJoing) {
            [ZProgressHUD showError:kJoinPayCarting];
            return;
        }
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
    
    [self setRightShareCartButton];
}
-(void)btnCartClick
{
    [StatisticsManager event:  kPractice_PayDetails_Join_ShoppingCart];
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZPayCartViewController *itemVC = [[ZPayCartViewController alloc] init];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [self showLoginVC];
    }
}
-(void)btnShareClick
{
    ZWEAKSELF
    ZAlertShareView *shareView = [[ZAlertShareView alloc] init];
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
