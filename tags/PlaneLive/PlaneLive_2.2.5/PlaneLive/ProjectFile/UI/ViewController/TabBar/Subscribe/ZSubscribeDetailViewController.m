//
//  ZSubscribeDetailViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeDetailTableView.h"
#import "ZNewSubscribeToolView.h"
#import "ZAlertPayView.h"
#import "ZAccountBalanceViewController.h"
#import "ZSubscribeProbationViewController.h"

@interface ZSubscribeDetailViewController ()

@property (strong, nonatomic) ZSubscribeDetailTableView *tvMain;
@property (strong, nonatomic) ZNewSubscribeToolView *viewFooter;
@property (strong, nonatomic) ZLabel *lbTitleNav;
@property (strong, nonatomic) ModelSubscribe *model;
@property (strong, nonatomic) ModelSubscribeDetail *modelDetail;
@property (assign, nonatomic) CGFloat lastNavigationAlpha;
@property (assign, nonatomic) CGRect tvFrame;
@property (assign, nonatomic) CGRect footerFrame;

@end

@implementation ZSubscribeDetailViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isShowLogin) {
        [self setIsShowLogin:NO];
        
        [self setRefreshSubscribeDetail];
    }
    [self setRightShareButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
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
    OBJC_RELEASE(_lbTitleNav);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_modelDetail);
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
    [StatisticsManager event: kTraining_Detail];
    [StatisticsManager event: kEriesCourse_Detail];
    ZWEAKSELF
    self.tvFrame = VIEW_MAIN_FRAME;
    self.tvMain = [[ZSubscribeDetailTableView alloc] initWithFrame:self.tvFrame];
    [self.tvMain setOnContentOffsetY:^(CGFloat alpha) {
        [weakSelf.lbTitleNav setHidden:alpha==0];
        [weakSelf.lbTitleNav setAlpha:alpha];
        
        [weakSelf setNavBarAlpha:alpha];
    }];
    [self.view addSubview:self.tvMain];
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshSubscribeDetail];
    }];
    [super innerInit];
    
    [self setNavBarAlpha:0];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:TITLECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitleNav setHidden:YES];
    [self.lbTitleNav setAlpha:0];
    [self.lbTitleNav setText:self.model.title];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    
    [self innerData];
}

-(void)innerData
{
    ModelSubscribeDetail *modelSD = [sqlite getLocalSubscribeDetailWithUserId:kLoginUserId subscribeId:self.model.ids];
    if (modelSD && modelSD.ids) {
        [self.tvMain setViewDataWithModel:modelSD];
    }
    [self setRefreshSubscribeDetail];
}
-(void)setShowBottomView
{
    if (self.model.is_series_course == 0) {
        [StatisticsManager event: kTraining_Detail_AcademicProbation];
    } else {
        [StatisticsManager event: kEriesCourse_Detail_AcademicProbation];
    }
    if (!self.viewFooter) {
        ZWEAKSELF
        self.viewFooter = [[ZNewSubscribeToolView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT)];
        [self.viewFooter setOnProbationClick:^{
            ZSubscribeProbationViewController *itemVC = [[ZSubscribeProbationViewController alloc] init];
            [itemVC setViewDataWithModel:weakSelf.model];
            [weakSelf.navigationController pushViewController:itemVC animated:YES];
        }];
        [self.viewFooter setOnSubscribeClick:^{
            [weakSelf setPayClick];
        }];
        [self.view addSubview:self.viewFooter];
        
        self.footerFrame = self.viewFooter.frame;
        [self.viewFooter setViewDataWithModel:self.model];
        
        [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            CGRect tvFrame = self.tvFrame;
            tvFrame.size.height -= self.viewFooter.height;
            [self.tvMain setFrame:tvFrame];
            
            CGRect footerFrame = self.viewFooter.frame;
            footerFrame.origin.y -= footerFrame.size.height;
            self.viewFooter.frame = footerFrame;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.viewFooter setViewDataWithModel:self.model];
        if (self.model.isSubscribe) {
            [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                [self.tvMain setFrame:self.tvFrame];
                self.viewFooter.frame = self.footerFrame;
            } completion:^(BOOL finished) {
                [self.viewFooter removeFromSuperview];
                self.viewFooter = nil;
            }];
        }
    }
}
-(void)setRefreshSubscribeDetail
{
    ZWEAKSELF
    [snsV2 getSubscribeRecommendArrayWithSubscribeId:self.model.ids resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf setModel:model];
        [weakSelf setModelDetail:model];
        [weakSelf.tvMain setViewDataWithModel:model];
        [weakSelf setShowBottomView];
        
        [sqlite setLocalSubscribeDetailWithModel:model userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
    }];
}
///订阅按钮
-(void)setPayClick
{
    ZWEAKSELF
    if ([AppSetting getAutoLogin]) {
        if (weakSelf.model.is_series_course == 0) {
            [StatisticsManager event: kTraining_Detail_Pay];
        } else {
            [StatisticsManager event: kEriesCourse_Detail_Pay];
        }
        ZWEAKSELF
        if (self.model.isSubscribe) {
            [ZProgressHUD showError:kYouHavePurchasedThisCourse];
            return;
        }
        ZAlertPayView *viewPlayTool = [[ZAlertPayView alloc] initWithTitle:weakSelf.model.title];
        [viewPlayTool setOnBalanceClick:^{
            if ([AppSetting getUserLogin].balance < [weakSelf.model.price floatValue]) {
                [ZAlertPromptView showWithMessage:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription buttonText:kToRecharge completionBlock:^{
                    [weakSelf setShowAccountBalanceVC];
                } closeBlock:nil];
                return;
            }
            if (weakSelf.model.is_series_course == 0) {
                [StatisticsManager event: kTraining_Detail_Pay_Balancepay];
            } else {
                [StatisticsManager event: kEriesCourse_Detail_Pay_Balancepay];
            }
            [ZProgressHUD showMessage:kCMsgOrdering];
            
            // TODO: ZWW - 开始支付系列课或订阅课
            NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
            [dicParams setObject:@"ApplePay" forKey:kZhugeIOPayTypeKey];
            [dicParams setObject:weakSelf.model.price == nil ? kEmpty : weakSelf.model.price forKey:kZhugeIOPayMoneyKey];
            [dicParams setObject:weakSelf.model.ids == nil ? kEmpty : weakSelf.model.ids forKey:kZhugeIOOrderNumberKey];
            [dicParams setObject:weakSelf.model.title == nil ? kEmpty : weakSelf.model.title forKey:kZhugeIOGoodsNameKey];
            
            NSString *datatype = weakSelf.model.is_series_course == 1 ? kSeriesCourse : kSubscribe;
            [StatisticsManager eventIOTrackWithKey:kZhugeIOPayStartKey title:weakSelf.model.title type:datatype name:weakSelf.model.team_name team:weakSelf.model.team_info paytype:kBalance price:weakSelf.model.price];
            
            ///下订单
            [snsV2 getGenerateOrderWithMoney:weakSelf.model.price type:WTPayTypeSubscribe objid:weakSelf.model.ids title:weakSelf.model.title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                ///修改订单状态
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    
                    // TODO: ZWW - 诸葛IO支付成功
                    [StatisticsManager eventIOTrackWithKey:kZhugeIOPaySuccessKey dictionary:dicParams];
                    
                    ///TODO:ZWW-备注购买单个订阅成功,跳转到订阅已购详情界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZSubscribeSuccessNotification object:nil];
                    [ZAlertPromptView showWithMessage:kSubscriptionSuccess completionBlock:^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                        [[AppDelegate getTabBarVC] setShowSubscribeAlreadyHasVC:weakSelf.modelDetail];
                    } closeBlock:^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                        [[AppDelegate getTabBarVC] setShowSubscribeAlreadyHasVC:weakSelf.modelDetail];
                    }];
                } errorBlock:^(NSString *msg) {
                    
                    // TODO: ZWW - 诸葛IO支付失败
                    [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                    [StatisticsManager eventIOTrackWithKey:kZhugeIOPayFailKey dictionary:dicParams];
                    
                    [ZProgressHUD dismiss];
                    [ZAlertPromptView showWithMessage:msg];
                    [sqlite setLocalOrderDetailWithModel:model userId:kLoginUserId];
                }];
            } errorBlock:^(NSString *msg) {
                // TODO: ZWW - 诸葛IO支付失败
                [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                [StatisticsManager eventIOTrackWithKey:kZhugeIOPayFailKey dictionary:dicParams];
                
                [ZProgressHUD dismiss];
                [ZAlertPromptView showWithMessage:msg];
            } balanceBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                
                // TODO: ZWW - 诸葛IO支付失败
                [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                [StatisticsManager eventIOTrackWithKey:kZhugeIOPayFailKey dictionary:dicParams];
                [ZAlertPromptView showWithMessage:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription buttonText:kToRecharge completionBlock:^{
                    [weakSelf setShowAccountBalanceVC];
                } closeBlock:nil];
            }];
        }];
        [viewPlayTool show];
    } else {
        [weakSelf showLoginVC];
    }
}
///显示充值页面
-(void)setShowAccountBalanceVC
{
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///右边功能按钮
-(void)btnRightClick
{
    [self btnShareClick];
}
///分享按钮点击事件
-(void)btnShareClick
{
    if (self.model.is_series_course == 0) {
        [StatisticsManager event: kTraining_Detail_Share];
    } else {
        [StatisticsManager event: kEriesCourse_Detail_Share];
    }
    ZAlertShareView *shareView = [[ZAlertShareView alloc] init];
    ZWEAKSELF
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
            {
                if (weakSelf.model.is_series_course == 0) {
                    [StatisticsManager event: kTraining_Detail_Share_Wechat];
                } else {
                    [StatisticsManager event: kEriesCourse_Detail_Share_Wechat];
                }
                [weakSelf btnWeChatClick];
                break;
            }
            case ZShareTypeWeChatCircle:
            {
                if (weakSelf.model.is_series_course == 0) {
                    [StatisticsManager event: kTraining_Detail_Share_WechatCircle];
                } else {
                    [StatisticsManager event: kEriesCourse_Detail_Share_WechatCircle];
                }
                [weakSelf btnWeChatCircleClick];
                break;
            }
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
    NSString *title = self.modelDetail.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelDetail.theme_intro;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelDetail.illustration];
    NSString *webUrl = kApp_SubscribeContentUrl(self.modelDetail.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}

-(void)setViewDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
}

-(void)setViewDataWithModelDetail:(ModelSubscribeDetail *)model
{
    [self setModelDetail:model];
}

@end
