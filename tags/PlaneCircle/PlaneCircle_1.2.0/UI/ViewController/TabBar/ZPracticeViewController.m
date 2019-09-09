//
//  ZPracticeViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeViewController.h"
#import "ZPracticeItemTVC.h"
#import "ZDragButton.h"
#import "AudioPlayerView.h"
#import "ZPracticeDetailViewController.h"

@interface ZPracticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZPracticeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"实务"];
    
    [self innerInit];
}

- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticeChangeNotification object:nil];
    
    [_tvMain setDelegate:nil];
    [_tvMain setDataSource:nil];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self registerLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPracticeChange:) name:ZPracticeChangeNotification object:nil];
    
    self.arrMain = [NSMutableArray array];
    
    ZNavigationBarView *barView = [[ZNavigationBarView alloc] initWithFrame:VIEW_NAVV_FRAME];
    [barView setTitle:self.title];
    [barView setHiddenBackButton:YES];
    [barView setTag:10001000];
    [self.view addSubview:barView];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_TABB_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZPracticeItemTVC getH]];
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
    NSArray *arrLocal = [sqlite getLocalPracticeOnePageWithUserId:[AppSetting getUserDetauleId]];
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
    ZWEAKSELF
    self.pageNum = 1;
    if (isRefresh) {[weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.arrMain removeAllObjects];
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            if (arrResult && arrResult.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                
                [sqlite setLocalPracticeWithArray:arrResult userId:[AppSetting getUserDetauleId]];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
            if (arrResult.count >= kPAGE_MAXCOUNT) {
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
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            [weakSelf.arrMain removeAllObjects];
            if (arrResult && arrResult.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                
                [sqlite setLocalPracticeWithArray:arrResult userId:[AppSetting getUserDetauleId]];
            }
            if (arrResult.count >= kPAGE_MAXCOUNT) {
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
    self.pageNum += 1;
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            if (arrResult && arrResult.count > 0) {
                [weakSelf.arrMain addObjectsFromArray:arrResult];
            }
            if (arrResult.count >= kPAGE_MAXCOUNT) {
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
            weakSelf.pageNum -= 1;
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///播放中的语音
-(void)btnRightClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Play];
    
    ModelPractice *modelP = [sqlite getLocalPlayPracticeModel];
    if (modelP) {
        NSInteger rowIndex = 0;
        BOOL isExistence = NO;
        for (ModelPractice *model in self.arrMain) {
            if ([model.ids isEqualToString:modelP.ids]) {
                isExistence = YES;
                break;
            }
            rowIndex++;
        }
        ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
        if (isExistence) {
            [itemVC setViewDataWithArray:self.arrMain arrDefaultRow:rowIndex];
        }
        [itemVC setViewDataWithModel:modelP];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
///登录改变
-(void)setUserInfoChange
{
    GCDMainBlock(^{
        [self refreshData:NO];
    });
}
///实务数据变化
-(void)setPracticeChange:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    
    ModelPractice *model = [dicParam objectForKey:@"model"];
    NSInteger row = [[dicParam objectForKey:@"row"] integerValue];
    if (row < self.arrMain.count) {
        ModelPractice *modelP = [self.arrMain objectAtIndex:row];
        if ([model.ids isEqualToString:modelP.ids]) {
            [modelP setIsPraise:model.isPraise];
            [modelP setIsCollection:model.isCollection];
            [modelP setCcount:model.ccount];
            [modelP setMcount:model.mcount];
            [modelP setApplauds:model.applauds];
            
            [self.tvMain reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        }
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZPracticeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
    [itemVC setPreVC:self];
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    if ([AppSetting getAutoLogin]) {
        ModelPractice *modelLocal = [sqlite getLocalPracticeDetailModelWithId:model.ids userId:[AppSetting getUserDetauleId]];
        if (modelLocal) {
            [itemVC setViewDataWithModel:modelLocal];
        } else {
            [itemVC setViewDataWithModel:model];
        }
    } else {
        [itemVC setViewDataWithModel:model];
    }
    [itemVC setViewDataWithArray:self.arrMain arrDefaultRow:indexPath.row];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
    
    //TODO:ZWW备注-添加友盟统计事件
    if (model.ids && model.title) {
        NSDictionary *dicAttrib = @{kEvent_Practice_List_Item_ID:model.ids,kEvent_Practice_List_Item_Name:model.title};
        [MobClick event:kEvent_Practice_List_Item attributes:dicAttrib];
    } else {
        [MobClick event:kEvent_Practice_List_Item];
    }
}

@end
