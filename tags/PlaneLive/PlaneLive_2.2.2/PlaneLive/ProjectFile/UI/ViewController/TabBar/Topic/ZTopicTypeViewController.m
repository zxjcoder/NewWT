//
//  ZTopicTypeViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicTypeViewController.h"
#import "ZTopicListTVC.h"

#import "ZTopicListViewController.h"

@interface ZTopicTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ModelTagType *modelTT;

@end

@implementation ZTopicTypeViewController

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
    
    self.userId = kLoginUserId;
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZTopicListTVC getH]];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf refreshData:YES];
    }];
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
    
    [super innerInit];
}

-(void)innerData
{
    BOOL isRefresh = YES;
    NSArray *arrLocal = [sqlite getLocalTopicDetailWithTypeId:self.modelTT.typeId userId:self.userId];
    if (arrLocal && arrLocal.count > 0) {
        isRefresh = NO;
        [self.arrMain removeAllObjects];
        [self.arrMain addObjectsFromArray:arrLocal];
        [self.tvMain reloadData];
        ZWEAKSELF
        if (arrLocal.count >= kPAGE_MAXCOUNT) {
            [self.tvMain addRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        }
    }
    [self refreshData:isRefresh];
}
-(void)refreshData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNum = 1;
    if (isRefresh) {[weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV1 getTopicListWithUserId:kLoginUserId typeId:self.modelTT.typeId pageNum:self.pageNum resultBlock:^(NSArray *arrReulst, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            [weakSelf.arrMain removeAllObjects];
            if (arrReulst.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrReulst];
                
                [sqlite setLocalTopicWithArray:arrReulst typeId:weakSelf.modelTT.typeId userId:weakSelf.userId];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
            if (arrReulst.count == kPAGE_MAXCOUNT) {
                [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
            [weakSelf.tvMain reloadData];
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
    [snsV1 getTopicListWithUserId:kLoginUserId typeId:self.modelTT.typeId pageNum:self.pageNum resultBlock:^(NSArray *arrReulst, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            [weakSelf.arrMain removeAllObjects];
            if (arrReulst.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrReulst];
                
                [sqlite setLocalTopicWithArray:arrReulst typeId:weakSelf.modelTT.typeId userId:weakSelf.userId];
            }
            if (arrReulst.count == kPAGE_MAXCOUNT) {
                [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
            [weakSelf.tvMain reloadData];
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
    [snsV1 getTopicListWithUserId:kLoginUserId typeId:self.modelTT.typeId pageNum:self.pageNum+1 resultBlock:^(NSArray *arrReulst, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            [weakSelf.tvMain endRefreshFooter];
            if (arrReulst.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrReulst];
            }
            if (arrReulst.count == kPAGE_MAXCOUNT) {
                [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
            [weakSelf.tvMain reloadData];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
-(void)setViewDataWithModel:(ModelTagType *)model
{
    [self setModelTT:model];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZTopicListTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZTopicListTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelTag *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelTag *model = [self.arrMain objectAtIndex:indexPath.row];
    ZTopicListViewController *itemVC = [[ZTopicListViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
