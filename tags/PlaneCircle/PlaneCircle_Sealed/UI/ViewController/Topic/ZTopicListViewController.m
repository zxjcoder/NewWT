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
#import "ZPracticeQuestionViewController.h"

#import "ZTaskAlertView.h"
#import "ZTaskCenterViewController.h"

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
    ZWEAKSELF
    self.tvMain = [[ZTopicDetailView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnQuestionClick:^(ModelQuestionTopic *model) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    [self.tvMain setOnAnswerClick:^(ModelQuestionTopic *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.answerContent];
        [modelAB setUserId:model.userIdA];
        [modelAB setNickname:model.head_imgA];
        [modelAB setSign:model.signA];
        [modelAB setNickname:model.nicknameA];
        [weakSelf showAnswerDetailVC:modelAB];
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
}
-(void)innerData
{
    ModelTag *modelT = [sqlite getLocalTopicModelWithUserId:[AppSetting getUserDetauleId] topicId:self.model.tagId];
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
    ModelPractice *model = [arrPractice objectAtIndex:rowIndex];
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
        for (ModelPractice *modelP in arrPractice) {
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
    }
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
    [DataOper140 getTopicDetailWithTopicId:self.model.tagId userId:[AppSetting getUserDetauleId] pageNum:self.pageQuestionNum resultBlock:^(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshQuestionHeader];
            if (modelTag) {
                [weakSelf setModel:modelTag];
                
                [weakSelf.tvMain setViewDataWithModel:modelTag];
                
                [sqlite setLocalTopicModelWithModel:modelTag userId:[AppSetting getUserDetauleId]];
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
    [DataOper140 getTopicDetailWithTopicId:self.model.tagId userId:[AppSetting getUserDetauleId] pageNum:self.pageQuestionNum+1 resultBlock:^(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult) {
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
    [DataOper140 getTopicPracticeArrayWithTopicId:self.model.tagId userId:[AppSetting getUserDetauleId] pageNum:self.pagePracticeNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [DataOper140 getTopicPracticeArrayWithTopicId:self.model.tagId userId:[AppSetting getUserDetauleId] pageNum:self.pagePracticeNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *dicResult) {
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
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        if (self.isAttentioning){return;}
        self.isAttentioning = YES;
        if (model.isAtt) {
            [sns postDeleteAttentionWithAId:self.model.tagId userId:[AppSetting getUserDetauleId] type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                    
                    [weakSelf.model setIsAtt:NO];
                    weakSelf.model.attCount -= 1;
                    if (weakSelf.model.attCount < 0) {
                        [weakSelf.model setAttCount:0];
                    }
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
                    
                    [sqlite setLocalTopicModelWithModel:weakSelf.model userId:[AppSetting getUserDetauleId]];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                });
            }];
        } else {
            [sns postAddAttentionWithuserId:[AppSetting getUserDetauleId] hisId:self.model.tagId type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                    
                    [weakSelf.model setIsAtt:YES];
                    weakSelf.model.attCount += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
                    
                    [sqlite setLocalTopicModelWithModel:weakSelf.model userId:[AppSetting getUserDetauleId]];
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
