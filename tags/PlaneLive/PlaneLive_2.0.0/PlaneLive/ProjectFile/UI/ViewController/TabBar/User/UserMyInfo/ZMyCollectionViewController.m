//
//  ZMyCollectionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionViewController.h"
#import "ZMyCollectionView.h"

@interface ZMyCollectionViewController ()

@property (strong, nonatomic) ZMyCollectionView *viewMain;

@property (strong, nonatomic) ModelUser *modelUB;

@property (assign, nonatomic) int pageNumPractice;
@property (assign, nonatomic) int pageNumAnswer;
@property (assign, nonatomic) int pageNumRank;

@end

@implementation ZMyCollectionViewController

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
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_modelUB);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.viewMain = [[ZMyCollectionView alloc] initWithFrame:VIEW_ITEM_FRAME];
    ///实务
    [self.viewMain setOnBackgroundPracticeClick:^(ZBackgroundState state) {
        [weakSelf setRefreshPracticeData:YES];
    }];
    [self.viewMain setOnRefreshPracticeHeader:^{
        [weakSelf setRefreshPracticeHeader];
    }];
    [self.viewMain setOnRefreshPracticeFooter:^{
        [weakSelf setRefreshPracticeHeader];
    }];
    [self.viewMain setOnPracticeRowClick:^(ModelCollection *model) {
        ModelPractice *modelP = [sqlite getLocalPracticeModelWithId:model.hotspot_id];
        if (modelP) {
            [weakSelf showPlayVCWithPracticeArray:@[modelP] index:0];
        } else {
            [ZProgressHUD showMessage:kGetPracticeing];
            [DataOper getQuerySpeechDetailWithSpeechId:model.hotspot_id userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    
                    NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                    if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                        ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                        
                        [sqlite setLocalPracticeWithModel:modelPractice];
                        
                        [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                    } else {
                        [ZProgressHUD showError:kGetPracticeInfoFail];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    }];
    [self.viewMain setOnDeletePracticeClick:^(ModelCollection *model) {
        [weakSelf setDeletePracticeClick:model];
    }];
    [self.viewMain setOnPageNumChangePractice:^{
        [weakSelf setPageNumPractice:1];
    }];
    ///答案
    [self.viewMain setOnBackgroundAnswerClick:^(ZBackgroundState state) {
        [weakSelf setRefreshAnswerData:YES];
    }];
    [self.viewMain setOnRefreshAnswerHeader:^{
        [weakSelf setRefreshAnswerHeader];
    }];
    [self.viewMain setOnRefreshAnswerFooter:^{
        [weakSelf setRefreshAnswerHeader];
    }];
    [self.viewMain setOnQuestionRowClick:^(ModelCollectionAnswer *model) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.question_id];
        [modelQB setTitle:model.questions];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    [self.viewMain setOnAnswerRowClick:^(ModelCollectionAnswer *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.answer_id];
        [modelAB setQuestion_id:model.question_id];
        [modelAB setTitle:model.content];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    [self.viewMain setOnDeleteAnswerClick:^(ModelCollectionAnswer *model) {
        [weakSelf setDeleteAnswerClick:model];
    }];
    [self.viewMain setOnPageNumChangeAnswer:^{
        [weakSelf setPageNumAnswer:1];
    }];
    [self.view addSubview:self.viewMain];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
    
    [super innerInit];
}

-(void)innerData
{
    NSString *localPracticeKey = [NSString stringWithFormat:@"MyCollectionPracticesKey%@",self.modelUB.userId];
    NSDictionary *dicPracticeLoacl = [sqlite getLocalCacheDataWithPathKay:localPracticeKey];
    BOOL isRefreshPractice = YES;
    if (dicPracticeLoacl && [dicPracticeLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshPractice = NO;
        [self setPracticeViewDataWithDictionary:dicPracticeLoacl isHeader:YES isRefresh:isRefreshPractice];
    }
    [self setRefreshPracticeData:isRefreshPractice];
    
    NSString *localAnswerKey = [NSString stringWithFormat:@"MyCollectionAnswersKey%@",self.modelUB.userId];
    NSDictionary *dicAnswerLoacl = [sqlite getLocalCacheDataWithPathKay:localAnswerKey];
    BOOL isRefresh = YES;
    if (dicAnswerLoacl && [dicAnswerLoacl isKindOfClass:[NSDictionary class]]) {
        isRefresh = NO;
        [self setAnswerViewDataWithDictionary:dicAnswerLoacl isHeader:YES isRefresh:isRefresh];
    }
    [self setRefreshAnswerData:isRefresh];
}

-(void)showPracticeDetailVC:(ModelCollection *)model
{
    ModelPractice *modelP = [sqlite getLocalPracticeModelWithId:model.hotspot_id];
    if (modelP) {
        [self showPlayVCWithPracticeArray:@[modelP] index:0];
    } else {
        ZWEAKSELF
        [ZProgressHUD showMessage:kGetPracticeing];
        [DataOper getQuerySpeechDetailWithSpeechId:model.hotspot_id userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                
                NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                    
                    [sqlite setLocalPracticeWithModel:modelPractice];
                    
                    [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                } else {
                    [ZProgressHUD showError:kGetPracticeInfoFail];
                }
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:msg];
            });
        }];
    }
}

-(void)setDeletePracticeClick:(ModelCollection *)model
{
    [DataOper getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:model.hotspot_id type:model.type resultBlock:nil errorBlock:nil];
}
-(void)setDeleteAnswerClick:(ModelCollectionAnswer *)model
{
    [DataOper getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:model.answer_id type:@"6" resultBlock:nil errorBlock:nil];
}
-(void)setDeleteRankClick:(ModelCollection *)model
{
    [self setDeletePracticeClick:model];
}

-(void)setAnswerViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewAnswerWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyCollectionAnswersKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setRankViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewRankWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyCollectionRanksKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setPracticeViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewPracticeWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyCollectionPracticesKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setRefreshAnswerData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumAnswer = 1;
    if (isRefresh){[weakSelf.viewMain setAnswerBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [DataOper getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setAnswerViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setAnswerBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshAnswerHeader
{
    ZWEAKSELF
    self.pageNumAnswer = 1;
    [DataOper getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAnswerHeader];
            [weakSelf setAnswerViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAnswerHeader];
        });
    }];
}

-(void)setRefreshAnswerFooter
{
    ZWEAKSELF
    self.pageNumAnswer += 1;
    [DataOper getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAnswerFooter];
            [weakSelf setAnswerViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumAnswer -= 1;
            [weakSelf.viewMain endRefreshAnswerFooter];
        });
    }];
}

-(void)setRefreshRankData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumRank = 1;
    if (isRefresh){[weakSelf.viewMain setRankBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [DataOper getMyCollectionWithUserId:self.modelUB.userId type:1 pageNum:self.pageNumRank resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setRankViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setRankBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshRankHeader
{
    ZWEAKSELF
    self.pageNumRank = 1;
    [DataOper getMyCollectionWithUserId:self.modelUB.userId type:1 pageNum:self.pageNumRank resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshRankHeader];
            [weakSelf setRankViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshRankHeader];
        });
    }];
}

-(void)setRefreshRankFooter
{
    ZWEAKSELF
    self.pageNumRank += 1;
    [DataOper getMyCollectionWithUserId:self.modelUB.userId type:1 pageNum:self.pageNumRank resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshRankFooter];
            [weakSelf setRankViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumRank -= 1;
            [weakSelf.viewMain endRefreshRankFooter];
        });
    }];
}
///刷新问题数据
-(void)setRefreshPracticeData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumPractice = 1;
    if (isRefresh){[weakSelf.viewMain setPracticeBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [DataOper getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setPracticeViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setPracticeBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}
///刷新问题顶部数据
-(void)setRefreshPracticeHeader
{
    ZWEAKSELF
    self.pageNumPractice = 1;
    [DataOper getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshPracticeHeader];
            [weakSelf setPracticeViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshPracticeHeader];
        });
    }];
}
///刷新问题底部数据
-(void)setRefreshPracticeFooter
{
    ZWEAKSELF
    self.pageNumPractice += 1;
    [DataOper getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshPracticeFooter];
            [weakSelf setPracticeViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumPractice -= 1;
            [weakSelf.viewMain endRefreshPracticeFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelUser *)model
{
    [self setModelUB:model];
}


@end
