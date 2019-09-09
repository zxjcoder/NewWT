//
//  ZTopicListViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicListViewController.h"
#import "ZTopicDetailView.h"

#import "ZQuestionDetailViewController.h"

@interface ZTopicListViewController ()

@property (strong ,nonatomic) ZTopicDetailView *tvMain;

@property (assign, nonatomic) int pageQuestionNum;

@property (assign, nonatomic) int pagePracticeNum;

@property (strong, nonatomic) ModelTag *model;
///关注中
@property (assign, nonatomic) BOOL isAttentioning;

@end

@implementation ZTopicListViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kTopic];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if (self.isShowLogin) {
        self.isShowLogin = NO;
        
        [self setQuestionRefreshHeader];
    }
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
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [StatisticsManager event:kCircle_Topic_ListItem_Practice];
    
    ZWEAKSELF
    self.tvMain = [[ZTopicDetailView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnQuestionClick:^(ModelQuestionBase *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    [self.tvMain setOnAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    [self.tvMain setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    [self.tvMain setOnPracticeClick:^(NSArray *arrPractice, NSInteger rowIndex) {
        [weakSelf setShowPracticeVC:arrPractice rowIndex:rowIndex];
    }];
    [self.tvMain setOnQuestionRefreshHeader:^{
        [weakSelf setQuestionRefreshHeader];
    }];
    [self.tvMain setOnQuestionRefreshFooter:^{
        [weakSelf setQuestionRefreshFooter];
    }];
    [self.tvMain setOnPracticeRefreshHeader:^{
        [weakSelf setPracticeRefreshHeader];
    }];
    [self.tvMain setOnPracticeRefreshFooter:^{
        [weakSelf setPracticeRefreshFooter];
    }];
    [self.tvMain setOnAttentionClick:^(ModelTag *model) {
        [weakSelf setAttTopicClickWithModel:model];
    }];
    [self.tvMain setOnQuestionBackgroundClick:^{
        [weakSelf setOnQuestionBackground];
    }];
    [self.tvMain setOnPracticeBackgroundClick:^{
        [weakSelf setOnPracticeBackground];
    }];
    [self.view addSubview:self.tvMain];
    
    [self innerData];
    
    [super innerInit];
}
-(void)innerData
{
    ModelTag *modelT = [sqlite getLocalTopicModelWithUserId:kLoginUserId topicId:self.model.tagId];
    if (modelT) {
        [self setModel:modelT];
    }
    [self.tvMain setViewDataWithModel:self.model];
    
    NSArray *arrQuestion = [sqlite getLocalTopicQuestionArrayWithTopicId:self.model.tagId];
    if (arrQuestion && arrQuestion.count > 0) {
        [self.tvMain setViewDataQuestionWithArray:arrQuestion isHeader:YES];
    } else {
        [self.tvMain setQuestionBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setQuestionRefreshHeader];
    
    NSArray *arrPractice = [sqlite getLocalTopicPracticeArrayWithTopicId:self.model.tagId];
    if (arrPractice && arrPractice.count > 0) {
        [self.tvMain setViewDataPracticeWithArray:arrPractice isHeader:YES];
    } else {
        [self.tvMain setPracticeBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setPracticeRefreshHeader];
}
///显示实务详情
-(void)setShowPracticeVC:(NSArray *)arrPractice rowIndex:(NSInteger)rowIndex
{
    [StatisticsManager event:kCircle_Topic_ListItem_Practice_ListItem];
    [self showPlayVCWithPracticeArray:arrPractice index:rowIndex];
}
///按钮刷新问题数据
-(void)setOnQuestionBackground
{
    [self.tvMain setQuestionBackgroundViewWithState:(ZBackgroundStateLoading)];
    
    [self setQuestionRefreshHeader];
}
///按钮刷新实务数据
-(void)setOnPracticeBackground
{
    [self.tvMain setPracticeBackgroundViewWithState:(ZBackgroundStateLoading)];
    
    [self setPracticeRefreshHeader];
}
///刷新问题顶部数据
-(void)setQuestionRefreshHeader
{
    ZWEAKSELF
    self.pageQuestionNum = 1;
    [snsV1 getTopicDetailWithTopicId:self.model.tagId userId:kLoginUserId pageNum:self.pageQuestionNum resultBlock:^(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshQuestionHeader];
            if (modelTag) {
                [weakSelf setModel:modelTag];
                
                [weakSelf.tvMain setViewDataWithModel:modelTag];
                
                [sqlite setLocalTopicModelWithModel:modelTag userId:kLoginUserId];
            }
            [weakSelf.tvMain setViewDataQuestionWithArray:arrResult isHeader:YES];
            
            [sqlite setLocalTopicQuestionArrayWithArray:arrResult topicId:weakSelf.model.tagId];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshQuestionHeader];
            [weakSelf.tvMain setViewDataQuestionWithArray:nil isHeader:YES];
        });
    }];
}
///刷新问题底部数据
-(void)setQuestionRefreshFooter
{
    ZWEAKSELF
    [snsV1 getTopicDetailWithTopicId:self.model.tagId userId:kLoginUserId pageNum:self.pageQuestionNum+1 resultBlock:^(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult) {
        GCDMainBlock(^{
            weakSelf.pageQuestionNum += 1;
            [weakSelf.tvMain endRefreshQuestionFooter];
            
            [weakSelf.tvMain setViewDataQuestionWithArray:arrResult isHeader:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshQuestionFooter];
            [weakSelf.tvMain setViewDataQuestionWithArray:nil isHeader:NO];
        });
    }];
}
///刷新实务顶部数据
-(void)setPracticeRefreshHeader
{
    ZWEAKSELF
    self.pagePracticeNum = 1;
    [snsV1 getTopicPracticeArrayWithTopicId:self.model.tagId userId:kLoginUserId pageNum:self.pagePracticeNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshPracticeHeader];
            
            [weakSelf.tvMain setViewDataPracticeWithArray:arrResult isHeader:YES];
            
            [sqlite setLocalTopicPracticeArrayWithArray:arrResult topicId:weakSelf.model.tagId];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshPracticeHeader];
            [weakSelf.tvMain setViewDataPracticeWithArray:nil isHeader:YES];
        });
    }];
}
///刷新实务底部数据
-(void)setPracticeRefreshFooter
{
    ZWEAKSELF
    [snsV1 getTopicPracticeArrayWithTopicId:self.model.tagId userId:kLoginUserId pageNum:self.pagePracticeNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *dicResult) {
        GCDMainBlock(^{
            weakSelf.pagePracticeNum += 1;
            [weakSelf.tvMain endRefreshPracticeFooter];
            
            [weakSelf.tvMain setViewDataPracticeWithArray:arrResult isHeader:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshPracticeFooter];
            [weakSelf.tvMain setViewDataPracticeWithArray:nil isHeader:NO];
        });
    }];
}
///关注
-(void)setAttTopicClickWithModel:(ModelTag *)model
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZWEAKSELF
        if (self.isAttentioning){return;}
        self.isAttentioning = YES;
        if (model.isAtt) {
            [snsV1 postDeleteAttentionWithAId:self.model.tagId userId:kLoginUserId type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                    
                    [weakSelf.model setIsAtt:NO];
                    weakSelf.model.attCount -= 1;
                    if (weakSelf.model.attCount < 0) {
                        [weakSelf.model setAttCount:0];
                    }
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
                    
                    [sqlite setLocalTopicModelWithModel:weakSelf.model userId:kLoginUserId];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                });
            }];
        } else {
            [snsV1 postAddAttentionWithuserId:kLoginUserId hisId:self.model.tagId type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                    
                    [weakSelf.model setIsAtt:YES];
                    weakSelf.model.attCount += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
                    
                    [sqlite setLocalTopicModelWithModel:weakSelf.model userId:kLoginUserId];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}

-(void)setViewDataWithModel:(ModelTag *)model
{
    [self setModel:model];
}

@end
