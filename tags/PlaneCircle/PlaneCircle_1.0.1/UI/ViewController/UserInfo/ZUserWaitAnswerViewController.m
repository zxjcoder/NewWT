//
//  ZUserWaitAnswerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserWaitAnswerViewController.h"
#import "ZMyQuestionTVC.h"

@interface ZUserWaitAnswerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

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
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
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
    
    self.tvMain = [[ZBaseTableView alloc] init];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZMyQuestionTVC getH]];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshData:YES];
    }];
    
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
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
            ModelQuestionDetail *model = [[ModelQuestionDetail alloc] initWithCustom:dic];
            [arr addObject:model];
        }
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arr.count == 0) {
                if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];}
            }
            [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
        }
        if (arr.count > kPAGE_MAXCOUNT) {
            [self.tvMain addRefreshFooterWithEndBlock:^{
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
    [sns postMyGetQueryInviteAnswersWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    [sns postMyGetQueryInviteAnswersWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    [sns postMyGetQueryInviteAnswersWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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

-(void)setDeleteModelWithModel:(ModelQuestionDetail *)model
{
    [sns postMyDelInviteAnswersWithUserId:[AppSetting getUserDetauleId] questionId:model.ids resultBlock:nil errorBlock:nil];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZMyQuestionTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyQuestionTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    [cell setViewIsDelete:YES];
    
    [cell setTag:indexPath.row];
    
    ModelQuestionDetail *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    ZWEAKSELF
    [cell setOnDeleteClick:^(ModelQuestionDetail *model, ZMyQuestionTVC *tvc) {
        [weakSelf setDeleteModelWithModel:model];
        
        [weakSelf.arrMain removeObjectAtIndex:tvc.tag];
        [weakSelf.tvMain deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tvc.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionDetail *model = [self.arrMain objectAtIndex:indexPath.row];
    
    ModelQuestionBase *modelB = [[ModelQuestionBase alloc] init];
    [modelB setIds:model.ids];
    [modelB setTitle:model.title];
    
    [self showQuestionDetailVC:modelB];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
