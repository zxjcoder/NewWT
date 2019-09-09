//
//  ZMessageListViewController.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZMessageListViewController.h"
#import "ZWebContentViewController.h"
#import "ZUserMessageTVC.h"

@interface ZMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZUserMessageTVC *tvcItem;
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (assign, nonatomic) int pageNum;
@property (strong, nonatomic) NSMutableDictionary *dicShowAll;

@end

@implementation ZMessageListViewController

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
-(void)setViewNil
{
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_dicShowAll);
    
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
    self.dicShowAll = [NSMutableDictionary dictionary];
    self.tvcItem = [[ZUserMessageTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.view addSubview:self.tvMain];
    
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
    [super innerInit];
}
-(void)innerLocalData
{
    NSArray *arr = [sqlite getLocalMyMessageArrayWithUserId:kLoginUserId];
    if (arr && arr.count > 0) {
        [self.arrMain addObjectsFromArray:arr];
        
        [self.tvMain reloadData];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getMyMessageArrayWithPageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
        [sqlite setLocalMyMessageWithArray:arrResult userId:kLoginUserId];
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
    [snsV2 getMyMessageArrayWithPageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNum += 1;
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
-(void)setShowSubscribeVC:(ModelMyMessage *)model
{
    ModelCurriculum *modelC = [sqlite getLocalPlayCurriculumDetailWithUserId:kLoginUserId ids:model.course_id];
    if (modelC) {
        ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
        [itemVC setViewDataWithModel:modelC isCourse:NO];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        ZWEAKSELF
        [ZProgressHUD showMessage:kCMsgGeting];
        [snsV2 getCurriculumDetailWithCurriculumId:model.course_id resultBlock:^(ModelCurriculum *resultModel, NSDictionary *result) {
            [ZProgressHUD dismiss];
            ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
            [itemVC setViewDataWithModel:resultModel isCourse:NO];
            [weakSelf.navigationController pushViewController:itemVC animated:YES];
            
            [sqlite setLocalPlayCurriculumDetailWithModel:resultModel userId:kLoginUserId];
        } errorBlock:^(NSString *msg) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        }];
    }
}
-(void)setDeleteMessage:(ModelMyMessage *)model row:(NSInteger)row
{
    ZWEAKSELF
    [ZAlertView showWithMessage:kAreYouSureYouWantToDeleteThisMessage doneCompletion:^{
        [weakSelf.dicShowAll removeObjectForKey:model.ids];
        [weakSelf.arrMain removeObjectAtIndex:row];
        [snsV2 postDelMessageContentWithMessageId:model.ids resultBlock:nil errorBlock:nil];
        [weakSelf.tvMain reloadData];
    }];
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelMyMessage *model = [self.arrMain objectAtIndex:indexPath.row];
    BOOL isShowAll = [[self.dicShowAll objectForKey:model.ids] boolValue];
    [self.tvcItem setShowAllState:isShowAll];
    return [self.tvcItem setCellDataWithModel:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZUserMessageTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZUserMessageTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelMyMessage *model = [self.arrMain objectAtIndex:indexPath.row];
    BOOL isShowAll = [[self.dicShowAll objectForKey:model.ids] boolValue];
    [cell setShowAllState:isShowAll];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnDeleteClick:^(NSInteger row, ModelMyMessage *modelM) {
        [weakSelf setDeleteMessage:modelM row:row];
    }];
    [cell setOnSubscribeClick:^(ModelMyMessage *modelM) {
        [weakSelf setShowSubscribeVC:modelM];
    }];
    [cell setOnRowHeightChange:^(BOOL isShowAll, NSString *ids) {
        [weakSelf.dicShowAll setObject:[NSNumber numberWithBool:isShowAll] forKey:ids];
        [weakSelf.tvMain reloadData];
    }];
    return cell;
}

@end
