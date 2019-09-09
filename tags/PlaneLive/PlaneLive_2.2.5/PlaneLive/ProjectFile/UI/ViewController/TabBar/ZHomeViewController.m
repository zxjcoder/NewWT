//
//  ZHomeViewController.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeViewController.h"
#import "ZNewHomeNavigationView.h"
#import "ZNewHomeView.h"
#import "ZSearchViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZPracticeTypeViewController.h"
#import "StatisticsManager.h"
#import "ZLawFirmListViewController.h"
#import "ZSubscribeTypeViewController.h"
#import "ZCurriculumListViewController.h"
#import "ZHomeSubscribeTrailerView.h"
#import "ZLawFirmDetailViewController.h"
#import "ZUserDownloadViewController.h"
#import "ZPracticeFreeViewController.h"
#import "ZPlayerViewController.h"

/// 使用的是Version225版本
@interface ZHomeViewController ()

///上次导航栏透明度
@property (assign, nonatomic) CGFloat navLastAlpha;
///主视图
@property (strong, nonatomic) ZNewHomeView *viewMain;
///顶部搜索区域
@property (strong, nonatomic) ZNewHomeNavigationView *viewNavigation;
///返回数据对象
@property (strong, nonatomic) NSDictionary *dicResult;

@end

@implementation ZHomeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kHome];
    [self innerInit];
    // TODO:ZWW备注-开关引导页
    [[AppDelegate app] setShowBootVC];
    
    [self registerLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess) name:ZCartPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSubscribePaySuccess) name:ZSubscribeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayChangeList:) name:ZPlayerChangeListNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPracticePaySuccess) name:ZPracticePaySuccessNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAlpha:self.navLastAlpha];
    [self.viewNavigation setHidden:false];
    [self.viewNavigation setViewBackAlpha:self.navLastAlpha];
    [self.viewMain adjustWhenControllerViewWillAppera];
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageHomeKey];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageHomeKey dictionary:nil];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZSubscribeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCartPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayerChangeListNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticePaySuccessNotification object:nil];
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_viewNavigation);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.viewNavigation = [[ZNewHomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_NAVIGATION_HEIGHT)];
    [self.navigationItem setTitleView:self.viewNavigation];
    
    CGRect tvFrame = CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT);
    self.viewMain = [[ZNewHomeView alloc] initWithFrame:tvFrame];
    [self.view addSubview:self.viewMain];
    
    [self setInnerEvent];
    [self innerData];
    [super innerInit];
    [self setNavBarAlpha:0];
}
#define kNewHomeDataKey @"kNewHomeData"
-(void)innerData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kNewHomeDataKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        [self setDicResult:dicLocal];
        [self.viewMain setViewData:dicLocal];
    }
    [self setRefreshHeader];
}
///刷新主页面顶部数据
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getV6HomeDataResultBlock:^(NSDictionary *result) {
        [weakSelf.viewMain setViewData:result];
        [weakSelf.viewMain endRefreshHeader];
        [weakSelf setDicResult:result];
        [sqlite setLocalCacheDataWithDictionary:result pathKay:kNewHomeDataKey];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshHeader];
    }];
}
-(void)setInnerEvent
{
    ZWEAKSELF
    [self.viewNavigation setOnSearchClick:^{
        [weakSelf btnSearchClick];
    }];
    [self.viewNavigation setOnDownloadClick:^{
        [weakSelf setShowDownloadVC];
    }];
    [self.viewMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.viewMain setOnContentOffsetClick:^(CGFloat contentOffsetY, CGFloat bannerHeight) {
        [weakSelf setContentOffsetEvent:contentOffsetY bannerHeight:bannerHeight];
    }];
    [self.viewMain setOnBannerClick:^(ModelBanner *model) {
        [weakSelf setBannerEvent:model];
    }];
    [self.viewMain setOnAllFreeClick:^{
        [weakSelf setShowFreeAll];
    }];
    [self.viewMain setOnAllPracticeClick:^{
        [weakSelf setShowPracticeAll];
    }];
    [self.viewMain setOnAllLawFirmClick:^{
        [weakSelf setShowLawFirmAll];
    }];
    [self.viewMain setOnAllSubscribeClick:^{
        [weakSelf setShowSubscribeAll];
    }];
    [self.viewMain setOnAllCurriculumClick:^{
        [weakSelf setShowCurriculumAll];
    }];
    [self.viewMain setOnPracticeClick:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPracticeVC:array row:row];
    }];
    [self.viewMain setOnSubscribeClick:^(ModelSubscribe *model) {
        [weakSelf setShowSubscribeVC:model];
    }];
    [self.viewMain setOnCurriculumClick:^(ModelSubscribe *model) {
        [weakSelf setShowSubscribeVC:model];
    }];
    [self.viewMain setOnWhatCurriculumClick:^{
        [weakSelf setWhatCurriculumEvent];
    }];
    [self.viewMain setOnWhatSubscribeClick:^{
        [weakSelf setWhatSubscribeEvent];
    }];
    [self.viewMain setOnLawFirmClick:^(ModelLawFirm *model) {
        [weakSelf setShowLawFirm:model];
    }];
    [self.viewMain setOnFreeItemClick:^(NSArray *array, NSInteger row) {
        [weakSelf setShowFreePracticeVC:array row:row];
    }];
}
///登录改变通知
-(void)setLoginChange
{
    [self setRefreshHeader];
}
///购物车购买成功通知
-(void)setCartPaySuccess
{
    [self setRefreshHeader];
}
///购买单个微课成功通知
-(void)setPracticePaySuccess
{
    [self setRefreshHeader];
}
///订阅成功通知
-(void)setSubscribePaySuccess
{
    [self setRefreshHeader];
}
///播放列表改变通知
-(void)setPlayChangeList:(NSNotification *)sender
{
    if (self.viewPlay) {
        [self.viewPlay setViewData:[ZPlayerViewController sharedSingleton].modelTrack row:[ZPlayerViewController sharedSingleton].playIndex];
    }
    if (self.viewMain) {
        GCDMainBlock(^{
            [self.viewMain setPlayObject:[ZPlayerViewController sharedSingleton].modelTrack isPlaying:[sender.object boolValue]];
        });
    }
}
///显示订阅详情
-(void)showSubscribeDetailVCWithModel:(ModelSubscribe *)model
{
    if (!model.isSubscribe) {
        ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
        [itemVC setViewDataWithSubscribeModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
///显示搜索页面
-(void)setShowSearchVC
{
    ZSearchViewController *itemVC = [[ZSearchViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:true];
    [self.navigationController pushViewController:itemVC animated:true];
}
///显示下载页面
-(void)setShowDownloadVC
{
    if ([AppSetting getAutoLogin]) {
        ZUserDownloadViewController *itemVC = [[ZUserDownloadViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:true];
        [self.navigationController pushViewController:itemVC animated:true];
    } else {
        [self showLoginVC];
    }
}
///广告点击
-(void)setBannerEvent:(ModelBanner *)model
{
    ZWEAKSELF
    [StatisticsManager event:kHomepage_Banner dictionary:@{kObjectId: model.ids==nil?kEmpty:model.ids,
                                                           kObjectTitle: model.title==nil?kEmpty:model.title,
                                                           kObjectUser: [AppSetting getUserId]}];
    switch (model.type) {
        case ZBannerTypePractice://实务
        {
            [ZProgressHUD showMessage:kCMsgGeting];
            [snsV1 getQuerySpeechDetailWithSpeechId:model.code userId:kLoginUserId resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                    if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                        ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                        
                        [sqlite setLocalPlayPracticeDetailWithModel:modelPractice userId:kLoginUserId];
                        
                        [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                    } else {
                        [ZProgressHUD showError:kGetInfoFail];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:msg];
                });
            }];
            break;
        }
        case ZBannerTypeNews://新闻
        {
            [weakSelf showWebVCWithModel:model];
            break;
        }
        case ZBannerTypeQuestion://问题
        {
            ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
            [modelQB setIds:model.code];
            [modelQB setTitle:model.title];
            [weakSelf showQuestionDetailVC:modelQB];
            break;
        }
        case ZBannerTypeSubscribe://订阅
        case ZBannerTypeSerialCourse://系列课
        case ZBannerTypeTrainingCourse:///培训课
        {
            ModelSubscribeDetail *modelSD = [sqlite getLocalSubscribeDetailWithUserId:kLoginUserId subscribeId:model.code];
            if (modelSD && modelSD.ids) {
                [weakSelf showSubscribeDetailVCWithModel:modelSD];
            } else {
                [ZProgressHUD showMessage:kGetSubscriptioning];
                [snsV2 getSubscribeRecommendArrayWithSubscribeId:model.code resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    if (model) {
                        [weakSelf showSubscribeDetailVCWithModel:model];
                        [sqlite setLocalSubscribeDetailWithModel:model userId:kLoginUserId];
                    } else {
                        [ZProgressHUD showError:kGetSubscriptionInfoFail];
                    }
                } errorBlock:^(NSString *msg) {
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:msg];
                }];
            }
            break;
        }
        default: break;
    }

}
///免费专区更多按钮点击
-(void)setShowFreeAll
{
    ZPracticeFreeViewController *itemVC = [[ZPracticeFreeViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:true];
    [self.navigationController pushViewController:itemVC animated:true];
}
///实务全部按钮点击事件
-(void)setShowPracticeAll
{
    [StatisticsManager event:kHomepage_PracticeAll];
    ZPracticeTypeViewController *itemVC = [[ZPracticeTypeViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///实务免费列表播放
-(void)setShowFreePracticeVC:(NSArray *)array row:(NSInteger)row
{
    [sqlite setSysParam:kSQLITE_CLOSE_PLAY_VIEW value:@"false"];
    if (row < array.count) {
        ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
        ModelPractice *modelPlay = [array objectAtIndex:row];
        if ([[modelPlay.ids stringByAppendingString:kMultipleZeros] integerValue] == itemVC.modelTrack.trackId) {
            if ([ZPlayerViewController sharedSingleton].isPlaying) {
                [itemVC setStopPlay];
            } else {
                [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
                [itemVC setRawdataWithArray:array index:row];
                
                [itemVC setStartPlay];
            }
        } else {
            [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
            [itemVC setRawdataWithArray:array index:row];
            
            [itemVC setStartPlay];
        }
        [self innerPlayInit];
    }
}
///实务单个按钮点击事件
-(void)setShowPracticeVC:(NSArray *)array row:(NSInteger)row
{
    if (array.count > 0 && row < array.count) {
        ModelPractice *modelP = [array objectAtIndex:row];
        [StatisticsManager event:kHomepage_Practice_ListItem dictionary:@{kObjectId:modelP.ids==nil?kEmpty:modelP.ids,kObjectTitle:modelP.title==nil?kEmpty:modelP.title,kObjectUser:kLoginUserId}];
    }
    [self showPlayVCWithPracticeArray:array index:row];
}
///偏移量
-(void)setContentOffsetEvent:(CGFloat)offsetY bannerHeight:(CGFloat)bannerHeight
{
    if (offsetY < -10) {
        [self.viewNavigation setHidden:true];
    } else {
        [self.viewNavigation setHidden:false];
    }
    CGFloat alpha = offsetY / (bannerHeight-APP_TOP_HEIGHT);
    if (alpha > 1) { alpha = 1; }
    else if (alpha < 0) { alpha = 0; }
    [self setNavLastAlpha:alpha];
    [self setNavBarAlpha:alpha];
    [self.viewNavigation setViewBackAlpha:alpha];
}
///全部律所
-(void)setShowLawFirmAll
{
    [StatisticsManager event:kHomepage_ProfessionalOrganizationsAll];
    ZLawFirmListViewController *itemVC= [[ZLawFirmListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///律所
-(void)setShowLawFirm:(ModelLawFirm *)model
{
    [StatisticsManager event:kHomepage_ProfessionalOrganizations_ListItem dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
    ZLawFirmDetailViewController *itemVC= [[ZLawFirmDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///全部订阅
-(void)setShowSubscribeAll
{
    [StatisticsManager event:kHomepage_PopularTrainingAll];
    ZSubscribeTypeViewController *itemVC = [[ZSubscribeTypeViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///全部系列课
-(void)setShowCurriculumAll
{
    [StatisticsManager event:kHomepage_SeriesCourseAll];
    ZCurriculumListViewController *itemVC = [[ZCurriculumListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///订阅单个事件
-(void)setShowSubscribeVC:(ModelSubscribe *)model
{
    if (model && model.ids && model.title) {
        [StatisticsManager event:kHomepageSeries_Training_ListItem dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
    }
    switch (model.type) {
        case 1:
        {
            ZHomeSubscribeTrailerView *subscribeTrailerView = [[ZHomeSubscribeTrailerView alloc] initWithModel:model];
            [subscribeTrailerView show];
            break;
        }
        default:
            [self showSubscribeDetailVCWithModel:model];
            break;
    }
}
///系列课点击
-(void)setShowCurriculumVC:(ModelSubscribe *)model
{
    if (model && model.ids && model.title) {
        [StatisticsManager event:kHomepageSeries_Lessons_ListItem dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
    }
    switch (model.type) {
        case 1:
        {
            ZHomeSubscribeTrailerView *subscribeTrailerView = [[ZHomeSubscribeTrailerView alloc] initWithModel:model];
            [subscribeTrailerView show];
            break;
        }
        default:
            [self showSubscribeDetailVCWithModel:model];
            break;
    }
}
///什么是订阅点击
-(void)setWhatSubscribeEvent
{
    if (self.dicResult != nil) {
        NSDictionary *dicResult = [self.dicResult objectForKey:kResultKey];
        if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
            NSString *url = [dicResult objectForKey:@"courseNote"];
            if (url && [url isKindOfClass:[NSString class]]) {
                [self showWebVCWithUrl:url title:kWhatIsASubscription];
            }
        }
    }
}
///什么是系列课点击
-(void)setWhatCurriculumEvent
{
    if (self.dicResult != nil) {
        NSDictionary *dicResult = [self.dicResult objectForKey:kResultKey];
        if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
            NSString *url = [dicResult objectForKey:@"seriesCourseNote"];
            if (url && [url isKindOfClass:[NSString class]]) {
                [self showWebVCWithUrl:url title:kWhatIsSeriesOfLessons];
            }
        }
    }
}

@end
