//
//  ZPracticeHotQuestionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/26/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeHotQuestionViewController.h"
#import "ZPracticeQuestionItemTVC.h"

@interface ZPracticeHotQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ZPracticeQuestionItemTVC *tvcItem;

@property (strong, nonatomic) ModelPractice *modelP;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZPracticeHotQuestionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kHotQuestion];
    
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
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelP);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcItem);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvcItem = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    [self setRefreshHeader];
    
    [super innerInit];
}
///删除问题回调方法
-(void)setDeleteQuestion:(ModelQuestionBase *)model
{
    BOOL isDel = NO;
    NSInteger row = 0;
    for (ModelPracticeQuestion *modelPQ in self.arrMain) {
        if ([modelPQ.ids isEqualToString:model.ids]) {
            isDel = YES;
            break;
        }
        row++;
    }
    if (isDel) {
        [self.arrMain removeObjectAtIndex:row];
    }
    [self.tvMain reloadData];
}
-(void)setRefreshHeader
{
    self.pageNum = 1;
    ZWEAKSELF
    [snsV1 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:self.pageNum pageSize:kPAGE_MAXCOUNT resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            if (arrResult.count >= kPAGE_MAXCOUNT) {
                [weakSelf.tvMain setRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
            
            [weakSelf.arrMain removeAllObjects];
            
            [weakSelf.arrMain addObjectsFromArray:arrResult];
            
            if (arrResult.count == 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            } else {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
            
            [weakSelf.tvMain reloadData];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
        });
    }];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV1 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:self.pageNum+1 pageSize:kPAGE_MAXCOUNT resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            
            [weakSelf.tvMain endRefreshFooter];
            
            if (arrResult.count >= kPAGE_MAXCOUNT) {
                [weakSelf.tvMain setRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
            
            [weakSelf.arrMain addObjectsFromArray:arrResult];
            
            [weakSelf.tvMain reloadData];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModelP:model];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelPracticeQuestion *model = [self.arrMain objectAtIndex:indexPath.row];
    [self.tvcItem setCellDataWithModel:model];
    return [self.tvcItem getHWithModel:model];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    
    ZPracticeQuestionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelPracticeQuestion *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    ZWEAKSELF
    [cell setOnAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    [cell setOnImagePhotoClick:^(ModelUserBase *model) {
        if ([Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelPracticeQuestion *model = [self.arrMain objectAtIndex:indexPath.row];
    
    ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
    [modelQB setIds:model.ids];
    [modelQB setTitle:model.title];
    
    [self showQuestionDetailVC:modelQB];
    
}

@end
