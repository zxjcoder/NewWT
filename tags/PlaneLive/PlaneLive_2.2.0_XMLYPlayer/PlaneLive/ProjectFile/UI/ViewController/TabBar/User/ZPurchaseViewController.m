//
//  ZPurchaseViewController.m
//  PlaneLive
//
//  Created by Daniel on 15/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPurchaseViewController.h"
#import "ZPurchasePracticeTableView.h"
#import "ZPurchaseSubscribeTableView.h"
#import "ZSwitchToolView.h"
#import "ZSubscribeAlreadyHasViewController.h"

@interface ZPurchaseViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scrollView;
@property (strong, nonatomic) ZSwitchToolView *viewTool;
@property (strong, nonatomic) ZPurchasePracticeTableView *tvPractice;
@property (strong, nonatomic) ZPurchaseSubscribeTableView *tvSubscribe;
@property (strong, nonatomic) NSMutableArray *arrPractice;
@property (strong, nonatomic) NSMutableArray *arrSubscribe;
@property (assign, nonatomic) int pageNumberPractice;
@property (assign, nonatomic) int pageNumberSubscribe;

@end

@implementation ZPurchaseViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kBeenPurchased];
    
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
    OBJC_RELEASE(_arrSubscribe);
    OBJC_RELEASE(_arrPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_viewTool);
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
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
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemPurchase)];
    [self.viewTool setFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, [ZSwitchToolView getViewH])];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [weakSelf.tvPractice setScrollsToTop:NO];
                [weakSelf.tvSubscribe setScrollsToTop:YES];
                break;
            default:
                [weakSelf.tvPractice setScrollsToTop:YES];
                [weakSelf.tvSubscribe setScrollsToTop:NO];
                break;
        }
        [weakSelf.scrollView setContentOffset:CGPointMake((index-1)*weakSelf.scrollView.width, 0) animated:YES];
    }];
    [self.view addSubview:self.viewTool];
    
    CGFloat scViewY = self.viewTool.y+self.viewTool.height;
    self.scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, scViewY, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-scViewY)];
    [self.scrollView setBounces:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*2, 0)];
    [self.view addSubview:self.scrollView];
    
    self.tvPractice = [[ZPurchasePracticeTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvPractice setScrollsToTop:YES];
    [self.scrollView addSubview:self.tvPractice];
    
    self.tvSubscribe = [[ZPurchaseSubscribeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvSubscribe setScrollsToTop:NO];
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
    
    [super innerInit];
    
    [self innerDataPractice];
    
    [self innerDataSubscribe];
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
-(void)showSubscribeDetailVC:(ModelSubscribe *)model
{
    ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
    [itemVC setViewDataWithSubscribeModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewTool setViewSelectItemWithType:(offsetIndex+1)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

@end
