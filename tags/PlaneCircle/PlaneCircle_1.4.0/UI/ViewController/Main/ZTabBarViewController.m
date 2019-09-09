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

#import "ZCircleViewController.h"
#import "ZPracticeViewController.h"
#import "ZRankViewController.h"
#import "ZUserInfoViewController.h"

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
#import "StatisticsManager.h"

#import "ZTabBarBadge.h"

@interface ZTabBarViewController ()<UITabBarControllerDelegate>

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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ZCatchCrash setDefaultHandler];
    
    [[AppDelegate app] setUncaughtException];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager endRecordPage:NSStringFromClass(self.class)];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZChangeTabbarItem object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLoginChangeNotification object:nil];
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
            [weakSelf.selectedViewController pushViewController:itemVC animated:YES];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setChangeTabbarItem:) name:ZChangeTabbarItem object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginChange:) name:ZLoginChangeNotification object:nil];
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
///改变Tabbar选中索引
-(void)setChangeTabbarItem:(NSNotification *)sender
{
    if (self.viewControllers.count > 0) {
        id obj = sender.object;
        NSString *itemIndex = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            itemIndex = (NSString *)obj;
            if (itemIndex && itemIndex.length > 0) {
                [(ZCircleViewController *)[(ZNavigationViewController *)self.viewControllers.firstObject topViewController] setScrollViewContentOffsetWithIndex:ZCircleToolViewItemHot];
            }
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            itemIndex = [obj objectForKey:@"index"];
            [(ZCircleViewController *)[(ZNavigationViewController *)self.viewControllers.firstObject topViewController] setScrollViewContentOffsetWithIndex:ZCircleToolViewItemNew];
        } else {
            itemIndex = @"0";
            [(ZCircleViewController *)[(ZNavigationViewController *)self.viewControllers.firstObject topViewController] setScrollViewContentOffsetWithIndex:ZCircleToolViewItemHot];
        }
        if (itemIndex && itemIndex.length > 0) {
            GCDMainBlock(^{
                self.selectedIndex = [itemIndex integerValue];
                
                [[AudioPlayerView shareAudioPlayerView] dismiss];
                if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
                    [[ZDragButton shareDragButton] show];
                } else {
                    [[ZDragButton shareDragButton] dismiss];
                }
            });
        }
    }
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
                    
                    [sqlite setLocalTaskArrayWithArray:[result objectForKey:@"myTask"] userId:resultModel.userId];
                    
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
        [[AudioPlayerView shareAudioPlayerView] dismiss];
        if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
            [[ZDragButton shareDragButton] show];
        } else {
            [[ZDragButton shareDragButton] dismiss];
        }
        ZCircleQuestionViewController *itemVC = [[ZCircleQuestionViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
    } else {
        ZCircleQuestionViewController *itemCQVC = [[ZCircleQuestionViewController alloc] init];
        [itemCQVC setHidesBottomBarWhenPushed:YES];
        [self.viewControllers.firstObject pushViewController:itemCQVC animated:NO];
        
        ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
        [itemVC setPreVC:self.viewControllers.firstObject];
        [itemVC setNavigationBarHidden:YES];
        [self.viewControllers.firstObject presentViewController:[[ZNavigationViewController alloc] initWithRootViewController:itemVC] animated:NO completion:nil];
    }
}
///显示实务详情
-(void)setShowPracticeVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 1;
    
    if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
        ModelPractice *modelP = [[AudioPlayerView shareAudioPlayerView] getPlayingModel];
        if (modelP) {
            ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
            [itemVC setIsPushVC:YES];
            [itemVC setViewDataWithModel:modelP];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [[self.viewControllers objectAtIndex:1] pushViewController:itemVC animated:NO];
        } else {
            [[ZDragButton shareDragButton] show];
            [[AudioPlayerView shareAudioPlayerView] dismiss];
        }
    } else {
        [[ZDragButton shareDragButton] dismiss];
        [[AudioPlayerView shareAudioPlayerView] dismiss];
    }
}
///显示搜索问答
-(void)setShowSearchQuestionAnswerVC
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    [[AudioPlayerView shareAudioPlayerView] dismiss];
    if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
        [[ZDragButton shareDragButton] show];
    } else {
        [[ZDragButton shareDragButton] dismiss];
    }
    
    [(ZCircleViewController*)[(ZNavigationViewController*)self.viewControllers.firstObject topViewController] setViewShowKeyboard];
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
        if ([AppSetting getAutoLogin]) {
            ModelUser *model = [AppSetting getUserLogin];
            
            int number = model.myQuesNewCount
            + model.myNoticeCenterCount
            + model.myAnswerCommentcount
            + model.myWaitNewAns;
            if (number == 0) {
                //隐藏
                [self.tabBar hideBadgeOnItemIndex:3];
                [[AppDelegate app] clearApplicationIcon];
            } else {
                //显示
                [self.tabBar showBadgeOnItemIndex:3 count:number];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
            }
        } else {
            [[AppDelegate app] clearApplicationIcon];
        }
    }
}

#pragma mark - ViewController

///设置主界面VC
-(void)setItemIcon
{
    if (self.viewControllers.count == 0) {
        
        ZCircleViewController *itemVC1 = [[ZCircleViewController alloc] init];
        [itemVC1 setNavigationBarHidden:YES];
        ZNavigationViewController *itemRVC1 = [[ZNavigationViewController alloc] initWithRootViewController:itemVC1];
        [itemRVC1.tabBarItem setTitle:kCircle];
        [itemRVC1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC1.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC1.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item1_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC1.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, -1, 0, 1))];
        
        ZPracticeViewController *itemVC2 = [[ZPracticeViewController alloc] init];
        ZNavigationViewController *itemRVC2 = [[ZNavigationViewController alloc] initWithRootViewController:itemVC2];
        [itemRVC2.tabBarItem setTitle:kPractice];
        [itemRVC2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC2.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC2.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item3_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC2.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, -0.5, 0, 0.5))];
        
        ZRankViewController *itemVC3 = [[ZRankViewController alloc] init];
        [itemVC3 setNavigationBarHidden:YES];
        ZNavigationViewController *itemRVC3 = [[ZNavigationViewController alloc] initWithRootViewController:itemVC3];
        [itemRVC3.tabBarItem setTitle:kRank];
        [itemRVC3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC3.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC3.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item2_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC3.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, -0.5, 0, 0.5))];
        
        ZUserInfoViewController *itemVC4 = [[ZUserInfoViewController alloc] init];
        ZNavigationViewController *itemRVC4 = [[ZNavigationViewController alloc] initWithRootViewController:itemVC4];
        [itemRVC4.tabBarItem setTitle:kMyInfo];
        [itemRVC4.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [itemRVC4.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ZFont systemFontOfSize:kFont_Minimum_Size],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [itemRVC4.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_btn_item4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC4.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_btn_item4_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [itemRVC4.tabBarItem setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        
        self.viewControllers = @[itemRVC1,itemRVC2,itemRVC3,itemRVC4];
        
        self.selectedViewController = itemRVC1;
        self.selectedIndex = 0;
    }
}

#pragma mark - NotificationEvent

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
-(void)setShowViewControllerWithParam:(NSDictionary *)dicParam
{
    [self setItemIcon];
    
    [self.selectedViewController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    
    [[AudioPlayerView shareAudioPlayerView] dismiss];
    if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
        [[ZDragButton shareDragButton] show];
    } else {
        [[ZDragButton shareDragButton] dismiss];
    }
    
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
                    [modelRC setCompany_name:kAccountingFirm];
                    [modelRC setType:WTRankTypeK];
                    [self setShowRankDetailVCWithModel:modelRC];
                    break;
                }
                case WTOpenParamTypeRankBroker://券商
                {
                    ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                    [modelRC setCompany_name:kSecuritiesCompany];
                    [modelRC setType:WTRankTypeZ];
                    [self setShowRankDetailVCWithModel:modelRC];
                    break;
                }
                case WTOpenParamTypeRankLawyer://律师
                {
                    ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                    [modelRC setCompany_name:kLawFirm];
                    [modelRC setType:WTRankTypeL];
                    [self setShowRankDetailVCWithModel:modelRC];
                    break;
                }
                case WTOpenParamTypeShareTrailer://分享预告
                {
                    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                    [itemVC setWebUrl:url];
                    [itemVC setTitle:title];
                    [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
                    [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
                    [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
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
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
    }
}
///显示律师|会计|证劵
-(void)setShowRankDetailVCWithModel:(ModelRankCompany *)modelRC
{
    ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
    [itemVC setViewDataWithModel:modelRC];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
}
///显示实务详情
-(void)setShowPracticeDetailVCWithId:(NSString *)ids
{
    if (ids && ![ids isKindOfClass:[NSNull class]]) {
        __weak typeof(self) weakSelf = self;
        [ZProgressHUD showMessage:kGetPracticeing];
        [sns getSpeechDetailWithSpeechId:ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dicReuslt];
                    
                    [sqlite setLocalPracticeWithModel:modelP];
                    
                    [weakSelf setShowPracticeVCWithModel:modelP];
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
///处理是否解锁
-(void)setShowPracticeVCWithModel:(ModelPractice *)model
{
    ///进行解锁的行为
    if (model.unlock == 1) {
        [self.selectedViewController popToRootViewControllerAnimated:NO];
        self.selectedIndex = 1;
    } else {
        [self.selectedViewController popToRootViewControllerAnimated:NO];
        self.selectedIndex = 0;
        
        ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
        [itemVC setIsPushVC:YES];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.viewControllers.firstObject pushViewController:itemVC animated:NO];
    }
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![AppSetting getAutoLogin] && [[(ZNavigationViewController*)viewController topViewController] isKindOfClass:[ZUserInfoViewController class]]) {
        [[ZDragButton shareDragButton] dismiss];
        
        ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
        [itemVC setPreVC:self];
        [itemVC setNavigationBarHidden:YES];
        [self presentViewController:[[ZNavigationViewController alloc] initWithRootViewController:itemVC] animated:YES completion:nil];
        return NO;
    }
    return YES;
}

@end
