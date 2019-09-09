//
//  ZMyAnswerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerViewController.h"
#import "ZMyAnswerTVC.h"

#import "ZQuestionDetailViewController.h"

@interface ZMyAnswerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZMyAnswerTVC *tvcItem;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ModelUserBase *modelUB;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZMyAnswerViewController

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
    
    self.tvcItem = [[ZMyAnswerTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] init];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
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
    NSString *localKey = [NSString stringWithFormat:@"MyAnswerKey%@",self.modelUB.userId];
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
    NSString *localKey = [NSString stringWithFormat:@"MyAnswerKey%@",self.modelUB.userId];
    NSArray *arrResult = [dicResult objectForKey:@"myReply"];
    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrR = [NSMutableArray array];
        for (NSDictionary *dic in arrResult) {
            ModelQuestionMyAnswer *modelQMA = [[ModelQuestionMyAnswer alloc] initWithCustom:dic];
            [arrR addObject:modelQMA];
        }
        if (isHeader) {
            [self.arrMain removeAllObjects];
            
            if(isRefresh || arrR.count == 0){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];}
            
            [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
        }
        if (arrR.count > kPAGE_MAXCOUNT) {
            [self.tvMain addRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [self.tvMain removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrR];
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
    [sns postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    [sns postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    [sns postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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

-(void)setDeleteMyAnswerClick:(ModelQuestionMyAnswer *)model
{
    [sns postDeleteAnswerWithAnswerId:model.ids userId:[AppSetting getUserDetauleId] resultBlock:nil errorBlock:nil];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionMyAnswer *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem getHWithModel:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZMyAnswerTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyAnswerTVC alloc] initWithReuseIdentifier:cellid];
    }
    if ([self.modelUB.userId isEqualToString:[AppSetting getUserDetauleId]]) {
        [cell setViewIsDelete:YES];
    } else {
        [cell setViewIsDelete:NO];
    }
    ModelQuestionMyAnswer *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnDeleteClick:^(ModelQuestionMyAnswer *model, ZMyAnswerTVC *tvc) {
        [weakSelf setDeleteMyAnswerClick:model];
        
        [weakSelf.arrMain removeObjectAtIndex:tvc.tag];
        [weakSelf.tvMain deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tvc.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionMyAnswer *model = [self.arrMain objectAtIndex:indexPath.row];
    
    ModelQuestionBase *modelB = [[ModelQuestionBase alloc] init];
    [modelB setIds:model.ids];
    [modelB setTitle:model.title];
    
    [self showQuestionDetailVC:modelB];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
