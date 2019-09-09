//
//  ZPracticeAnswerViewController.m
//  PlaneLive
//
//  Created by Daniel on 22/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeAnswerViewController.h"
#import "ZPracticeQuestionTableView.h"
#import "ZPracticeHotQuestionViewController.h"

@interface ZPracticeAnswerViewController ()

@property (strong, nonatomic) ZPracticeQuestionTableView *tvMain;

@property (strong, nonatomic) ModelPractice *modelP;

@property (assign, nonatomic) int pageNum;

///最后偏移量
@property (assign, nonatomic) CGFloat lastOffsetY;

@end

@implementation ZPracticeAnswerViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"讲师答疑"];
    
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
    OBJC_RELEASE(_modelP);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvMain = [[ZPracticeQuestionTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.tvMain];
    
    [self.tvMain setViewDataWithModel:self.modelP];
    
    [self innerData];
    
    [super innerInit];
    
    [self innerEvnet];
}

-(void)innerData
{
    NSArray *arrHot = [sqlite getLocalPracticeQuestionWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot)];
    if (arrHot && arrHot.count > 0) {
        NSString *pageSizeHot = [sqlite getSysParamWithKey:@"PracticeHotPageSize"];
        NSString *questionCount = [sqlite getSysParamWithKey:[NSString stringWithFormat:@"PracticeHotQuestionCount%@",self.modelP.ids]];
        [self.tvMain setViewHotDataWithArray:arrHot isHeader:YES pageSizeHot:[pageSizeHot intValue] questionCount:[questionCount integerValue]];
    }
    NSArray *arrNew = [sqlite getLocalPracticeQuestionWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeNew)];
    if (arrNew && arrNew.count > 0) {
        NSString *questionCount = [sqlite getSysParamWithKey:[NSString stringWithFormat:@"PracticeNewQuestionCount%@",self.modelP.ids]];
        [self.tvMain setViewNewDataWithArray:arrNew isHeader:YES questionCount:[questionCount integerValue]];
    }
    
    [self setRefreshHotHeader];
    
    [self setRefreshNewHeader];
}
///初始化事件
-(void)innerEvnet
{
    ZWEAKSELF
    ///偏移量
    [self.tvMain setOnOffsetChange:^(CGFloat y) {
        [weakSelf setLastOffsetY:y];
    }];
    ///刷新顶部数据
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHotHeader];
        [weakSelf setRefreshNewHeader];
    }];
    ///刷新底部数据
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshNewFooter];
    }];
    [self.tvMain setOnViewBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setViewBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHotHeader];
        [weakSelf setRefreshNewHeader];
    }];
    ///热门查看全部点击
    [self.tvMain setOnHotAllClick:^{
        ZPracticeHotQuestionViewController *itemVC = [[ZPracticeHotQuestionViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.modelP];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///问题详情
    [self.tvMain setOnQuestionRowClick:^(ModelQuestionBase *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    ///回答详情
    [self.tvMain setOnAnswerRowClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    ///用户头像点击
    [self.tvMain setOnImagePhotoClick:^(ModelUserBase *model) {
        if ([Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
}
///删除问题回调方法
-(void)setDeleteQuestion:(ModelQuestionBase *)model
{
    [self.tvMain setDeleteQuestion:model];
}
///热门刷新顶部
-(void)setRefreshHotHeader
{
    ZWEAKSELF
    [snsV1 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:1 pageSize:0 resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            [weakSelf.tvMain setViewHotDataWithArray:arrResult isHeader:YES pageSizeHot:pageSizeHot questionCount:questionCount];
            
            [sqlite setLocalPracticeQuestionWithArray:arrResult practiceId:weakSelf.modelP.ids type:(ZPracticeQuestionTypeHot)];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain setViewHotDataWithArray:nil isHeader:YES pageSizeHot:0 questionCount:0];
        });
    }];
}
///最新刷新顶部
-(void)setRefreshNewHeader
{
    self.pageNum = 1;
    ZWEAKSELF
    [snsV1 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeNew) pageNum:1 pageSize:kPAGE_MAXCOUNT resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            [weakSelf.tvMain setViewNewDataWithArray:arrResult isHeader:YES questionCount:questionCount];
            
            [sqlite setLocalPracticeQuestionWithArray:arrResult practiceId:weakSelf.modelP.ids type:(ZPracticeQuestionTypeNew)];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain setViewNewDataWithArray:nil isHeader:YES questionCount:0];
        });
    }];
}
///最新刷新底部
-(void)setRefreshNewFooter
{
    ZWEAKSELF
    [snsV1 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeNew) pageNum:self.pageNum+1 pageSize:kPAGE_MAXCOUNT resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf.tvMain setViewNewDataWithArray:arrResult isHeader:NO questionCount:questionCount];
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

@end
