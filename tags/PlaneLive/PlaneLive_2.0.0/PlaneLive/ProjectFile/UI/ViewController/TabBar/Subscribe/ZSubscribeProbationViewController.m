//
//  ZSubscribeProbationViewController.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeProbationViewController.h"
#import "ZSubscribeAlreadyNoTableView.h"
#import "ZProbationDetailViewController.h"

@interface ZSubscribeProbationViewController ()

@property (strong, nonatomic) ZSubscribeAlreadyNoTableView *tvMain;

@property (strong, nonatomic) ModelSubscribe *model;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZSubscribeProbationViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kProbation];
    
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
    self.tvMain = [[ZSubscribeAlreadyNoTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnCurriculumClick:^(ModelCurriculum *model) {
        ZProbationDetailViewController *itemVC = [[ZProbationDetailViewController alloc] init];
        [model setPrice:weakSelf.model.price];
        [model setUnits:weakSelf.model.units];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{
    NSArray *arraySA = [sqlite getLocalCurriculumProbationArrayWithUserId:[AppSetting getUserDetauleId] subscribeId:self.model.ids];
    if (arraySA && arraySA.count > 0) {
        [self.tvMain setViewDataWithArray:arraySA isHeader:YES];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    [self setRefreshHeader];
}
///刷新顶部数据
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [DataOper200 getSubscribeProbationWithSubscribeId:self.model.ids pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalCurriculumProbationWithArray:arrResult subscribeId:weakSelf.model.ids userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}

///刷新底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    [DataOper200 getSubscribeProbationWithSubscribeId:self.model.ids pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

-(void)setViewDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
}

@end