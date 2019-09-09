//
//  ZNoticeListViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/28/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNoticeListViewController.h"
#import "ZUserNoticeTVC.h"
#import "ZNoticeDetailViewController.h"

@interface ZNoticeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZNoticeListViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kMessageCenter];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [_tvMain setDelegate:nil];
    [_tvMain setDataSource:nil];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZUserNoticeTVC getH]];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf refreshData:YES];
    }];
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [super innerInit];
}

-(void)innerData
{
    BOOL isRefresh = YES;
    NSArray *arrLocal = [sqlite getLocalUserNotice];
    if (arrLocal && arrLocal.count > 0) {
        isRefresh = NO;
        [self.arrMain removeAllObjects];
        [self.arrMain addObjectsFromArray:arrLocal];
        [self.tvMain reloadData];
    }
    [self refreshData:isRefresh];
}

-(void)refreshData:(BOOL)isRefresh
{
    if (isRefresh) {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    ZWEAKSELF
    self.pageNum = 1;
    [snsV1 getUserNoticeListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            if (arrResult && arrResult.count > 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
                
                [sqlite setLocalUserNoticeWithArray:arrResult];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV1 getUserNoticeListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            if (arrResult && arrResult.count > 0) {
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
                
                [sqlite setLocalUserNoticeWithArray:arrResult];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV1 getUserNoticeListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            if (arrResult && arrResult.count > 0) {
                [weakSelf.tvMain endRefreshFooter];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZUserNoticeTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZUserNoticeTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelNotice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelNotice *model = [self.arrMain objectAtIndex:indexPath.row];
    
    ZNoticeDetailViewController *itemVC = [[ZNoticeDetailViewController alloc] init];
    [itemVC setTitle:model.noticeTitle];
    [itemVC setViewDataWithModel:model];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
