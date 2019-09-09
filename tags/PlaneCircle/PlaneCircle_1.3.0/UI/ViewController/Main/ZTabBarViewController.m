//
//  ZTabBarViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarViewController.h"
#import "ZNavigationViewController.h"
#import "ZRootViewController.h"
#import "ZLoginViewController.h"
#import "ZUserInfoViewController.h"
#import "AppDelegate.h"

#import "ZQuestionDetailViewController.h"
#import "ZAnswerDetailViewController.h"
#import "ZUserProfileViewController.h"

#import "ZRankCompanyViewController.h"
#import "ZRankDetailViewController.h"
#import "ZRankUserViewController.h"

#import "ZPracticeQuestionViewController.h"

#import "ZNoticeDetailViewController.h"
#import "ZWebViewController.h"
#import "ZCircleQuestionViewController.h"

#import "AudioPlayerView.h"
#import "ZCatchCrash.h"

//tabbar的数量 如果是5个设置为5.0
#define kTabbarItemNums 4.0

@implementation UITabBar (badge)

///显示小红点
- (void)showBadgeOnItemIndex:(int)index count:(int)count
{
    //移除之前的小红点
    //[self removeBadgeOnItemIndex:index];
    
    CGFloat size = 18;
    //新建小红点
    UILabel *badgeView = [self viewWithTag:888 + index];
    if (badgeView == nil) {
        badgeView =  [[UILabel alloc] init];
    }
    badgeView.tag = 888 + index;
    badgeView.layer.masksToBounds = YES;
    badgeView.layer.cornerRadius = size/2;
    badgeView.backgroundColor = MAINCOLOR;
    badgeView.text = [NSString stringWithFormat:@"%d",(count>99?99:count)];
    badgeView.textColor = WHITECOLOR;
    badgeView.font = [ZFont systemFontOfSize:kFont_Minimum_Size];
    [badgeView setTextAlignment:(NSTextAlignmentCenter)];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.56) / kTabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.05 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, size, size);
    [self addSubview:badgeView];
}
///隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index
{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
///移除小红点
- (void)removeBadgeOnItemIndex:(int)index
{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end

@interface ZTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation ZTabBarViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    GCDGlobalBlock(^{
        [ZCatchCrash setDefaultHandler];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    
    [self setItemIcon];
    
    [self setRefreshUserInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZShowQuestionVCNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLoginChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZShowViewControllerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayShowViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayEnabledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZAppNumberChangeNotification object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [AudioPlayerView shareAudioPlayerView];
    
    __weak typeof(self) weakSelf = self;
    [[ZDragButton shareDragButton] setTapClickBlock:^() {
        NSArray *arrPractice = [[ZDragButton shareDragButton] getPlayArray];
        NSInteger rowIndex = [[ZDragButton shareDragButton] getPlayRowIndex];
        ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
        [itemVC setPreVC:self];
        ModelPractice *model = [arrPractice objectAtIndex:rowIndex];
        if ([AppSetting getAutoLogin]) {
            ModelPractice *modelLocal = [sqlite getLocalPracticeDetailModelWithId:model.ids userId:[AppSetting getUserDetauleId]];
            if (modelLocal) {
                [itemVC setViewDataWithModel:modelLocal];
            } else {
                [itemVC setViewDataWithModel:model];
            }
        } else {
            [itemVC setViewDataWithModel:model];
        }
        [itemVC setViewDataWithArray:arrPractice arrDefaultRow:rowIndex];
        [itemVC setHidesBottomBarWhenPushed:YES];
        GCDMainBlock(^{
            [weakSelf.selectedViewController.navigationController pushViewController:itemVC animated:YES];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShowQuestionVC:) name:ZShowQuestionVCNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginChange:) name:ZLoginChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShowViewControllerWithParam:) name:ZShowViewControllerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayShowView:) name:ZPlayShowViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayCancel:) name:ZPlayCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayStart:) name:ZPlayStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayEnabled:) name:ZPlayEnabledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayRemote:) name:ZPlayRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppNumberChange:) name:ZAppNumberChangeNotification object:nil];
    
    [self setDelegate:self];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setTintColor:TABBARTINT_BACKCOLOR2];
    [self.tabBar setBarTintColor:TABBARTINT_BACKCOLOR1];
}
///刷新用户数据
-(void)setRefreshUserInfo
{
    if (self.selectedIndex != 3 && [AppSetting getAutoLogin]) {
        ZWEAKSELF
        [sns postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
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

#pragma mark - NotificationMethod

///登录改变
-(void)setLoginChange:(NSNotification *)sender
{
    [self setAppNumberChange:nil];
}
///数量改变
-(void)setAppNumberChange:(NSNotification *)sender
{
    if (self.viewControllers.count > 0) {
        ModelUser *model = [AppSetting getUserLogin];
        
        int number = model.myQuesNewCount
        + model.myNoticeCenterCount
        + model.myAnswerCommentcount
        + model.myWaitNewAns;
        if (number == 0) {
            //隐藏
            [self.tabBar hideBadgeOnItemIndex:3];
        } else {
            //显示
            [self.tabBar showBadgeOnItemIndex:3 count:number];
        }
    }
}

#pragma mark - ViewController

///设置主界面VC
-(void)setItemIcon
{
    if (self.viewControllers.count == 0) {
        
        ZNavigationViewController *itemRVC1 = [AppDelegate getViewControllerWithIdentifier:@"VC_NavItem1_ID"];
        [itemRVC1.tabBarItem setTitle:@"圈子"];
        [itemRVC1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC1.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC1.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item1_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC1.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, -1, 0, 1))];
        
        ZNavigationViewController *itemRVC3 = [AppDelegate getViewControllerWithIdentifier:@"VC_NavItem3_ID"];
        [itemRVC3.tabBarItem setTitle:@"实务"];
        [itemRVC3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC3.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC3.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item3_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC3.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, -0.5, 0, 0.5))];
        
        ZNavigationViewController *itemRVC2 = [AppDelegate getViewControllerWithIdentifier:@"VC_NavItem2_ID"];
        [itemRVC2.tabBarItem setTitle:@"榜单"];
        [itemRVC2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC2.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC2.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item2_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC2.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, -0.5, 0, 0.5))];
        
        ZNavigationViewController *itemRVC4 = [AppDelegate getViewControllerWithIdentifier:@"VC_NavItem4_ID"];
        [itemRVC4.tabBarItem setTitle:@"我的"];
        [itemRVC4.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC4.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC4.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC4.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item4_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC4.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        
        self.viewControllers = @[itemRVC1,itemRVC3,itemRVC2,itemRVC4];
    }
}

#pragma mark - NotificationEvent

///显示问题提问页面
-(void)setShowQuestionVC:(NSNotification *)sender
{
    [self.selectedViewController.navigationController popToRootViewControllerAnimated:NO];
    ZCircleQuestionViewController *itemVC = [[ZCircleQuestionViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
}
///显示播放控件
-(void)setPlayShowView:(NSNotification *)sender
{
    BOOL isShow = [sender.object boolValue];
    if (isShow) {
        [[AudioPlayerView shareAudioPlayerView] show];
    } else {
        [[AudioPlayerView shareAudioPlayerView] dismiss];
    }
}
///设置播放按钮能不能点击
-(void)setPlayEnabled:(NSNotification *)sender
{
    BOOL isEnabled = [sender.object boolValue];
    [[AudioPlayerView shareAudioPlayerView] setOperButtonEnabled:isEnabled];
}
///取消播放
-(void)setPlayCancel:(NSNotification *)sender
{
    [[AudioPlayerView shareAudioPlayerView] pause];
}
///开始播放
-(void)setPlayStart:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    NSArray *arr = [dicParam objectForKey:@"array"];
    NSString *index = [dicParam objectForKey:@"index"];
    if (arr && arr.count > 0 && index) {
        [[AudioPlayerView shareAudioPlayerView] setPlayArray:arr index:[index integerValue]];
    }
}
///远程操作通知
-(void)setPlayRemote:(NSNotification *)sender
{
    [[AudioPlayerView shareAudioPlayerView] setPlayRemoteControlReceivedWithEvent:sender.object];
}
///收到显示对应模块页面的通知
-(void)setShowViewControllerWithParam:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    if (dicParam && [dicParam isKindOfClass:[NSDictionary class]]) {
        //type: 0问题，1答案，2实务，3用户，4榜单人员，5机构，6会计，7券商，8律所
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
                case WTOpenParamTypeRankUser://机构->用户
                {
                    [self setShowRankUserVCWithId:ids];
                    break;
                }
                case WTOpenParamTypeRankOrganization://机构->业绩清单
                {
                    [self setShowRankCompanyVCWithId:ids];
                    break;
                }
                case WTOpenParamTypeRankAccounting://会计
                {
                    ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                    [modelRC setCompany_name:@"会计事务所"];
                    [modelRC setType:WTRankTypeK];
                    [self setShowRankDetailVCWithModel:modelRC];
                    break;
                }
                case WTOpenParamTypeRankBroker://券商
                {
                    ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                    [modelRC setCompany_name:@"证券公司"];
                    [modelRC setType:WTRankTypeZ];
                    [self setShowRankDetailVCWithModel:modelRC];
                    break;
                }
                case WTOpenParamTypeRankLawyer://律师
                {
                    ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                    [modelRC setCompany_name:@"律师事务所"];
                    [modelRC setType:WTRankTypeL];
                    [self setShowRankDetailVCWithModel:modelRC];
                    break;
                }
                case WTOpenParamTypeShareTrailer://分享预告
                {
                    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                    [itemVC setWebUrl:url];
                    [itemVC setTitle:title];
                    [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
                    break;
                }
                case WTOpenParamTypeReportInfo://举报信息
                {
                    ZNoticeDetailViewController *itemVC = [[ZNoticeDetailViewController alloc] init];
                    [itemVC setTitle:title];
                    ModelNotice *modelN = [[ModelNotice alloc] init];
                    [modelN setIds:ids];
                    [itemVC setTitle:title];
                    [modelN setNoticeType:ids.intValue];
                    [itemVC setViewDataWithModel:modelN];
                    [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
                    break;
                }
                case WTOpenParamTypeAppUpdate://更新
                {
                    ZNoticeDetailViewController *itemVC = [[ZNoticeDetailViewController alloc] init];
                    [itemVC setTitle:title];
                    ModelNotice *modelN = [[ModelNotice alloc] init];
                    [modelN setIds:ids];
                    [modelN setNoticeType:ids.intValue];
                    [itemVC setViewDataWithModel:modelN];
                    [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
                    break;
                }
                default: break;
            }
        }
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
        [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
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
        [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
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
        [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
    }
}
///显示机构->公司
-(void)setShowRankCompanyVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
        [modelRC setIds:ids];
        
        ZRankCompanyViewController *itemVC = [[ZRankCompanyViewController alloc] init];
        [itemVC setViewDataWithModel:modelRC];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
    }
}
///显示机构->人员
-(void)setShowRankUserVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        ModelRankUser *modelRU = [[ModelRankUser alloc] init];
        [modelRU setIds:ids];
        
        ZRankUserViewController *itemVC = [[ZRankUserViewController alloc] init];
        [itemVC setViewDataWithModel:modelRU];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
    }
}
///显示律师|会计|证劵
-(void)setShowRankDetailVCWithModel:(ModelRankCompany *)modelRC
{
    ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
    [itemVC setViewDataWithModel:modelRC];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
}
///显示实务详情
-(void)setShowPracticeDetailVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        ModelPractice *modelL = [sqlite getLocalPracticeModelWithId:ids];
        if (modelL) {
            ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
            [itemVC setIsPushVC:YES];
            [itemVC setViewDataWithModel:modelL];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.selectedViewController.navigationController pushViewController:itemVC animated:NO];
        } else {
            __weak typeof(self) weakSelf = self;
            [ZProgressHUD showMessage:@"获取语音,请稍等..."];
            [sns getQuerySpeechDetailWithSpeechId:ids userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                    if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                        ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dicReuslt];
                        
                        [sqlite setLocalPracticeWithModel:modelP];
                        
                        ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
                        [itemVC setIsPushVC:YES];
                        [itemVC setViewDataWithModel:modelP];
                        [itemVC setHidesBottomBarWhenPushed:YES];
                        [weakSelf.selectedViewController.navigationController pushViewController:itemVC animated:NO];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    }
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![AppSetting getAutoLogin] && [[(ZNavigationViewController*)viewController topViewController] isKindOfClass:[ZUserInfoViewController class]]) {
        ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
        [itemVC setNavigationBarHidden:YES];
        [self presentViewController:[[ZNavigationViewController alloc] initWithRootViewController:itemVC] animated:YES completion:nil];
        return NO;
    }
    return YES;
}

@end
