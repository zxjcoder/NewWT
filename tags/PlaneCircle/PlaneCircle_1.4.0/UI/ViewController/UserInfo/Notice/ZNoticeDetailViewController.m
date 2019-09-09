//
//  ZNoticeDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNoticeDetailViewController.h"
#import "ZUserNoticeDetailTVC.h"

@interface ZNoticeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) ZUserNoticeDetailTVC *tvcItem;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ModelNotice *modelN;

@end

@implementation ZNoticeDetailViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
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
    
    self.tvcItem = [[ZUserNoticeDetailTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf refreshData:YES];
    }];
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
}

-(void)innerData
{
    BOOL isRefresh = YES;
    NSArray *arrLocal = [sqlite getLocalUserNoticeDetail];
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
    [sns getUserNoticeListWithNoticeId:self.modelN.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            if (arrResult.count > 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
                
                [sqlite setLocalUserNoticeDetailWithArray:arrResult];
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
    [sns getUserNoticeListWithNoticeId:self.modelN.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            if (arrResult.count > 0) {
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
                
                [sqlite setLocalUserNoticeDetailWithArray:arrResult];
                
                if (arrResult.count >= kPAGE_MAXCOUNT) {
                    [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                        [weakSelf setRefreshFooter];
                    }];
                } else {
                    [weakSelf.tvMain removeRefreshFooter];
                }
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
    [sns getUserNoticeListWithNoticeId:self.modelN.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            [weakSelf.tvMain endRefreshFooter];
            if (arrResult.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
            }
            if (arrResult.count >= kPAGE_MAXCOUNT) {
                [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelNotice *)model
{
    [self setModelN:model];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelNoticeDetail *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZUserNoticeDetailTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZUserNoticeDetailTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelNoticeDetail *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

@end
