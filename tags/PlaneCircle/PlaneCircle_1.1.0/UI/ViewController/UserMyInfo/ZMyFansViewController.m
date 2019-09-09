//
//  ZMyFansViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyFansViewController.h"
#import "ZMyUserInfoTVC.h"

@interface ZMyFansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ModelUserBase *modelUB;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZMyFansViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
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
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_modelUB);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZMyUserInfoTVC getH]];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshData:YES];
    }];
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
}

-(void)innerData
{
    NSString *localKey = [NSString stringWithFormat:@"MyFansKey%@",self.modelUB.userId];
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:localKey];
    BOOL isRefresh = YES;
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        isRefresh = NO;
        [self setViewDataWithDictionary:dicLocal isHeader:YES isRefresh:isRefresh];
    }
    [self setRefreshData:isRefresh];
}
///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    ZWEAKSELF
    NSString *localKey = [NSString stringWithFormat:@"MyFansKey%@",self.modelUB.userId];
    NSDictionary *dicMyFuns = [dicResult objectForKey:@"myFuns"];
    if (dicMyFuns && [dicMyFuns isKindOfClass:[NSDictionary class]]) {
        NSArray *arrMyFans = [dicMyFuns objectForKey:@"list"];
        if (arrMyFans && [arrMyFans isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrUserB = [NSMutableArray array];
            for (NSDictionary *dicUser in arrMyFans) {
                ModelUserBase *model = [[ModelUserBase alloc] initWithCustom:dicUser];
                [arrUserB addObject:model];
            }
            if (isHeader) {
                [self.arrMain removeAllObjects];
                if (arrUserB.count == 0) {
                    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                } else {
                    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                    [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
                }
            }
            if (arrUserB.count > kPAGE_MAXCOUNT) {
                [self.tvMain addRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [self.tvMain removeRefreshFooter];
            }
            [self.arrMain addObjectsFromArray:arrUserB];
            [self.tvMain reloadData];
        } else {
            if (isHeader) {
                [self.arrMain removeAllObjects];
                [self.tvMain reloadData];
                [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
        }
    } else {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            [self.tvMain reloadData];
            [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
        }
    }
}

-(void)setRefreshData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNum = 1;
    if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetFunsWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            [weakSelf setViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];}
        });
    }];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [sns postMyGetFunsWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            [weakSelf setViewDataWithDictionary:result isHeader:YES isRefresh:NO];
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
    self.pageNum += 1;
    [sns postMyGetFunsWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf setViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

-(void)setDeleteModelWithModel:(ModelUserBase *)model
{
    [sns postDeleteMyFunsWithUserId:[AppSetting getUserDetauleId] hisId:model.userId resultBlock:nil errorBlock:nil];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZMyUserInfoTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyUserInfoTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelUserBase *modelUB = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelUB];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    if (![model.userId isEqualToString:[AppSetting getUserId]]) {
        [self showUserProfileVC:model];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
