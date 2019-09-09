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
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
}

-(void)innerData
{
    NSArray *arrHot = [sqlite getLocalPracticeQuestionWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot)];
    if (arrHot && arrHot.count > 0) {
        
        [self.arrMain addObjectsFromArray:arrHot];
        
        [self.tvMain reloadData];
    }
    self.pageNum = 1;
    ZWEAKSELF
    [DataOper130 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:self.pageNum resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            [weakSelf.arrMain removeAllObjects];
            
            [weakSelf.arrMain addObjectsFromArray:arrResult];
            
            [weakSelf.tvMain reloadData];
        });
    } errorBlock:^(NSString *msg) {
        
    }];
}

-(void)setRefreshHeader
{
    self.pageNum = 1;
    ZWEAKSELF
    [DataOper130 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:self.pageNum resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            if (arrResult.count >= pageSizeHot) {
                [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
                    [weakSelf setRefreshFooter];
                }];
            } else {
                [weakSelf.tvMain removeRefreshFooter];
            }
            
            [weakSelf.arrMain removeAllObjects];
            
            [weakSelf.arrMain addObjectsFromArray:arrResult];
            
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
    [DataOper130 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            
            [weakSelf.tvMain endRefreshFooter];
            
            if (arrResult.count >= pageSizeHot) {
                [weakSelf.tvMain addRefreshFooterWithEndBlock:^{
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
    
    __weak typeof(self) weakSelf = self;
    [cell setOnAnswerClick:^(ModelPracticeQuestion *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setTitle:model.answerContent];
        [modelAB setQuestion_id:model.ids];
        [modelAB setQuestion_title:model.title];
        [modelAB setUserId:model.userId];
        [modelAB setHead_img:model.head_img];
        [modelAB setNickname:model.nickname];
        [weakSelf showAnswerDetailVC:modelAB];
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
