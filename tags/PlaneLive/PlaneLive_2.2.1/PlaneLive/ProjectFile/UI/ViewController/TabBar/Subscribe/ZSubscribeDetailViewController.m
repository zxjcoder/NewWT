//
//  ZSubscribeDetailViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeDetailTableView.h"
#import "ZSubscribeTabBarView.h"
#import "ZPlayToolView.h"
#import "ZAccountBalanceViewController.h"
#import "ZSubscribeProbationViewController.h"

@interface ZSubscribeDetailViewController ()

@property (strong, nonatomic) ZSubscribeDetailTableView *tvMain;
@property (strong, nonatomic) ZSubscribeTabBarView *viewTabbar;
@property (strong, nonatomic) ZLabel *lbTitleNav;
@property (strong, nonatomic) ModelSubscribe *model;
@property (strong, nonatomic) ModelSubscribeDetail *modelDetail;
@property (assign, nonatomic) CGFloat lastNavigationAlpha;
@property (assign, nonatomic) CGRect tvFrame;

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
        
        [self setRefreshSubscribeDetail:NO];
    }
    [self setRightShareButtonOnly];
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
    OBJC_RELEASE(_viewTabbar);
    
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
    self.tvFrame = VIEW_MAIN_FRAME;
    self.tvMain = [[ZSubscribeDetailTableView alloc] initWithFrame:self.tvFrame];
    [self.tvMain setOnContentOffsetY:^(CGFloat alpha) {
        [weakSelf.lbTitleNav setHidden:alpha==0];
        [weakSelf.lbTitleNav setAlpha:alpha];
        
        [weakSelf setNavBarAlpha:alpha];
    }];
    [self.view addSubview:self.tvMain];
    
    [self.view bringSubviewToFront:self.viewTabbar];
    
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
    BOOL isPop = NO;
    if (modelSD && modelSD.ids) {
        [self.tvMain setViewDataWithModel:modelSD];
        [self setShowBottomViewWithType:modelSD.isExistFreeRead==true?0:1];
    } else {
        isPop = YES;
        [ZProgressHUD showMessage:kCMsgGeting];
    }
    [self setRefreshSubscribeDetail:isPop];
}
///0试读,订阅 1订阅
-(void)setShowBottomViewWithType:(int)type
{
    ZWEAKSELF
    self.viewTabbar = [[ZSubscribeTabBarView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT-[ZSubscribeTabBarView getViewHeight]) type:type];
    [self.viewTabbar setViewDataWithModel:self.model];
    [self.viewTabbar setOnProbationClick:^{
        ZSubscribeProbationViewController *itemVC = [[ZSubscribeProbationViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.viewTabbar setOnSubscribeClick:^{
        [weakSelf setPayClick];
    }];
    [self.view addSubview:self.viewTabbar];
    
    CGRect tvFrame = self.tvFrame;
    tvFrame.size.height -= self.viewTabbar.height;
    [self.tvMain setFrame:tvFrame];
}
-(void)setRefreshSubscribeDetail:(BOOL)isPop
{
    ZWEAKSELF
    [snsV2 getSubscribeRecommendArrayWithSubscribeId:self.model.ids resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
        if (isPop) {
            [ZProgressHUD dismiss];
        }
        [weakSelf setModelDetail:model];
        [weakSelf.viewTabbar setHidden:model.isSubscribe];
        [weakSelf.tvMain setViewDataWithModel:model];
        [weakSelf setShowBottomViewWithType:model.isExistFreeRead==true?0:1];
        
        [sqlite setLocalSubscribeDetailWithModel:model userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        if (isPop) {
            [ZProgressHUD dismiss];
            [ZAlertView showWithMessage:msg completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}
///订阅按钮
-(void)setPayClick
{
    ZWEAKSELF
    if ([AppSetting getAutoLogin]) {
        if (weakSelf.model.is_series_course == 0) {
            [StatisticsManager event:kSubscription_Detail_Pay];
        } else {
            [StatisticsManager event:kEriesCourse_Detail_Pay];
        }
        ZPlayToolView *viewPlayTool = [[ZPlayToolView alloc] initWithPlayTitle:weakSelf.model.title];
        [viewPlayTool setOnBalanceClick:^{
            if ([AppSetting getUserLogin].balance < [weakSelf.model.price floatValue]) {
                [ZAlertView showWithTitle:kPrompt message:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    switch (selectIndex) {
                        case 1: [weakSelf setShowAccountBalanceVC]; break;
                        default:break;
                    }
                } cancelTitle:kCancel doneTitle:kToRecharge];
                return;
            }
            [ZProgressHUD showMessage:kCMsgOrdering];
            ///下订单
            [snsV2 getGenerateOrderWithMoney:weakSelf.model.price type:WTPayTypeSubscribe objid:weakSelf.model.ids title:weakSelf.model.title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                ///修改订单状态
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    if (weakSelf.model.is_series_course == 0) {
                        [StatisticsManager event:kSubscription_Detail_Pay_Succeed];
                    } else {
                        [StatisticsManager event:kEriesCourse_Detail_Pay_Succeed];
                    }
                    [ZProgressHUD dismiss];
                    ///TODO:ZWW-备注购买单个实务成功,跳转到订阅已购界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZSubscribeSuccessNotification object:nil];
                    [ZAlertView showWithMessage:kSubscriptionSuccess completion:^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                        [[AppDelegate getTabBarVC] setShowSubscribeAlreadyHasVC:weakSelf.modelDetail];
                    }];
                } errorBlock:^(NSString *msg) {
                    [ZProgressHUD dismiss];
                    [ZAlertView showWithMessage:msg];
                    [sqlite setLocalOrderDetailWithModel:model userId:kLoginUserId];
                }];
            } errorBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [ZAlertView showWithMessage:msg];
            } balanceBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [StatisticsManager event:kAccountBalanceFail_Recharge];
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
    ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    ZWEAKSELF
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
