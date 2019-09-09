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
#import "ZCircleViewController.h"
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

#define kShowVCAnimated YES

@interface ZTabBarViewController ()<UITabBarControllerDelegate>

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
    [[AppDelegate app] setRefreshAppConfig];
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
    OBJC_RELEASE(_btnFound);
    OBJC_RELEASE(_imgLine);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginChange:) name:ZLoginChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppNumberChange:) name:ZAppNumberChangeNotification object:nil];
    
    [self setDelegate:self];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.tabBar.width, kLineHeight)];
    [self.tabBar addSubview:self.imgLine];
    
    [self.tabBar setTranslucent:YES];
    [self.tabBar setShadowImage:[UIImage createImageWithColor:CLEARCOLOR]];
    [self.tabBar setBackgroundImage:[UIImage createImageWithColor:WHITECOLOR]];
    [self.tabBar setTintColor:TABBARTITLECOLOR];
    [self.tabBar setBarTintColor:RGBCOLOR(196, 196, 196)];
    if (APP_SYSTEM_VERSION >= 10) {
        [self.tabBar setUnselectedItemTintColor:RGBCOLOR(196, 196, 196)];
    }
    
    [self setRefreshUserInfo];
}
///设置主界面VC
-(void)setItemIcon
{
    if (self.viewControllers.count == 0) {
        
        ZHomeViewController *itemVC1 = [AppDelegate getViewControllerWithIdentifier:@"VCHomeSID"];
        [self setAddChildWithViewController:itemVC1 image:@"tabbar_btn_item1" selectedImage:@"tabbar_btn_item1_pre" title:kHome];
        ZRootViewController *itemRVC1 = [[ZRootViewController alloc] initWithRootViewController:itemVC1];
        
        ZBeenPurchasedViewController *itemVC2 = [AppDelegate getViewControllerWithIdentifier:@"VCBeenPurchasedSID"];
        [self setAddChildWithViewController:itemVC2 image:@"tabbar_btn_item2" selectedImage:@"tabbar_btn_item2_pre" title:kBeenPurchased];
        ZRootViewController *itemRVC2 = [[ZRootViewController alloc] initWithRootViewController:itemVC2];
        
        ZFoundViewController *itemVC3 = [AppDelegate getViewControllerWithIdentifier:@"VCFoundSID"];
        [self setAddChildWithViewController:itemVC3 image:@"tabbar_btn_item3" selectedImage:@"tabbar_btn_item3_pre" title:kFound];
        ZRootViewController *itemRVC3 = [[ZRootViewController alloc] initWithRootViewController:itemVC3];
        
        ZCircleViewController *itemVC4 = [AppDelegate getViewControllerWithIdentifier:@"VCCircleSID"];
        [self setAddChildWithViewController:itemVC4 image:@"tabbar_btn_item4" selectedImage:@"tabbar_btn_item4_pre" title:kCircle];
        ZRootViewController *itemRVC4 = [[ZRootViewController alloc] initWithRootViewController:itemVC4];
        
        ZUserInfoViewController *itemVC5 = [AppDelegate getViewControllerWithIdentifier:@"VCUserInfoSID"];
        [self setAddChildWithViewController:itemVC5 image:@"tabbar_btn_item5" selectedImage:@"tabbar_btn_item5_pre" title:kMyInfo];
        ZRootViewController *itemRVC5 = [[ZRootViewController alloc] initWithRootViewController:itemVC5];
        
        self.viewControllers = @[itemRVC1,itemRVC2,itemRVC3,itemRVC4,itemRVC5];
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        if (APP_SYSTEM_VERSION >= 10) {
            [tabBarItem setBadgeColor:MAINCOLOR];
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
    
    id obj = sender.object;
    NSString *itemIndex = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        itemIndex = (NSString *)obj;
        if (itemIndex && itemIndex.length > 0) {
            [(ZCircleViewController *)[(ZRootViewController *)[self.viewControllers objectAtIndex:3] topViewController] setScrollViewContentOffsetWithIndex:ZCircleToolViewItemHot];
        }
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        itemIndex = [obj objectForKey:@"index"];
        [(ZCircleViewController *)[(ZRootViewController *)[self.viewControllers objectAtIndex:3] topViewController] setScrollViewContentOffsetWithIndex:ZCircleToolViewItemNew];
    } else {
        itemIndex = @"0";
        [(ZCircleViewController *)[(ZRootViewController *)[self.viewControllers objectAtIndex:3] topViewController] setScrollViewContentOffsetWithIndex:ZCircleToolViewItemHot];
    }
}
///刷新用户数据
-(void)setRefreshUserInfo
{
    if (self.selectedIndex != 4 && [AppSetting getAutoLogin]) {
        ZWEAKSELF
        [snsV1 postGetUserInfoWithUserId:kLoginUserId resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                if (resultModel) {
                    [AppSetting setUserLogin:resultModel];
                    
                    [AppSetting save];
                    
                    if (resultModel.isShowAlert) {
                        GCDAfterBlock(1.5f, ^{
                            [ZAlertView showWithTitle:resultModel.alertTitle message:resultModel.alertContent];
                        });
                    }
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
    self.selectedIndex = 3;
    
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
    [itemRVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    itemRVC.navigationBar.shadowImage = [UIImage new];
    //[itemRVC setModalPresentationStyle:UIModalPresentationFullScreen];
    //[itemRVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:itemRVC animated:animated completion:nil];
}
///显示实务详情
-(void)setShowPracticeVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    [(ZBaseViewController *)[(ZRootViewController *)self.viewControllers.firstObject topViewController] setShowPlayVC:kShowVCAnimated];
}
///显示搜索问答
-(void)setShowSearchQuestionAnswerVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 3;
    
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
    
    [(ZHomeViewController *)[(ZRootViewController *)self.viewControllers.firstObject topViewController] setShowSearchPractice];
}
///注销登录
-(void)logout
{
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    [self setShowLoginVCWithAnimated:true];
}

#pragma mark - NotificationMethod

///登录改变
-(void)setLoginChange:(NSNotification *)sender
{
    
}
///数量改变
-(void)setAppNumberChange:(NSNotification *)sender
{
    if (self.viewControllers.count > 0) {
        if ([AppSetting getAutoLogin]) {
            ModelUser *model = [AppSetting getUserLogin];
            if (model) {
                int myNumber =model.myNoticeCenterCount
                + model.myWaitNewAns
                + model.shoppingCartCount
                + model.myMessageCount;
                if (myNumber == 0) {
                    [[self.tabBar.items lastObject] setBadgeValue:nil];
                    [[AppDelegate app] clearApplicationIcon];
                } else {
                    NSString *strNumber = [NSString stringWithFormat:@"%d", myNumber];
                    [[self.tabBar.items lastObject] setBadgeValue:strNumber];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:myNumber];
                }
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
    self.selectedIndex = 0;
    
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
                    [self.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
                    break;
                }
                case WTOpenParamTypeReportInfo://举报信息
                {
                    ModelNotice *modelN = [[ModelNotice alloc] init];
                    [modelN setIds:ids];
                    [modelN setNoticeTitle:title];
                    [modelN setNoticeType:ids.intValue];
                    [self setManagerInfoViewWithModel:modelN];
                    break;
                }
                case WTOpenParamTypeAppUpdate://更新
                {
                    ModelNotice *modelN = [[ModelNotice alloc] init];
                    [modelN setIds:ids];
                    [modelN setNoticeTitle:title];
                    [modelN setNoticeType:ids.intValue];
                    [self setManagerInfoViewWithModel:modelN];
                    break;
                }
                case WTOpenParamTypeManagerInfoView://梧桐管理员消息视图
                {
                    ModelNotice *modelN = [[ModelNotice alloc] init];
                    [modelN setIds:ids];
                    [modelN setNoticeTitle:title];
                    [modelN setNoticeType:ids.intValue];
                    [self setManagerInfoViewWithModel:modelN];
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
                        [weakSelf.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
                    } errorBlock:^(NSString *msg) {
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showError:msg];
                    }];
                    break;
                }
                default: break;
            }
        }
    }
}
///通知消息列表视图
-(void)setManagerInfoViewWithModel:(ModelNotice *)model
{
    ZNoticeDetailViewController *itemVC = [[ZNoticeDetailViewController alloc] init];
    [itemVC setTitle:model.noticeTitle];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
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
           [self.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
        } else {
            ZWEAKSELF
            [ZProgressHUD showMessage:kCMsgGeting];
            [snsV1 getQuerySpeechDetailWithSpeechId:ids userId:kLoginUserId resultBlock:^(NSDictionary *result) {
                [ZProgressHUD dismiss];
                NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                    
                    [sqlite setLocalPlayPracticeDetailWithModel:modelPractice userId:kLoginUserId];
                    
                    ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
                    [itemVC setRawdataWithArray:@[modelPractice] index:0];
                    [itemVC setHidesBottomBarWhenPushed:YES];
                    
                    [weakSelf.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
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
        if (model.isSubscribe) {
            ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
            [itemVC setViewDataWithModel:model];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
        } else {
            ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
            [itemVC setViewDataWithModel:model];
            [itemVC setViewDataWithModelDetail:model];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.viewControllers.firstObject pushViewController:itemVC animated:kShowVCAnimated];
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
    [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
}
///显示已购界面
-(void)setShowPurchaseVC
{
    ZBeenPurchasedViewController *itemVC = [[ZBeenPurchasedViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [itemVC setDefaultItemIndex:1];
    [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
}
///显示播放界面
-(void)setShowPlayVCWithPractice:(ModelPractice *)model
{
    UIViewController *itemVC = [(ZRootViewController *)self.viewControllers.firstObject topViewController];
    if (itemVC) {
        [(ZBaseViewController *)itemVC showPlayVCWithPracticeArray:@[model] index:0];
    }
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![AppSetting getAutoLogin] && [[(ZRootViewController*)viewController topViewController] isKindOfClass:[ZUserInfoViewController class]]) {
        [self setShowLoginVCWithAnimated:YES];
        return NO;
    }
    return YES;
}

@end
