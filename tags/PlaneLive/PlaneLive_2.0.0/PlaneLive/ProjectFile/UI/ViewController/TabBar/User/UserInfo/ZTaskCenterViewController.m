//
//  ZTaskCenterViewController.m
//  PlaneCircle
//
//  Created by Daniel on 9/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTaskCenterViewController.h"
#import "ZMyTaskItemTVC.h"

#import "ZEditUserInfoViewController.h"

@interface ZTaskCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZTaskCenterViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kTaskCenter];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshHeader];
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
    [self.tvMain setRowHeight:[ZMyTaskItemTVC getH]];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setBackgroundClick];
    }];
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
    
    [super innerInit];
}

-(void)innerData
{
    NSArray *arrTask = [sqlite getLocalTaskArrayWithUserId:[AppSetting getUserDetauleId]];
    [self.arrMain removeAllObjects];
    if (arrTask && arrTask.count > 0) {
        [self.arrMain addObjectsFromArray:arrTask];
        
        [self.tvMain reloadData];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
}

-(void)setBackgroundClick
{
    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
 
    [self setRefreshHeader];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    [DataOper140 getMyTaskArrayWithUserId:[AppSetting getUserDetauleId] resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            [weakSelf.arrMain removeAllObjects];
            [weakSelf.arrMain addObjectsFromArray:arrResult];
            if (arrResult.count == 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
            [weakSelf.tvMain reloadData];
            
            [sqlite setLocalTaskArrayWithArray:arrResult userId:[AppSetting getUserDetauleId]];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            if (weakSelf.arrMain.count == 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        });
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelTask *modelT = [self.arrMain objectAtIndex:indexPath.row];
    if (modelT.status == 1) {
        return YES;
    }
    return NO;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:( NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            ModelTask *modelT = [self.arrMain objectAtIndex:indexPath.row];
            
            [DataOper140 delMyTaskWithUserId:[AppSetting getUserDetauleId] taskId:modelT.ids resultBlock:nil errorBlock:nil];
            
            [self.arrMain removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            if (self.arrMain.count == 0) {
                [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
            break;
        }
        default: break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZMyTaskItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyTaskItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelTask *modelT = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelT];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelTask *model = [self.arrMain objectAtIndex:indexPath.row];
    if (model.status == 0) {
        switch (model.rule) {
            case ZTaskTypeEditUserInfo:
            {
                ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZTaskTypeInvitationAnswerQuestion:
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZChangeTabbarItem object:@"3"];
                break;
            }
            case ZTaskTypeAnswerOtherUserQuestion:
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZChangeTabbarItem object:@{@"index":@"0"}];
                break;
            }
            case ZTaskTypeSharePracticeToCircle:
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZChangeTabbarItem object:@"1"];
                break;
            }
            case ZTaskTypeAttentionQuestion:
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZChangeTabbarItem object:@"3"];
                break;
            }
            default: break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
