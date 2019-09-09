//
//  ZTabBarViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarViewController.h"
#import "ZRootViewController.h"
#import "AppDelegate.h"
#import "ZHomeViewController.h"
#import "ZFoundViewController.h"
#import "ZBeenPurchasedViewController.h"
#import "ZUserInfoViewController.h"
#import "StatisticsManager.h"
#import "ZLoginViewController.h"
#import "ZPlayerViewController.h"
#import "ZCircleSearchViewController.h"
#import "ZCircleQuestionViewController.h"
#import "ZQuestionDetailViewController.h"
#import "ZAnswerDetailViewController.h"
#import "ZUserProfileViewController.h"
#import "ZWebViewController.h"
#import "ZNoticeDetailViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZBeenPurchasedViewController.h"
#import "ZSubscribeProbationViewController.h"
#import "ZTabBarBadge.h"
#import "LocationManager.h"
#import "ZAlertHintView.h"
#import "ZAccountManagerViewController.h"
#import "ZEditUserInfoViewController.h"
#import "ZFeekBackRecordViewController.h"
#import "ZSearchViewController.h"
#import "ZTransitionAnimation.h"
#import "ZNoticeListViewController.h"

#define kShowVCAnimated NO

@interface ZTabBarViewController ()<UITabBarControllerDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIButton *btnFound;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZTabBarViewController

#pragma mark - SuperMethod

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [StatisticsManager beginRecordPage:NSStringFromClass(self.class)];
    [self setItemIcon];
    //[[AppDelegate app] setRefreshAppConfig];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[ZCatchCrash setDefaultHandler];
    //[[AppDelegate app] setUncaughtException];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager endRecordPage:NSStringFromClass(self.class)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        //[self setViewNil];
    }
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLoginChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZAppNumberChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCartPaySuccessNotification object:nil];
    OBJC_RELEASE(_btnFound);
    OBJC_RELEASE(_imgLine);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginChange:) name:ZLoginChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppNumberChange:) name:ZAppNumberChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess:) name:ZCartPaySuccessNotification object:nil];
    
    [self setDelegate:self];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.tabBar.width, kLineHeight)];
    [self.tabBar addSubview:self.imgLine];
    
    [self.tabBar setTranslucent:false];
    [self.tabBar setShadowImage:[UIImage createImageWithColor:CLEARCOLOR]];
    [self.tabBar setBackgroundImage:[UIImage createImageWithColor:WHITECOLOR]];
    [self.tabBar setTintColor:TABBARTITLESELCOLOR];
    [self.tabBar setBarTintColor:TABBARTITLECOLOR];
    if (@available(iOS 10.0, *)) {
        [self.tabBar setUnselectedItemTintColor:TABBARTITLECOLOR];
    }
    if (@available(iOS 11.0, *)) {
        //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self setRefreshUserInfo];
    [[LocationManager sharedSingleton] setOnDidUpdateLocation:^(CLLocation *location) {
        //诸葛追踪用户
        [StatisticsManager eventIORefreshUserInfo];
    }];
    //用户定位
    [[LocationManager sharedSingleton] startOneLocation];
}
///设置主界面VC
-(void)setItemIcon
{
    if (self.viewControllers.count == 0) {
        
        ZHomeViewController *itemVC1 = [AppDelegate getViewControllerWithIdentifier:@"VCHomeSID"];
        [self setAddChildWithViewController:itemVC1 image:@"home" selectedImage:@"home_s" title:kHome];
        ZRootViewController *itemRVC1 = [[ZRootViewController alloc] initWithRootViewController:itemVC1];
        
        ZBeenPurchasedViewController *itemVC2 = [AppDelegate getViewControllerWithIdentifier:@"VCBeenPurchasedSID"];
        [self setAddChildWithViewController:itemVC2 image:@"order" selectedImage:@"order_s" title:kBeenPurchased];
        [itemVC2 setDefaultItemIndex:1];
        ZRootViewController *itemRVC2 = [[ZRootViewController alloc] initWithRootViewController:itemVC2];
        
        ZFoundViewController *itemVC3 = [AppDelegate getViewControllerWithIdentifier:@"VCFoundSID"];
        [self setAddChildWithViewController:itemVC3 image:@"discover" selectedImage:@"discover_s" title:kFound];
        ZRootViewController *itemRVC3 = [[ZRootViewController alloc] initWithRootViewController:itemVC3];
        
        ZUserInfoViewController *itemVC5 = [AppDelegate getViewControllerWithIdentifier:@"VCUserInfoSID"];
        [self setAddChildWithViewController:itemVC5 image:@"account" selectedImage:@"account_s" title:kMyInfo];
        ZRootViewController *itemRVC5 = [[ZRootViewController alloc] initWithRootViewController:itemVC5];
        
        self.viewControllers = @[itemRVC1,itemRVC2,itemRVC3,itemRVC5];
        self.selectedIndex = 0;
    }
    [self.tabBar bringSubviewToFront:self.btnFound];
}
///添加页面
- (void)setAddChildWithViewController:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    vc.tabBarItem = nil;
    if (image) {
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[ZFont systemFontOfSize:kFont_Min_Size] forKey:NSFontAttributeName] forState:(UIControlStateNormal)];
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[ZFont systemFontOfSize:kFont_Min_Size] forKey:NSFontAttributeName] forState:(UIControlStateSelected)];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        if (APP_SYSTEM_VERSION >= 10) {
            [tabBarItem setBadgeColor:COLORCOUNTBG];
        }
#endif
        vc.tabBarItem = tabBarItem;
    } else {
        CGFloat btnW = 55;
        CGFloat btnH = 60;
        _btnFound = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnFound setImage:[[UIImage imageNamed:@"tabbar_btn_item3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        [_btnFound setImage:[[UIImage imageNamed:@"tabbar_btn_item3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateHighlighted)];
        [_btnFound setFrame:CGRectMake(self.view.width/2-btnW/2, -15, btnW, btnH)];
        [_btnFound setUserInteractionEnabled:YES];
        [_btnFound addTarget:self action:@selector(btnFoundClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_btnFound setTag:121];
        [self.tabBar addSubview:_btnFound];
    }
}
//发现按钮事件
-(void)btnFoundClick
{
    self.selectedIndex = 2;
    
    [self setChangeFoundImage:self.selectedIndex];
}
///改变按钮图片
-(void)setChangeFoundImage:(NSInteger)selIndex
{
    switch (selIndex) {
        case 2:
            [_btnFound setImage:[UIImage imageNamed:@"tabbar_btn_item3_pre"] forState:(UIControlStateNormal)];
            [_btnFound setImage:[UIImage imageNamed:@"tabbar_btn_item3_pre"] forState:(UIControlStateHighlighted)];
            break;
        default:
            [_btnFound setImage:[UIImage imageNamed:@"tabbar_btn_item3"] forState:(UIControlStateNormal)];
            [_btnFound setImage:[UIImage imageNamed:@"tabbar_btn_item3"] forState:(UIControlStateHighlighted)];
            break;
    }
}
///改变Tabbar选中索引
-(void)setChangeTabbarItem:(NSNotification *)sender
{
    [self setItemIcon];
    
    //id obj = sender.object;
}
///刷新用户数据
-(void)setRefreshUserInfo
{
    if (self.selectedIndex != 3 && [AppSetting getAutoLogin]) {
        ZWEAKSELF
        [snsV1 postGetUserInfoWithUserId:kLoginUserId resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                if (resultModel) {
                    [AppSetting setUserLogin:resultModel];
                    [AppSetting save];
                    [weakSelf setAppNumberChange:nil];
                }
            });
        } errorBlock:nil];
    }
}
///显示问题提问
-(void)setShowQuestionVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    if ([AppSetting getAutoLogin]) {
        ZCircleQuestionViewController *itemVC = [[ZCircleQuestionViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [[self.viewControllers objectAtIndex:3] pushViewController:itemVC animated:kShowVCAnimated];
    } else {
        [self setShowLoginVCWithAnimated:kShowVCAnimated];
    }
}
///显示登录窗口
-(void)setShowLoginVCWithAnimated:(BOOL)animated
{
    ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
    ZRootViewController *itemRVC = [[ZRootViewController alloc] initWithRootViewController:itemVC];
    [itemRVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    itemRVC.navigationBar.shadowImage = [UIImage new];
    //itemRVC.transitioningDelegate = self;
    //itemRVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:itemRVC animated:YES completion:nil];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[ZTransitionAnimation alloc] initWithStytle:(ZTransitionAnimationTypePresent)];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[ZTransitionAnimation alloc] initWithStytle:(ZTransitionAnimationTypeDissmiss)];
}

///显示实务详情
-(void)setShowPracticeVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    [(ZBaseViewController *)[(ZRootViewController *)self.selectedViewController topViewController] setShowPlayVC:kShowVCAnimated];
}
///显示搜索问答
-(void)setShowSearchQuestionAnswerVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    ZCircleSearchViewController *itemVC = [[ZCircleSearchViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [[self.viewControllers objectAtIndex:3] pushViewController:itemVC animated:kShowVCAnimated];
}
///显示搜索实务
-(void)setShowSearchPractice
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    ZSearchViewController *itemVC = [[ZSearchViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:true];
    [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
}
///注销登录
-(void)logout
{
    [self.selectedViewController popToRootViewControllerAnimated:false];
    self.selectedIndex = 0;
    [self setShowLoginVCWithAnimated:true];
}

#pragma mark - NotificationMethod

///登录改变
-(void)setLoginChange:(NSNotification *)sender
{
    if ([AppSetting getAutoLogin]) {
        [self setShowHintView];
    } else {
        if ([[(ZRootViewController *)self.selectedViewController topViewController] isMemberOfClass:[ZPlayerViewController class]]) {
            [self.selectedViewController popViewControllerAnimated:false];
        }
    }
}
///弹出绑定手机号或修改资料的提示框
-(void)setShowHintView
{
    ModelUser *modelU = [AppSetting getUserLogin];
    ZWEAKSELF
    switch (modelU.type) {
        case WTAccountTypeWeChat:
        {
            if (modelU.phone.length == 0) {
                ZAlertHintView *hintView = [[ZAlertHintView alloc] initWithType:(ZAlertHintViewTypeBindPhone)];
                [hintView setOnConfirmationClick:^{
                    [weakSelf showAccountManagerVC];
                }];
                [hintView show];
            }
            break;
        }
        case WTAccountTypePhone:
        {
            if ([modelU.phone isMobile]) {
                NSString *startPhone = [modelU.phone substringToIndex:3];
                NSString *endPhone = [modelU.phone substringFromIndex:7];
                NSString *starPhone = [NSString stringWithFormat:@"%@****%@", startPhone, endPhone];
                if (([modelU.nickname isEqualToString:modelU.phone] || [modelU.nickname isEqualToString:starPhone])) {
                    ZAlertHintView *hintView = [[ZAlertHintView alloc] initWithType:(ZAlertHintViewTypeNickName)];
                    [hintView setOnConfirmationClick:^{
                        [weakSelf showEditUserInfoVC];
                    }];
                    [hintView show];
                }
            }
            break;
        }
        default: break;
    }
}
///账户管理
-(void)showAccountManagerVC
{
    ZAccountManagerViewController *itemVC = [[ZAccountManagerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.selectedViewController pushViewController:itemVC animated:YES];
}
///编辑用户信息
-(void)showEditUserInfoVC
{
    ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.selectedViewController pushViewController:itemVC animated:YES];
}
///购物车购买
-(void)setCartPaySuccess:(NSNotification *)sender
{
    id object = sender.object;
    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:kOne]) {
        [self setShowPurchaseVC];
    }
}
///数量改变
-(void)setAppNumberChange:(NSNotification *)sender
{
    if (self.viewControllers.count > 0) {
        if ([AppSetting getAutoLogin]) {
            ModelUser *model = [AppSetting getUserLogin];
            if (model) {
                int myNumber =model.myNoticeCenterCount
                + model.myMessageCount;
                + model.myFeedbackReplyCount;
                /// 我的显示数量
                if (myNumber == 0) {
                    [[self.tabBar.items lastObject] setBadgeValue:nil];
                    [[AppDelegate app] clearApplicationIcon];
                } else {
                    NSString *strNumber = [NSString stringWithFormat:@"%d", myNumber];
                    [[self.tabBar.items lastObject] setBadgeValue:strNumber];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:myNumber];
                }
                // TODO: ZWW屏蔽已购小红点
                //model.unReadTotalCount = 0;
                /// 已购显示的小红点
                if (model.unReadTotalCount > 0) {
                    [self.tabBar showBadgeOnItemIndex:1];
                } else {
                    [self.tabBar hideBadgeOnItemIndex:1];
                }
            }
        } else {
            [[self.tabBar.items lastObject] setBadgeValue:nil];
            [self.tabBar hideBadgeOnItemIndex:1];
            [[AppDelegate app] clearApplicationIcon];
        }
    }
}

#pragma mark - NotificationEvent

///收到显示对应模块页面的通知
-(void)setShowViewControllerWithParam:(NSDictionary *)dicParam
{
    [self setItemIcon];
    
    [sqlite setSysParam:kSQLITE_LAST_PUSHDATA value:kEmpty];
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    if (self.selectedIndex != 0) {
        self.selectedIndex = 0;
    }
    if (dicParam && [dicParam isKindOfClass:[NSDictionary class]]) {
        //type: WTOpenParamType
        NSString *type = [dicParam objectForKey:@"type"];
        NSString *ids = [dicParam objectForKey:@"ids"];
        NSString *aid = [dicParam objectForKey:@"aid"];
        NSString *url = [dicParam objectForKey:@"url"];
        NSString *title = [dicParam objectForKey:@"title"];
        if (type && ![type isKindOfClass:[NSNull class]]) {
            switch ([type integerValue]) {
                case WTOpenParamTypeQuestion://问题
                {
                    [self setShowQuestionDetailVCWithId:ids];
                    break;
                }
                case WTOpenParamTypeAnswer://回答
                {
                    [self setShowAnswerDetailVCWithQId:ids aid:aid];
                    break;
                }
                case WTOpenParamTypePractice://实务
                {
                    [self setShowPracticeDetailVCWithId:ids];
                    break;
                }
                case WTOpenParamTypeUserInfo://用户
                {
                    [self setShowUserProfileVCWithId:ids];
                    break;
                }
                case WTOpenParamTypeShareTrailer://分享预告
                {
                    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                    [itemVC setWebUrl:url];
                    [itemVC setTitle:title];
                    [itemVC setHidesBottomBarWhenPushed:YES];
                    [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
                    break;
                }
                case WTOpenParamTypeReportInfo://举报信息
                {
                    [self setManagerNoticeListView];
                    break;
                }
                case WTOpenParamTypeAppUpdate://App更新推送
                {
                    [self setManagerNoticeListView];
                    break;
                }
                case WTOpenParamTypeManagerInfoView://系统消息推送
                {
                    [self setManagerNoticeListView];
                    break;
                }
                case WTOpenParamTypeCourseUpdate://课程更新推送
                {
                    [self setManagerNoticeListView];
                    break;
                }
                case WTOpenParamTypeSubscribeDetail://试读订阅
                {
                    [self setShowSubscribeDetailVCWithIds:ids];
                    break;
                }
                case WTOpenParamTypeSubscribeDetailBuy://已购买订阅
                {
                    [self setShowSubscribeDetailVCWithIds:ids];
                    break;
                }
                case WTOpenParamTypeSubscribeProbationListView://试读列表
                {
                    ZWEAKSELF
                    [ZProgressHUD showMessage:kCMsgGeting];
                    [snsV2 getSubscribeRecommendArrayWithSubscribeId:ids resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
                        [ZProgressHUD dismiss];
                        ZSubscribeProbationViewController *itemVC = [[ZSubscribeProbationViewController alloc] init];
                        [itemVC setViewDataWithModel:model];
                        [itemVC setHidesBottomBarWhenPushed:YES];
                        [weakSelf.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
                    } errorBlock:^(NSString *msg) {
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showError:msg];
                    }];
                    break;
                }
                case WTOpenParamTypeFeedbackListView:
                {
                    [self setFeekbackVC];
                    break;
                }
                default: break;
            }
        }
    }
}
/// 意见反馈
-(void)setFeekbackVC
{
    if ([AppSetting getAutoLogin]) {
        ZFeekBackRecordViewController *itemVC = [[ZFeekBackRecordViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
    }
}
///通知消息列表视图
-(void)setManagerNoticeListView
{
    if ([AppSetting getAutoLogin]) {
        ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
    }
}
///显示问题详情
-(void)setShowQuestionDetailVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:ids];
        
        ZQuestionDetailViewController *itemVC = [[ZQuestionDetailViewController alloc] init];
        [itemVC setViewDataWithModel:modelQB];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
    }
}
///显示回答详情
-(void)setShowAnswerDetailVCWithQId:(NSString *)qid aid:(NSString *)aid
{
    if (qid && ![qid isKindOfClass:[NSNull class]] && aid && ![aid isKindOfClass:[NSNull class]]) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:aid];
        [modelAB setQuestion_id:qid];
        
        ZAnswerDetailViewController *itemVC = [[ZAnswerDetailViewController alloc] init];
        [itemVC setViewDataWithModel:modelAB];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
    }
}
///显示用户详情
-(void)setShowUserProfileVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        ModelUserBase *modelUB = [[ModelUserBase alloc] init];
        [modelUB setUserId:ids];
        
        ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
        [itemVC setViewDataWithModel:modelUB];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
    }
}
///显示实务详情
-(void)setShowPracticeDetailVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        ModelPractice *modelP = [sqlite getLocalPlayPracticeDetailModelWithId:ids userId:kLoginUserId];
        if (modelP) {
            ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
            [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
            [itemVC setRawdataWithArray:@[modelP] index:0];
            [itemVC setHidesBottomBarWhenPushed:YES];
           [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
        } else {
            ZWEAKSELF
            [ZProgressHUD showMessage:kCMsgGeting];
            [snsV2 getPracticeDetailWithPracticeId:ids resultBlock:^(ModelPractice *resultModel) {
                [ZProgressHUD dismiss];
                if (resultModel) {
                    [sqlite setLocalPlayPracticeDetailWithModel:resultModel userId:kLoginUserId];
                    
                    ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
                    [itemVC setRawdataWithArray:@[resultModel] index:0];
                    [itemVC setHidesBottomBarWhenPushed:YES];
                    
                    [weakSelf.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
                } else {
                    [ZProgressHUD showError:kNotFoundPlayRecord];
                }
            } errorBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:msg];
            }];
        }
    }
}
///显示订阅详情
-(void)setShowSubscribeDetailVCWithIds:(NSString *)ids
{
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgGeting];
    [snsV2 getSubscribeRecommendArrayWithSubscribeId:ids resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
        [ZProgressHUD dismiss];
        if (model.isSubscribe) { /// 已购买详情
            [weakSelf setShowSubscribeAlreadyHasVC:model];
        } else { /// 未购买详情
            ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
            [itemVC setViewDataWithModel:model];
            [itemVC setViewDataWithModelDetail:model];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
        }
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD dismiss];
        [ZProgressHUD showError:msg];
    }];
}
///显示已订阅订阅详情
-(void)setShowSubscribeAlreadyHasVC:(ModelSubscribeDetail *)model
{
    ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
    [itemVC setViewDataWithSubscribeModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.selectedViewController pushViewController:itemVC animated:kShowVCAnimated];
}
///显示已购界面
-(void)setShowPurchaseVC
{
    [(ZRootViewController *)self.selectedViewController popToRootViewControllerAnimated:false];
    self.selectedIndex = 1;
    //ZBeenPurchasedViewController *itemVC = [[ZBeenPurchasedViewController alloc] init];
    //[itemVC setHidesBottomBarWhenPushed:YES];
    //[itemVC setDefaultItemIndex:0];
    //[self.selectedViewController pushViewController:itemVC animated:NO];
}
///显示播放界面
-(void)setShowPlayVCWithPractice:(ModelPractice *)model
{
    UIViewController *itemVC = [[(ZRootViewController *)self.selectedViewController viewControllers] lastObject];
    if (itemVC) {
        [(ZBaseViewController *)itemVC showPlayVCWithPracticeArray:@[model] index:0];
    }
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
