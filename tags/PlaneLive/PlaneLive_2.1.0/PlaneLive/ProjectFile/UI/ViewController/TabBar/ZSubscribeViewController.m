//
//  ZSubscribeViewController.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeViewController.h"
#import "ZSubscribeNavigationView.h"
#import "ZSubscribeItemTableView.h"
#import "ZSubscribeAlreadyTableView.h"

#import "ZSubscribeDetailViewController.h"
#import "ZCurriculumDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"

@interface ZSubscribeViewController ()<UIScrollViewDelegate>

///导航栏
@property (strong, nonatomic) ZSubscribeNavigationView *viewNavigation;
///切换面板
@property (strong, nonatomic) UIScrollView *scrollView;
///已定
@property (strong, nonatomic) ZSubscribeAlreadyTableView *tvItem1;
///推荐
@property (strong, nonatomic) ZSubscribeItemTableView *tvItem2;

///推荐分页
@property (assign, nonatomic) int pageNumRecommend;
///已定分页
@property (assign, nonatomic) int pageNumAlready;

@end

@implementation ZSubscribeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSubscribeSuccess:) name:ZSubscribeSuccessNotification object:nil];
    
    [self registerLoginChangeNotification];
}

-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZSubscribeSuccessNotification object:nil];
    OBJC_RELEASE(_tvItem1);
    OBJC_RELEASE(_tvItem2);
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_viewNavigation);
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT)];
    [self.scrollView setOpaque:NO];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*2, self.scrollView.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
    [self.view addSubview:self.scrollView];
    
    ZWEAKSELF
    self.tvItem1 = [[ZSubscribeAlreadyTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvItem1 setScrollsToTop:NO];
    [self.tvItem1 setOnBackgroundClick:^(ZBackgroundState state) {
        switch (state) {
            case ZBackgroundStateLoginNull:
                [weakSelf showLoginVC];
                break;
            default:
                [weakSelf setRefreshAlreadyHeader];
                break;
        }
    }];
    [self.tvItem1 setOnRefreshHeader:^{
        [weakSelf setRefreshAlreadyHeader];
    }];
    [self.tvItem1 setOnRefreshFooter:^{
        [weakSelf setRefreshAlreadyFooter];
    }];
    [self.tvItem1 setOnSubscribeClick:^(ModelCurriculum *model, int unReadCount) {
        [weakSelf setChangeUserWithUnReadCount:unReadCount];
        
        ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.tvItem1 setOnCurriculumClick:^(ModelCurriculum *model, int unReadCount) {
        [weakSelf setChangeUserWithUnReadCount:unReadCount];
        
        ZCurriculumDetailViewController *itemVC = [[ZCurriculumDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.scrollView addSubview:self.tvItem1];
    
    self.tvItem2 = [[ZSubscribeItemTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvItem2 setScrollsToTop:YES];
    [self.tvItem2 setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshRecommendHeader];
    }];
    [self.tvItem2 setOnRefreshHeader:^{
        [weakSelf setRefreshRecommendHeader];
    }];
    [self.tvItem2 setOnRefreshFooter:^{
        [weakSelf setRefreshRecommendFooter];
    }];
    [self.tvItem2 setOnSubscribeClick:^(ModelSubscribe *model) {
        ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.scrollView addSubview:self.tvItem2];
    
    [super innerInit];
    
    [self setNavBarAlpha:0];
    
    self.viewNavigation = [[ZSubscribeNavigationView alloc] initWithFrame:CGRectMake(65, 20, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.viewNavigation setOnItemClick:^(NSInteger index) {
        [weakSelf setViewContentOffsetWithIndex:index];
    }];
    [self.navigationItem setTitleView:self.viewNavigation];
    
    [self innerData];
}
///改变统计数量
-(void)setChangeUserWithUnReadCount:(int)unReadCount
{
    ModelUser *modelU = [AppSetting getUserLogin];
    [modelU setUnReadTotalCount:modelU.unReadTotalCount-unReadCount];
    if (modelU.unReadTotalCount <= 0) {
        [modelU setUnReadTotalCount:0];
    }
    [AppSetting setUserLogin:modelU];
    [AppSetting save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
}
-(void)innerData
{
    NSArray *arrayAlready = [sqlite getLocalSubscribeAlreadyArrayWithUserId:[AppSetting getUserDetauleId]];
    if (arrayAlready && arrayAlready.count > 0) {
        [self.tvItem1 setViewDataWithArray:arrayAlready isHeader:YES];
    } else {
        [self.tvItem1 setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    NSArray *arrayRecommend = [sqlite getLocalSubscribeRecommendArrayWithUserId:[AppSetting getUserDetauleId]];
    if (arrayRecommend && arrayRecommend.count > 0) {
        [self.tvItem2 setViewDataWithArray:arrayRecommend isHeader:YES];
    } else {
        [self.tvItem2 setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshRecommendHeader];
    
    [self setRefreshAlreadyHeader];
}
///订阅成功通知
-(void)setSubscribeSuccess:(NSNotificationCenter *)sender
{
    GCDMainBlock(^{
        [self setRefreshRecommendHeader];
        
        [self setRefreshAlreadyHeader];
        
        [self.viewNavigation setItemDefaultSelect:0];
    });
}
///用户改变通知
-(void)setLoginChange
{
    GCDMainBlock(^{
        [self setRefreshRecommendHeader];
        
        [self setRefreshAlreadyHeader];
    });
}
///顶部切换菜单的事件
-(void)setViewContentOffsetWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self.tvItem1 setScrollsToTop:NO];
            [self.tvItem2 setScrollsToTop:YES];
            break;
        }
        default:
        {
            [self.tvItem1 setScrollsToTop:YES];
            [self.tvItem2 setScrollsToTop:NO];
            break;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*index, 0) animated:YES];
}
///刷新推荐顶部数据
-(void)setRefreshRecommendHeader
{
    ZWEAKSELF
    self.pageNumRecommend = 1;
    [snsV2 getSubscribeRecommendArrayWithPageNum:self.pageNumRecommend resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvItem2 endRefreshHeader];
        [weakSelf.tvItem2 setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalSubscribeRecommendWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvItem2 endRefreshHeader];
        [weakSelf.tvItem2 setViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新推荐底部数据
-(void)setRefreshRecommendFooter
{
    ZWEAKSELF
    [snsV2 getSubscribeRecommendArrayWithPageNum:self.pageNumRecommend+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumRecommend += 1;
        [weakSelf.tvItem2 endRefreshFooter];
        [weakSelf.tvItem2 setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvItem2 endRefreshFooter];
    }];
}
///刷新已定顶部数据
-(void)setRefreshAlreadyHeader
{
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        self.pageNumAlready = 1;
        [snsV2 getSubscribeAlreadyWithPageNum:self.pageNumAlready resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            
            [weakSelf.tvItem1 endRefreshHeader];
            [weakSelf.tvItem1 setViewDataWithArray:arrResult isHeader:YES];
            
            [sqlite setLocalSubscribeAlreadyWithArray:arrResult userId:[AppSetting getUserDetauleId]];
        } errorBlock:^(NSString *msg) {
            [weakSelf.tvItem1 endRefreshHeader];
            [weakSelf.tvItem1 setViewDataWithArray:nil isHeader:YES];
        }];
    } else {
        [self.tvItem1 endRefreshHeader];
        [self.tvItem1 setViewNoLoginState];
    }
}
///刷新已定底部数据
-(void)setRefreshAlreadyFooter
{
    ZWEAKSELF
    [snsV2 getSubscribeAlreadyWithPageNum:self.pageNumAlready+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumAlready += 1;
        [weakSelf.tvItem1 endRefreshFooter];
        [weakSelf.tvItem1 setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvItem1 endRefreshFooter];
    }];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self setViewContentOffsetWithIndex:offsetIndex];
    [self.viewNavigation setItemDefaultSelect:offsetIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewNavigation setOffsetChange:scrollView.contentOffset.x];
}

@end
