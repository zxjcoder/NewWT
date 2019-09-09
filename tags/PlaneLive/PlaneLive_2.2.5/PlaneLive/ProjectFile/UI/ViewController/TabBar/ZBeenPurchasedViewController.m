//
//  ZBeenPurchasedViewController.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBeenPurchasedViewController.h"
#import "ZPurchasedNavigationView.h"
#import "ZPurchasePracticeTableView.h"
#import "ZPurchaseSubscribeTableView.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZPurchaseAllTableView.h"
#import "ZAccountBindViewController.h"

@interface ZBeenPurchasedViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scrollView;
@property (strong, nonatomic) ZPurchasedNavigationView *viewNavigation;
@property (strong, nonatomic) ZPurchaseAllTableView *tvAll;
@property (strong, nonatomic) ZPurchasePracticeTableView *tvPractice;
@property (strong, nonatomic) ZPurchaseSubscribeTableView *tvCurriculum;
@property (strong, nonatomic) ZPurchaseSubscribeTableView *tvSubscribe;

@property (strong, nonatomic) NSMutableArray *arrAll;
@property (strong, nonatomic) NSMutableArray *arrPractice;
@property (strong, nonatomic) NSMutableArray *arrSubscribe;
@property (strong, nonatomic) NSMutableArray *arrCurriculum;

@property (assign, nonatomic) int pageNumberAll;
@property (assign, nonatomic) int pageNumberPractice;
@property (assign, nonatomic) int pageNumberSubscribe;
@property (assign, nonatomic) int pageNumberCurriculum;
@property (assign, nonatomic) NSInteger tabIndex;

@property (assign, nonatomic) int unReadTotalCountSubscribe;
@property (assign, nonatomic) int unReadTotalCountCurriculum;

@end

@implementation ZBeenPurchasedViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kBeenPurchased];
    [self innerInit];
    [self registerLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSubscribeSuccess) name:ZSubscribeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess) name:ZCartPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPracticePaySuccess) name:ZPracticePaySuccessNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.viewNavigation setLineFrame];
    if (![AppSetting getAutoLogin]) {
        [self.viewNavigation setCurriculumPoint:0];
        [self.viewNavigation setSubscriptionPoint:0];
    } else {
        [self setAllBindShow];
    }
    [self setStatisticsWithIndex:self.tabIndex];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setStatisticsWithIndex:self.tabIndex];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        //[self setViewNil];
    }
}
-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZSubscribeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCartPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticePaySuccessNotification object:nil];
    [self removeLoginChangeNotification];
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_arrPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_arrSubscribe);
    OBJC_RELEASE(_tvCurriculum);
    OBJC_RELEASE(_arrCurriculum);
    OBJC_RELEASE(_viewNavigation);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrPractice = [NSMutableArray array];
    self.arrSubscribe = [NSMutableArray array];
    ZWEAKSELF
    self.viewNavigation = [[ZPurchasedNavigationView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_NAVIGATION_HEIGHT)];
    [self.viewNavigation setOnSearchClick:^{
        [weakSelf btnSearchClick];
    }];
    [self.viewNavigation setOnItemClick:^(NSInteger index) {
        
        weakSelf.tabIndex = index;
        [weakSelf setStatisticsWithIndex:index];
        switch (index) {
            case 1:
                [StatisticsManager event:kPurchase_Training];
                break;
            case 2:
                [StatisticsManager event:kPurchase_EriesCourse];
                break;
            default:
                [StatisticsManager event:kPurchase_Practice];
                break;
        }
        [weakSelf setViewContentOffsetWithIndex:index];
    }];
    [self.navigationItem setTitleView:self.viewNavigation];
    
    CGRect scViewFrame = VIEW_TABB_FRAME;
    self.scrollView = [[ZScrollView alloc] initWithFrame:scViewFrame];
    [self.scrollView setBounces:NO];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * [self.viewNavigation getNavItemCount], 0)];
    [self.view addSubview:self.scrollView];
    
    //设置初始化偏移
//    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * self.tabIndex, 0)];
//    if (self.tabIndex == 0) {
//        [self.viewNavigation setChangeItemIndex:self.tabIndex];
//        [self.viewNavigation setOffsetChange:self.tabIndex];
//    }
    
    self.tvAll = [[ZPurchaseAllTableView alloc] initWithFrame:(CGRectMake(0, 0, self.scrollView.width, self.scrollView.height))];
    [self.tvAll setScrollsToTop:true];
    [self.scrollView addSubview:self.tvAll];
    
    self.tvPractice = [[ZPurchasePracticeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvPractice setScrollsToTop:NO];
    [self.scrollView addSubview:self.tvPractice];
    
    self.tvCurriculum = [[ZPurchaseSubscribeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvCurriculum setScrollsToTop:NO];
    [self.scrollView addSubview:self.tvCurriculum];
    
    self.tvSubscribe = [[ZPurchaseSubscribeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width*3, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvSubscribe setScrollsToTop:YES];
    [self.scrollView addSubview:self.tvSubscribe];
    
    [self setAllBindShow];
    [self setTVAllEvent];
    [self setTVPracticeEvent];
    [self setTVSubscribeEvent];
    [self setTvCurriculumEvent];
    
    [super innerInit];
    
    [self innerDataAll];
    [self innerDataPractice];
    [self innerDataSubscribe];
    [self innerDataCurriculum];
}
-(void)setAllBindShow
{
    ModelUser *modelU = [AppSetting getUserLogin];
    switch (modelU.loginType) {
        case WTAccountTypeWeChat: [self.tvAll setShowBindCell:modelU.phone.length == 0]; break;
        default: break;
    }
}
-(void)setTVAllEvent
{
    ZWEAKSELF
    [self.tvAll setOnBackgroundClick:^(ZBackgroundState state) {
        switch (state) {
            case ZBackgroundStateLoginNull: [weakSelf showLoginVC]; break;
            default: break;
        }
    }];
    [self.tvAll setOnRefreshHeader:^{
        if ([AppSetting getAutoLogin]) {
            [weakSelf setRefreshHeaderAll];
        } else {
            [weakSelf.tvAll endRefreshHeader];
            [weakSelf.tvAll setViewDataWithNoLogin];
        }
    }];
    [self.tvAll setOnRefreshFooter:^{
        [weakSelf setRefreshFooterAll];
    }];
    /// 实务点击
    [self.tvAll setOnPracticeSelected:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    /// 系列课培训课点击
    [self.tvAll setOnSubscribeSelected:^(ModelSubscribe *model) {
        
        [StatisticsManager event:kPurchase_Training_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
        
        [weakSelf showSubscribeDetailVC:model];
    }];
    /// 绑定手机号
    [self.tvAll setOnBindEvent:^{
        [weakSelf showAccountBindPhoneVC];
    }];
}
/// 绑定手机号
-(void)showAccountBindPhoneVC
{
    ZAccountBindViewController *itemVC = [[ZAccountBindViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
-(void)setTVPracticeEvent
{
    ZWEAKSELF
    [self.tvPractice setOnBackgroundClick:^(ZBackgroundState state) {
        switch (state) {
            case ZBackgroundStateLoginNull: [weakSelf showLoginVC]; break;
            default:
                [weakSelf.tvPractice setBackgroundViewWithState:(ZBackgroundStateLoading)];
                [weakSelf setRefreshHeaderPractice];
                break;
        }
    }];
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        
        ModelPractice *model = [array objectAtIndex:row];
        if (model && model.ids && model.title) {
            [StatisticsManager event:kPurchase_Practice_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
        } else {
            [StatisticsManager event:kPurchase_Practice_ListItem];
        }
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.tvPractice setOnRefreshHeader:^{
        if ([AppSetting getAutoLogin]) {
            [weakSelf setRefreshHeaderPractice];
        } else {
            [weakSelf.tvPractice endRefreshHeader];
            [weakSelf.tvPractice setViewDataWithNoLogin];
        }
    }];
    [self.tvPractice setOnRefreshFooter:^{
        [weakSelf setRefreshFooterPractice];
    }];
}
-(void)setTVSubscribeEvent
{
    ZWEAKSELF
    [self.tvSubscribe setOnBackgroundClick:^(ZBackgroundState state) {
        switch (state) {
            case ZBackgroundStateLoginNull: [weakSelf showLoginVC]; break;
            default:
                [weakSelf.tvSubscribe setBackgroundViewWithState:(ZBackgroundStateLoading)];
                [weakSelf setRefreshHeaderSubscribe];
                break;
        }
    }];
    [self.tvSubscribe setOnSubscribeClick:^(ModelSubscribe *model) {
        
        [StatisticsManager event:kPurchase_Training_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
        
        weakSelf.unReadTotalCountSubscribe -= model.increasedCourseCount;
        [weakSelf.viewNavigation setSubscriptionPoint:weakSelf.unReadTotalCountSubscribe];
        [weakSelf showSubscribeDetailVC:model];
    }];
    [self.tvSubscribe setOnRefreshHeader:^{
        if ([AppSetting getAutoLogin]) {
            [weakSelf setRefreshHeaderSubscribe];
        } else {
            [weakSelf.tvSubscribe endRefreshHeader];
            [weakSelf.tvSubscribe setViewDataWithNoLogin];
        }
    }];
    [self.tvSubscribe setOnRefreshFooter:^{
        [weakSelf setRefreshFooterSubscribe];
    }];
}
-(void)setTvCurriculumEvent
{
    ZWEAKSELF
    [self.tvCurriculum setOnBackgroundClick:^(ZBackgroundState state) {
        switch (state) {
            case ZBackgroundStateLoginNull: [weakSelf showLoginVC]; break;
            default:
                [weakSelf.tvCurriculum setBackgroundViewWithState:(ZBackgroundStateLoading)];
                [weakSelf setRefreshHeaderCurriculum];
                break;
        }
    }];
    [self.tvCurriculum setOnSubscribeClick:^(ModelSubscribe *model) {
        
        [StatisticsManager event:kPurchase_EriesCourse_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
        
        weakSelf.unReadTotalCountCurriculum -= model.increasedCourseCount;
        [weakSelf.viewNavigation setCurriculumPoint:weakSelf.unReadTotalCountCurriculum];
        [weakSelf showSubscribeDetailVC:model];
    }];
    [self.tvCurriculum setOnRefreshHeader:^{
        if ([AppSetting getAutoLogin]) {
            [weakSelf setRefreshHeaderCurriculum];
        } else {
            [weakSelf.tvCurriculum endRefreshHeader];
            [weakSelf.tvCurriculum setViewDataWithNoLogin];
        }
    }];
    [self.tvCurriculum setOnRefreshFooter:^{
        [weakSelf setRefreshFooterCurriculum];
    }];
}
-(void)setLoginChange
{
    if ([AppSetting getAutoLogin]) {
        [self setAllBindShow];
        [self.tvAll setViewDataWithNoData];
        [self.tvPractice setViewDataWithNoData];
        [self.tvSubscribe setViewDataWithNoData:ZBackgroundStateSubscribeNoData];
        [self.tvCurriculum setViewDataWithNoData:ZBackgroundStateCurriculumNoData];
        
        [self setRefreshHeaderAll];
        [self setRefreshHeaderSubscribe];
        [self setRefreshHeaderPractice];
        [self setRefreshHeaderCurriculum];
    } else {
        [self.tvAll setViewDataWithNoLogin];
        [self.tvPractice setViewDataWithNoLogin];
        [self.tvSubscribe setViewDataWithNoLogin];
        [self.tvCurriculum setViewDataWithNoLogin];
    }
}
/// TODO: ZWW - 统计每个页面的时长
-(void)setStatisticsWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
            [StatisticsManager eventIOBeginPageWithName:kZhugeIOPagePurchasedSeriesKey];
            [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePurchasedPracticeKey dictionary:nil];
            [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePurchasedTrainingKey dictionary:nil];
            break;
        case 2:
            [StatisticsManager eventIOBeginPageWithName:kZhugeIOPagePurchasedTrainingKey];
            [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePurchasedPracticeKey dictionary:nil];
            [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePurchasedSeriesKey dictionary:nil];
            break;
        default:
            [StatisticsManager eventIOBeginPageWithName:kZhugeIOPagePurchasedPracticeKey];
            [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePurchasedTrainingKey dictionary:nil];
            [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePurchasedSeriesKey dictionary:nil];
            break;
    }
}
-(void)setSubscribeSuccess
{
    [self setRefreshHeaderAll];
    [self setRefreshHeaderSubscribe];
    [self setRefreshHeaderCurriculum];
}
-(void)setCartPaySuccess
{
    [self setRefreshHeaderAll];
    [self setRefreshHeaderPractice];
}
-(void)setPracticePaySuccess
{
    [self setRefreshHeaderAll];
    [self setRefreshHeaderPractice];
}
///设置默认选中第几个索引
-(void)setDefaultItemIndex:(NSInteger)index
{
    [self setTabIndex:index];
}
#define kBeenPurchasedAllDataKey @"kBeenPurchasedAllData"
-(void)innerDataAll
{
    if ([AppSetting getAutoLogin]) {
        NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kBeenPurchasedAllDataKey];
        if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
            NSArray *array = [[dicLocal objectForKey:kResultKey] objectForKey:@"purchaseList"];
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
                NSMutableArray *arrResult = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    int courseType = [Utils getSNSInt: [dic objectForKey:@"courseType"]];
                    if (courseType == 0) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    } else {
                        [arrResult addObject:[[ModelSubscribe alloc] initWithCustom:dic]];
                    }
                }
                [self.tvAll setViewDataWithArray:arrResult isHeader:YES];
            } else {
                [self.tvAll setBackgroundViewWithState:(ZBackgroundStateLoading)];
            }
        }
        [self setRefreshHeaderAll];
    } else {
        [self.tvAll setViewDataWithNoLogin];
    }
}
-(void)innerDataPractice
{
    if ([AppSetting getAutoLogin]) {
        NSArray *array = [sqlite getLocalPurchasePracticeArrayWithUserId:kLoginUserId];
        if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
            [self.tvPractice setViewDataWithArray:array isHeader:YES];
        } else {
            [self.tvPractice setBackgroundViewWithState:(ZBackgroundStateLoading)];
        }
        [self setRefreshHeaderPractice];
    } else {
        [self.tvPractice setViewDataWithNoLogin];
    }
}
-(void)innerDataSubscribe
{
    if ([AppSetting getAutoLogin]) {
        NSArray *array = [sqlite getLocalPurchaseSubscribeArrayWithUserId:kLoginUserId];
        if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
            [self.tvSubscribe setViewDataWithArray:array isHeader:YES];
        } else {
            [self.tvSubscribe setBackgroundViewWithState:(ZBackgroundStateLoading)];
        }
        [self setRefreshHeaderSubscribe];
    } else {
        [self.tvSubscribe setViewDataWithNoLogin];
    }
}
-(void)innerDataCurriculum
{
    if ([AppSetting getAutoLogin]) {
        NSArray *array = [sqlite getLocalPurchaseCurriculumArrayWithUserId:kLoginUserId];
        if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
            [self.tvCurriculum setViewDataWithCurriculumArray:array isHeader:YES];
        } else {
            [self.tvCurriculum setBackgroundViewWithState:(ZBackgroundStateLoading)];
        }
        [self setRefreshHeaderCurriculum];
    } else {
        [self.tvCurriculum setViewDataWithNoLogin];
    }
}
///更新用户数据
-(void)loadUserInfo
{
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        [snsV1 postGetUserInfoWithUserId:kLoginUserId resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                if (resultModel) {
                    [AppSetting setUserLogin:resultModel];
                    [AppSetting save];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
                }
            });
        } errorBlock:nil];
    }
}
-(void)setRefreshHeaderAll
{
    ZWEAKSELF
    [snsV2 getV6PurchaseAllArrayWithPageNum:1 resultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf setPageNumberAll:1];
        [weakSelf.tvAll endRefreshHeader];
        [weakSelf.tvAll setViewDataWithArray:array isHeader:YES];
        [sqlite setLocalCacheDataWithDictionary:result pathKay:kBeenPurchasedAllDataKey];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvAll endRefreshHeader];
        [weakSelf.tvAll setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooterAll
{
    ZWEAKSELF
    [snsV2 getV6PurchaseAllArrayWithPageNum:self.pageNumberAll+1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumberAll += 1;
        [weakSelf.tvAll endRefreshFooter];
        [weakSelf.tvAll setViewDataWithArray:array isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvAll endRefreshFooter];
    }];
}
-(void)setRefreshHeaderPractice
{
    ZWEAKSELF
    [snsV2 getPurchasePracticeArrayWithPageNum:1 resultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf setPageNumberPractice:1];
        [weakSelf.tvPractice endRefreshHeader];
        
        [weakSelf.tvPractice setViewDataWithArray:array isHeader:YES];
        
        [sqlite setLocalPurchasePracticeWithArray:array userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvPractice endRefreshHeader];
        
        [weakSelf.tvPractice setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshHeaderSubscribe
{
    ZWEAKSELF
    [snsV2 getPurchaseSubscribeArrayWithPageNum:1 resultBlock:^(NSArray *array, int unReadTotalCount, NSDictionary *result) {
        [weakSelf setPageNumberSubscribe:1];
        [weakSelf.tvSubscribe endRefreshHeader];
        [weakSelf setUnReadTotalCountSubscribe:unReadTotalCount];
        [weakSelf.tvSubscribe setViewDataWithArray:array isHeader:YES];
        [weakSelf.viewNavigation setSubscriptionPoint:unReadTotalCount];
        [sqlite setLocalPurchaseSubscribeWithArray:array userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvSubscribe endRefreshHeader];
        
        [weakSelf.tvSubscribe setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshHeaderCurriculum
{
    ZWEAKSELF
    [snsV2 getPurchaseCurriculumArrayWithPageNum:1 resultBlock:^(NSArray *array, int unReadTotalCount, NSDictionary *result) {
        [weakSelf setPageNumberCurriculum:1];
        [weakSelf.tvCurriculum endRefreshHeader];
        [weakSelf setUnReadTotalCountCurriculum:unReadTotalCount];
        [weakSelf.tvCurriculum setViewDataWithCurriculumArray:array isHeader:YES];
        [weakSelf.viewNavigation setCurriculumPoint:unReadTotalCount];
        [sqlite setLocalPurchaseCurriculumWithArray:array userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvCurriculum endRefreshHeader];
        
        [weakSelf.tvCurriculum setViewDataWithCurriculumArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooterPractice
{
    ZWEAKSELF
    [snsV2 getPurchasePracticeArrayWithPageNum:self.pageNumberPractice+1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumberPractice += 1;
        [weakSelf.tvPractice endRefreshFooter];
        [weakSelf.tvPractice setViewDataWithArray:array isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvPractice endRefreshFooter];
    }];
}
-(void)setRefreshFooterSubscribe
{
    ZWEAKSELF
    [snsV2 getPurchaseSubscribeArrayWithPageNum:self.pageNumberSubscribe+1 resultBlock:^(NSArray *array, int unReadTotalCount, NSDictionary *result) {
        weakSelf.pageNumberSubscribe += 1;

        [weakSelf.tvSubscribe endRefreshFooter];
        [weakSelf setUnReadTotalCountSubscribe:unReadTotalCount];
        [weakSelf.viewNavigation setSubscriptionPoint:unReadTotalCount];
        [weakSelf.tvSubscribe setViewDataWithArray:array isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvSubscribe endRefreshFooter];
    }];
}
-(void)setRefreshFooterCurriculum
{
    ZWEAKSELF
    [snsV2 getPurchaseCurriculumArrayWithPageNum:self.pageNumberCurriculum+1 resultBlock:^(NSArray *array, int unReadTotalCount, NSDictionary *result) {
        weakSelf.pageNumberCurriculum += 1;
        
        [weakSelf.tvCurriculum endRefreshFooter];
        [weakSelf setUnReadTotalCountCurriculum:unReadTotalCount];
        [weakSelf.viewNavigation setCurriculumPoint:unReadTotalCount];
        [weakSelf.tvCurriculum setViewDataWithCurriculumArray:array isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvCurriculum endRefreshFooter];
    }];
}
-(void)showSubscribeDetailVC:(ModelSubscribe *)model
{
    ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
    [itemVC setViewDataWithSubscribeModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///顶部切换菜单的事件
-(void)setViewContentOffsetWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self.tvAll setScrollsToTop:false];
            [self.tvPractice setScrollsToTop:true];
            [self.tvSubscribe setScrollsToTop:false];
            [self.tvCurriculum setScrollsToTop:false];
            break;
        }
        case 2:
        {
            [self.tvAll setScrollsToTop:false];
            [self.tvPractice setScrollsToTop:false];
            [self.tvSubscribe setScrollsToTop:true];
            [self.tvCurriculum setScrollsToTop:false];
            break;
        }
        case 3:
        {
            [self.tvAll setScrollsToTop:false];
            [self.tvPractice setScrollsToTop:false];
            [self.tvSubscribe setScrollsToTop:false];
            [self.tvCurriculum setScrollsToTop:true];
            break;
        }
        default:
        {
            [self.tvAll setScrollsToTop:true];
            [self.tvPractice setScrollsToTop:false];
            [self.tvSubscribe setScrollsToTop:false];
            [self.tvCurriculum setScrollsToTop:false];
            break;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*index, 0) animated:YES];
}

#pragma - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewNavigation setChangeItemIndex:(offsetIndex)];
    self.tabIndex = offsetIndex;
    [self setStatisticsWithIndex:offsetIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewNavigation setOffsetChange:scrollView.contentOffset.x];
}

@end
