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

@interface ZBeenPurchasedViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZPurchasedNavigationView *viewNavigation;

@property (strong, nonatomic) ZPurchasePracticeTableView *tvPractice;

@property (strong, nonatomic) ZPurchaseSubscribeTableView *tvSubscribe;

@property (strong, nonatomic) ZPurchaseSubscribeTableView *tvCurriculum;

@property (strong, nonatomic) NSMutableArray *arrPractice;

@property (strong, nonatomic) NSMutableArray *arrSubscribe;

@property (strong, nonatomic) NSMutableArray *arrCurriculum;

@property (assign, nonatomic) int pageNumberPractice;

@property (assign, nonatomic) int pageNumberSubscribe;

@property (assign, nonatomic) int pageNumberCurriculum;

@end

@implementation ZBeenPurchasedViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kBeenPurchased];
    
    [self registerLoginChangeNotification];
    
    [self innerInit];
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
    [self setNavBarAlpha:0];
    
    self.viewNavigation = [[ZPurchasedNavigationView alloc] initWithFrame:CGRectMake(65, 20, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.viewNavigation setOnItemClick:^(NSInteger index) {
        [weakSelf setViewContentOffsetWithIndex:index];
    }];
    [self.navigationItem setTitleView:self.viewNavigation];
    
    CGRect scViewFrame = VIEW_TABB_FRAME;
    self.scrollView = [[UIScrollView alloc] initWithFrame:scViewFrame];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*3, 0)];
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0)];
    
    self.tvPractice = [[ZPurchasePracticeTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvPractice setScrollsToTop:NO];
    [self.scrollView addSubview:self.tvPractice];
    
    self.tvCurriculum = [[ZPurchaseSubscribeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvCurriculum setScrollsToTop:NO];
    [self.scrollView addSubview:self.tvCurriculum];
    
    self.tvSubscribe = [[ZPurchaseSubscribeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvSubscribe setScrollsToTop:YES];
    [self.scrollView addSubview:self.tvSubscribe];
    
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.tvPractice setOnRefreshHeader:^{
        [weakSelf setRefreshHeaderPractice];
    }];
    [self.tvPractice setOnRefreshFooter:^{
        [weakSelf setRefreshFooterPractice];
    }];
    [self.tvPractice setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvPractice setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeaderPractice];
    }];
    
    [self.tvSubscribe setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvSubscribe setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeaderSubscribe];
    }];
    [self.tvSubscribe setOnSubscribeClick:^(ModelSubscribe *model) {
        [weakSelf showSubscribeDetailVC:model];
    }];
    [self.tvSubscribe setOnRefreshHeader:^{
        [weakSelf setRefreshHeaderSubscribe];
    }];
    [self.tvSubscribe setOnRefreshFooter:^{
        [weakSelf setRefreshFooterSubscribe];
    }];
    
    [self.tvCurriculum setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvCurriculum setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeaderCurriculum];
    }];
    [self.tvCurriculum setOnSubscribeClick:^(ModelSubscribe *model) {
        [weakSelf showSubscribeDetailVC:model];
    }];
    [self.tvCurriculum setOnRefreshHeader:^{
        [weakSelf setRefreshHeaderCurriculum];
    }];
    [self.tvCurriculum setOnRefreshFooter:^{
        [weakSelf setRefreshFooterCurriculum];
    }];
    
    [super innerInit];
    
    [self innerDataPractice];
    
    [self innerDataSubscribe];
    
    [self innerDataCurriculum];
}
-(void)setLoginChange
{
    [self setRefreshHeaderSubscribe];
    [self setRefreshHeaderPractice];
    [self setRefreshHeaderCurriculum];
}
-(void)innerDataPractice
{
    NSArray *array = [sqlite getLocalPurchasePracticeArrayWithUserId:[AppSetting getUserDetauleId]];
    if (array && array.count > 0) {
        [self.tvPractice setViewDataWithArray:array isHeader:YES];
    } else {
        [self.tvPractice setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeaderPractice];
}
-(void)innerDataSubscribe
{
    NSArray *array = [sqlite getLocalPurchaseSubscribeArrayWithUserId:[AppSetting getUserDetauleId]];
    if (array && array.count > 0) {
        [self.tvSubscribe setViewDataWithArray:array isHeader:YES];
    } else {
        [self.tvSubscribe setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeaderSubscribe];
}
-(void)innerDataCurriculum
{
    NSArray *array = [sqlite getLocalPurchaseCurriculumArrayWithUserId:[AppSetting getUserDetauleId]];
    if (array && array.count > 0) {
        [self.tvCurriculum setViewDataWithCurriculumArray:array isHeader:YES];
    } else {
        [self.tvCurriculum setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeaderCurriculum];
}
-(void)setRefreshHeaderPractice
{
    ZWEAKSELF
    [self setPageNumberPractice:1];
    [snsV2 getPurchasePracticeArrayWithPageNum:self.pageNumberPractice resultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf.tvPractice endRefreshHeader];
        
        [weakSelf.tvPractice setViewDataWithArray:array isHeader:YES];
        
        [sqlite setLocalPurchasePracticeWithArray:array userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvPractice endRefreshHeader];
        
        [weakSelf.tvPractice setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshHeaderSubscribe
{
    ZWEAKSELF
    [self setPageNumberSubscribe:1];
    [snsV2 getPurchaseSubscribeArrayWithPageNum:self.pageNumberSubscribe resultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf.tvSubscribe endRefreshHeader];
        
        [weakSelf.tvSubscribe setViewDataWithArray:array isHeader:YES];
        
        [sqlite setLocalPurchaseSubscribeWithArray:array userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvSubscribe endRefreshHeader];
        
        [weakSelf.tvSubscribe setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshHeaderCurriculum
{
    ZWEAKSELF
    [self setPageNumberCurriculum:1];
    [snsV2 getPurchaseCurriculumArrayWithPageNum:self.pageNumberCurriculum resultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf.tvCurriculum endRefreshHeader];
        
        [weakSelf.tvCurriculum setViewDataWithCurriculumArray:array isHeader:YES];
        
        [sqlite setLocalPurchaseCurriculumWithArray:array userId:[AppSetting getUserDetauleId]];
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
    [snsV2 getPurchaseSubscribeArrayWithPageNum:self.pageNumberSubscribe+1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumberSubscribe += 1;
        
        [weakSelf.tvSubscribe endRefreshFooter];
        
        [weakSelf.tvSubscribe setViewDataWithArray:array isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvSubscribe endRefreshFooter];
    }];
}
-(void)setRefreshFooterCurriculum
{
    ZWEAKSELF
    [snsV2 getPurchaseCurriculumArrayWithPageNum:self.pageNumberCurriculum+1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumberCurriculum += 1;
        
        [weakSelf.tvCurriculum endRefreshFooter];
        
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
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:YES];
            [self.tvCurriculum setScrollsToTop:NO];
            break;
        }
        case 2:
        {
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:NO];
            [self.tvCurriculum setScrollsToTop:YES];
            break;
        }
        default:
        {
            [self.tvPractice setScrollsToTop:YES];
            [self.tvSubscribe setScrollsToTop:NO];
            [self.tvCurriculum setScrollsToTop:NO];
            break;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*index, 0) animated:YES];
}

@end
