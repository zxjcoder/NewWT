//
//  ZSubscribeTypeViewController.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZSubscribeTypeViewController.h"
#import "ZHomeSubscribeItemTVC.h"
#import "ZSubscribeDetailViewController.h"

@interface ZSubscribeTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZSubscribeTypeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kSubscribe];
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageHomeTrainingKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageHomeTrainingKey dictionary:nil];
    
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
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setRowHeight:[ZHomeSubscribeItemTVC getH]];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerLocalData];
    [self setRefreshHeader];
    
    ZWEAKSELF
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
}
-(void)innerLocalData
{
    NSArray *arrayRecommend = [sqlite getLocalSubscribeRecommendArrayWithUserId:kLoginUserId];
    if (arrayRecommend && arrayRecommend.count > 0) {
        [self.arrMain addObjectsFromArray:arrayRecommend];
        [self.tvMain reloadData];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getSubscribeArrayWithPageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf.tvMain endRefreshHeader];
        if (weakSelf.arrMain.count == 0 && arrResult.count == 0) {
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
        } else {
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
        }
        [weakSelf.arrMain removeAllObjects];
        [weakSelf.arrMain addObjectsFromArray:arrResult];
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [weakSelf.tvMain removeRefreshFooter];
        }
        [weakSelf.tvMain reloadData];
        
        [sqlite setLocalSubscribeRecommendWithArray:arrResult userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        if (weakSelf.arrMain.count == 0) {
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getSubscribeArrayWithPageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.arrMain addObjectsFromArray:arrResult];
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [weakSelf.tvMain removeRefreshFooter];
        }
        [weakSelf.tvMain reloadData];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZHomeSubscribeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZHomeSubscribeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
    if (model.is_series_course == 0) {
        [StatisticsManager event:kTraining_ListItem dictionary:@{kObjectId:model.ids==nil?kEmpty:model.ids,kObjectTitle:model.title==nil?kEmpty:model.title}];
    } else {
        [StatisticsManager event:kEriesCourse_ListItem dictionary:@{kObjectId:model.ids==nil?kEmpty:model.ids,kObjectTitle:model.title==nil?kEmpty:model.title}];
    }
    ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
