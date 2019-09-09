//
//  ZBlackListManagerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBlackListManagerViewController.h"
#import "ZSettingBlackListTVC.h"

#define  kBlackListManagerLocalKey  @"kBlackListManagerLocalKey"

@interface ZBlackListManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) NSString *lastUserId;

@end

@implementation ZBlackListManagerViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"黑名单管理"];
    
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
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvMain = [[ZBaseTableView alloc] init];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZSettingBlackListTVC getH]];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshData:YES];
    }];
    
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf refreshHeaderData];
    }];
    
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
    
    [self innerData];
}
///初始化数据
-(void)innerData
{
    BOOL isSetState = YES;
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kBlackListManagerLocalKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicLocal];
        [dicR setObject:@"YES" forKey:kIsHeaderKey];
        [self setViewDataWithDictionary:dicR];
    }
    if (self.arrMain.count > 0) {
        isSetState = NO;
    }
    [self setRefreshData:isSetState];
}

///处理接收的数据
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    NSMutableDictionary *dicR = [dicResult objectForKey:@"blackList"];
    if (dicR && [dicR isKindOfClass:[NSDictionary class]]) {
        
        NSArray *arrR = [dicR objectForKey:@"list"];
        if (arrR && [arrR isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in arrR) {
                ModelUserBlack *modelUB = [[ModelUserBlack alloc] initWithCustom:dic];
                [arr addObject:modelUB];
            }
            ZWEAKSELF
            BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
            if (isHeader) {
                [self.arrMain removeAllObjects];
                if (arr.count == 0) {
                    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                } else {
                    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                }
            } else {
                if (arr.count < kPAGE_MAXCOUNT) {
                    [self.tvMain addRefreshFooterWithEndBlock:^{
                        [weakSelf refreshFooterData];
                    }];
                } else {
                    [self.tvMain removeRefreshFooter];
                }
            }
            [self.arrMain addObjectsFromArray:arr];
        } else {
            [self.arrMain removeAllObjects];
            [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
        }
    } else {
        [self.arrMain removeAllObjects];
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
    }
    [self.tvMain reloadData];
}
///加载数据
-(void)setRefreshData:(BOOL)isSetState
{
    ZWEAKSELF
    [self setPageNum:1];
    if (isSetState) {
        [self.tvMain setBackgroundViewWithState:ZBackgroundStateLoading];
    }
    [sns postGetBlackListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain setBackgroundViewWithState:ZBackgroundStateNone];
            
            NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicR setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf setViewDataWithDictionary:dicR];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kBlackListManagerLocalKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isSetState) {
                [weakSelf.tvMain setBackgroundViewWithState:ZBackgroundStateFail];
            }
        });
    }];
}
///刷新顶部数据
-(void)refreshHeaderData
{
    ZWEAKSELF
    [self setPageNum:1];
    [sns postGetBlackListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicR setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf setViewDataWithDictionary:dicR];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kBlackListManagerLocalKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}
///刷新底部数据
-(void)refreshFooterData
{
    ZWEAKSELF
    self.pageNum += 1;
    [sns postGetBlackListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain onRefreshFooter];
            
            [weakSelf setViewDataWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNum -= 1;
            [weakSelf.tvMain onRefreshFooter];
        });
    }];
}
///删除黑名单
-(void)btnDeleteUserClick:(ModelUserBase *)model rowIndex:(NSInteger)rowIndex
{
    [self setLastUserId:model.userId];
    [self.arrMain removeObjectAtIndex:rowIndex];
    [self.tvMain deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowIndex inSection:0]] withRowAnimation:(UITableViewRowAnimationTop)];
    [sns postRemoveBlackListWithUserId:[AppSetting getUserDetauleId] removeUserId:model.userId resultBlock:nil errorBlock:nil];
    
    if (self.arrMain.count == 0) {
        [self setRefreshData:YES];
    }
}

#pragma  mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"blacklistcellid";
    ZSettingBlackListTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ZSettingBlackListTVC alloc] initWithReuseIdentifier:cellId];
    }
    
    ZWEAKSELF
    ModelUserBlack *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    [cell setTag:indexPath.row];
    [cell setOnRemoveClick:^(ModelUserBase *model ,NSInteger rowIndex) {
        [weakSelf btnDeleteUserClick:model rowIndex:rowIndex];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelUserBlack *model = [self.arrMain objectAtIndex:indexPath.row];
    if (![model.userId isEqualToString:[AppSetting getUserId]]) {
        [self showUserProfileVC:model];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
