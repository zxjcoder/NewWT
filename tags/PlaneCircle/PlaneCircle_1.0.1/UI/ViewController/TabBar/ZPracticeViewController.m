//
//  ZPracticeViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeViewController.h"
#import "ZPracticeItemTVC.h"

#import "ZPracticeDetailViewController.h"

static NSString *localKey = @"PracticeArrayKey";

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayStart:) name:ZPlayChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayChangeNotification object:nil];
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_TABB_FRAME];
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
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticeChangeNotification object:nil];
    
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
    
    self.tvMain = [[ZBaseTableView alloc] init];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZPracticeItemTVC getH]];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf refreshData:YES];
    }];
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
}

-(void)setPlayStart:(NSNotification *)sender
{
    [self setRightButtonWithPlay];
}

-(void)innerData
{
    BOOL isRefresh = YES;
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:localKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *arrResult = [dicLocal objectForKey:kResultKey];
        if (arrResult && [arrResult isKindOfClass:[NSArray class]] && arrResult.count > 0) {
            isRefresh = NO;
            for (NSDictionary *dic in arrResult) {
                ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dic];
                [self.arrMain addObject:modelP];
            }
            [self.tvMain reloadData];
        }
    }
    [self refreshData:isRefresh];
}

-(void)refreshData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNum = 1;
    if (isRefresh) {[weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                NSArray *arrResult = [result objectForKey:kResultKey];
                if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
                    [weakSelf.arrMain removeAllObjects];
                    for (NSDictionary *dic in arrResult) {
                        ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dic];
                        
                        [sqlite setLocalPracticeWithModel:modelP];
                        
                        [weakSelf.arrMain addObject:modelP];
                    }
                    if (weakSelf.arrMain.count >= kPAGE_MAXCOUNT) {
                        [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                            [weakSelf setRefreshFooter];
                        }];
                    } else {
                        [weakSelf.tvMain removeRefreshFooter];
                    }
                    [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
                } else {
                    if (isRefresh) {
                        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                    }
                }
            } else {
                if (isRefresh) {
                    [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                }
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
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                NSArray *arrResult = [result objectForKey:kResultKey];
                if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
                    [weakSelf.arrMain removeAllObjects];
                    for (NSDictionary *dic in arrResult) {
                        ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dic];
                        
                        [sqlite setLocalPracticeWithModel:modelP];
                        
                        [weakSelf.arrMain addObject:modelP];
                    }
                    if (arrResult.count >= kPAGE_MAXCOUNT) {
                        [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                            [weakSelf setRefreshFooter];
                        }];
                    } else {
                        [weakSelf.tvMain removeRefreshFooter];
                    }
                    [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
                }
                [weakSelf.tvMain reloadData];
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
    self.pageNum += 1;
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
         
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                NSArray *arrResult = [result objectForKey:kResultKey];
                if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrResult) {
                        ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dic];
                        
                        [sqlite setLocalPracticeWithModel:modelP];
                        
                        [weakSelf.arrMain addObject:modelP];
                    }
                    if (arrResult.count >= kPAGE_MAXCOUNT) {
                        [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                            [weakSelf setRefreshFooter];
                        }];
                    } else {
                        [weakSelf.tvMain removeRefreshFooter];
                    }
                } else {
                    [weakSelf.tvMain removeRefreshFooter];
                }
                [weakSelf.tvMain reloadData];
            }
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
        ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
        [itemVC setNavigationBarHidden:YES];
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
    [itemVC setNavigationBarHidden:YES];
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
