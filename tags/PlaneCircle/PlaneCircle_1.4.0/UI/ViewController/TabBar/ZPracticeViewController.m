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
#import "ZPracticeQuestionViewController.h"
#import "ZTaskAlertView.h"
#import "ZTaskCenterViewController.h"

@interface ZPracticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;
///最后一次播放实务对象
@property (strong, nonatomic) ModelPractice *modelPLastPlay;

@end

@implementation ZPracticeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPractice];
    
    [self innerInit];
    
    [self registerLoginChangeNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ModelPractice *modelPlay = [sqlite getLocalPlayPracticeModel];
    if (![modelPlay.ids isEqualToString:self.modelPLastPlay.ids]) {
        [self setModelPLastPlay:modelPlay];
        
        [self.tvMain reloadData];
    }
    
    [self setRefreshUserInfo];
}

- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZTaskCompleteNotification object:nil];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTaskComplete:) name:ZTaskCompleteNotification object:nil];
    
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
///刷新数据
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
///刷新顶部数据
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
///刷新底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    [sns getSpeechArrayWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
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
    //添加统计事件
    [StatisticsManager event:kEvent_Practice_Play category:kCategory_Practice];
    
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
        ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
        if (isExistence) {
            [itemVC setViewDataWithArray:self.arrMain arrDefaultRow:rowIndex];
        }
        [itemVC setViewDataWithModel:modelP];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
///刷新用户信息
-(void)setRefreshUserInfo
{
    [sns postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
        GCDMainBlock(^{
            if (resultModel) {
                [AppSetting setUserLogin:resultModel];
                [AppSetting save];
                
                [sqlite setLocalTaskArrayWithArray:[result objectForKey:@"myTask"] userId:resultModel.userId];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
            }
        });
    } errorBlock:nil];
}
///登录改变
-(void)setLoginChange
{
    [self refreshData:NO];
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
///任务完成
-(void)setTaskComplete:(NSNotification *)sender
{
    for (ModelPractice *modelP in self.arrMain) {
        if ([modelP.ids isEqualToString:sender.object]) {
            [modelP setUnlock:0];
            
            [self.tvMain reloadData];
            
            [sqlite setLocalPracticeDetailWithModel:modelP userId:[AppSetting getUserDetauleId]];
            break;
        }
    }
    [self.tvMain reloadData];
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
    
    if ([model.ids isEqualToString:self.modelPLastPlay.ids]) {
        [cell setModelPlayStatus:YES];
    } else {
        [cell setModelPlayStatus:NO];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    ///进行解锁的行为
    if (model.unlock == 1) {
        if ([AppSetting getAutoLogin]) {
            NSArray *arrTask = [sqlite getLocalTaskArrayWithUserId:[AppSetting getUserDetauleId] speechId:model.ids];
            if (arrTask == nil || arrTask.count == 0) {
                NSMutableString *strContent = [NSMutableString string];
                int index = 1;
                for (NSDictionary *dicTask in model.arrTasks) {
                    if (strContent.length > 0) {
                        [strContent appendString:@"\n"];
                    }
                    NSString *content = [dicTask objectForKey:@"content"];
                    content = content==nil?kEmpty:content;
                    [strContent appendString:[NSString stringWithFormat:@"%@%d: %@", kTaskKey, index, content]];
                    index++;
                }
                ZWEAKSELF
                ZTaskAlertView *taskAlertView = [[ZTaskAlertView alloc] initWithContent:strContent];
                [taskAlertView setOnSubmitClick:^{
                    [ZProgressHUD showMessage:kCMsgAccepting];
                    [DataOper140 acceptMyTaskWithUserId:[AppSetting getUserDetauleId] speechId:model.ids resultBlock:^(NSDictionary *result) {
                        GCDMainBlock(^{
                            [ZProgressHUD dismiss];
                            ZTaskCenterViewController *itemVC = [[ZTaskCenterViewController alloc] init];
                            [itemVC setPreVC:weakSelf];
                            [itemVC setHidesBottomBarWhenPushed:YES];
                            [weakSelf.navigationController pushViewController:itemVC animated:YES];
                        });
                    } errorBlock:^(NSString *msg) {
                        GCDMainBlock(^{
                            [ZProgressHUD dismiss];
                            [ZProgressHUD showError:msg];
                        });
                    }];
                }];
                [taskAlertView show];
            } else {
                ZWEAKSELF
                [ZAlertView showWithTitle:kPracticeHasNotYetBeenUnlocked message:kFirstToTheTaskCenterToCompleteTheTaskBar completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    switch (selectIndex) {
                        case 1:
                        {
                            ZTaskCenterViewController *itemVC = [[ZTaskCenterViewController alloc] init];
                            [itemVC setPreVC:weakSelf];
                            [itemVC setHidesBottomBarWhenPushed:YES];
                            [weakSelf.navigationController pushViewController:itemVC animated:YES];
                            break;
                        }
                        default: break;
                    }
                } cancelTitle:kCancel doneTitle:kGoToUnlock];
            }
        } else {
            [[ZDragButton shareDragButton] dismiss];
            
            [self showLoginVC];
        }
    } else {
        ZPracticeQuestionViewController *itemVC = [[ZPracticeQuestionViewController alloc] init];
        [itemVC setPreVC:self];
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
        int index = 0;
        NSInteger defaultRow = 0;
        NSMutableArray *arrP = [NSMutableArray array];
        for (ModelPractice *modelP in self.arrMain) {
            if ([modelP.ids isEqualToString:model.ids]) {
                defaultRow = index;
            }
            if (modelP.unlock == 0) {
                [arrP addObject:modelP];
                index++;
            }
        }
        [itemVC setViewDataWithArray:arrP arrDefaultRow:defaultRow];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
        
        if (model.ids && model.title) {
            //添加统计事件
            NSDictionary *dicAttrib = @{kEvent_Practice_List_Item_ID:model.ids,kEvent_Practice_List_Item_Name:model.title};
            [StatisticsManager event:kEvent_Practice_List_Item category:kCategory_Practice dictionary:dicAttrib];
        } else {
            //添加统计事件
            [StatisticsManager event:kEvent_Practice_List_Item category:kCategory_Practice];
        }
    }
}

@end
