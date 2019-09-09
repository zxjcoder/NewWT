//
//  ZLawFirmSeriesCourseViewController.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmSeriesCourseViewController.h"
#import "ZLawFirmSubscribeTableView.h"
#import "ZSubscribeDetailViewController.h"

@interface ZLawFirmSeriesCourseViewController ()

@property (strong, nonatomic) ZLawFirmSubscribeTableView *tvMain;
@property (strong, nonatomic) ModelLawFirm *model;
@property (assign, nonatomic) int pageNum;

@end

@implementation ZLawFirmSeriesCourseViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kLawFirmRecommendedSeriesCourse];
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
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_tvMain);
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
    self.tvMain = [[ZLawFirmSubscribeTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnSubscribeClick:^(ModelSubscribe *model) {
        ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{
    [self setRefreshHeader];
}
-(void)setViewDataWithModel:(ModelLawFirm *)model
{
    [self setModel:model];
}
///刷新顶部数据
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getLawFirmSeriesCourseListWithLawFirmId:self.model.ids pageNum:self.pageNum resultBlock:^(NSArray *result) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:YES];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新推荐底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getLawFirmSeriesCourseListWithLawFirmId:self.model.ids pageNum:self.pageNum resultBlock:^(NSArray *result) {
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
