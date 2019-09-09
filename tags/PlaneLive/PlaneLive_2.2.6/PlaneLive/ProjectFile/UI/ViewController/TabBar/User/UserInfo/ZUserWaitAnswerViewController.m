//
//  ZUserWaitAnswerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserWaitAnswerViewController.h"
#import "ZMyWaitAnswerTVC.h"

@interface ZUserWaitAnswerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) ZMyWaitAnswerTVC *tvcItem;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ModelUserBase *modelUB;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZUserWaitAnswerViewController

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
    
    self.tvcItem = [[ZMyWaitAnswerTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshData:YES];
    }];
    
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [super innerInit];
}

-(void)innerData
{
    NSString *localKey = [NSString stringWithFormat:@"MyWaitAnswerKey%@",self.modelUB.userId];
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
    NSString *localKey = [NSString stringWithFormat:@"MyWaitAnswerKey%@",self.modelUB.userId];
    
    NSArray *arrR = [dicResult objectForKey:kResultKey];
    if (arrR && [arrR isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in arrR) {
            ModelWaitAnswer *model = [[ModelWaitAnswer alloc] initWithCustom:dic];
            [arr addObject:model];
        }
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arr.count == 0) {
                [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
            }
        }
        if (arr.count >= kPAGE_MAXCOUNT) {
            [self.tvMain setRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [self.tvMain removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arr];
        [self.tvMain reloadData];
    } else {
        if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];}
    }
}

-(void)setRefreshData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNum = 1;
    if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV1 postMyGetQueryInviteAnswersWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    [snsV1 postMyGetQueryInviteAnswersWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    [snsV1 postMyGetQueryInviteAnswersWithUserId:self.modelUB.userId pageNum:self.pageNum+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
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

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([Utils isMyUserId:self.modelUB.userId]) {
        return YES;
    }
    return NO;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWEAKSELF
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                             title:kDelete
                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                           {
                                               ModelWaitAnswer *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
                                               [snsV1 postMyDelInviteAnswersWithUserId:kLoginUserId questionId:model.ids resultBlock:nil errorBlock:nil];
                                               
                                               [weakSelf.arrMain removeObjectAtIndex:indexPath.row];
                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                               
                                               if (weakSelf.arrMain.count == 0) {
                                                   [weakSelf setPageNum:1];
                                                   [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                                               }
                                           }];
    [editRowAction setBackgroundColor:COLORDELETE];
    return @[editRowAction];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelWaitAnswer *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem getHWithModel:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZMyWaitAnswerTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyWaitAnswerTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelWaitAnswer *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    ZWEAKSELF
    [cell setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelWaitAnswer *model = [self.arrMain objectAtIndex:indexPath.row];
    
    ModelQuestionBase *modelB = [[ModelQuestionBase alloc] init];
    [modelB setIds:model.ids];
    [modelB setTitle:model.title];
    
    [self showQuestionDetailVC:modelB];
}

@end
