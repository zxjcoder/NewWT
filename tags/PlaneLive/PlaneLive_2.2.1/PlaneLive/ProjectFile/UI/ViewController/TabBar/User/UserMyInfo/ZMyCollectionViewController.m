//
//  ZMyCollectionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionViewController.h"
#import "ZMyCollectionView.h"
#import "ZWebContentViewController.h"

@interface ZMyCollectionViewController ()

@property (strong, nonatomic) ZMyCollectionView *viewMain;

@property (strong, nonatomic) ModelUser *modelUB;

@property (assign, nonatomic) int pageNumPractice;
@property (assign, nonatomic) int pageNumAnswer;
@property (assign, nonatomic) int pageNumSubscribe;

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
        [weakSelf setRefreshPracticeFooter];
    }];
    [self.viewMain setOnPracticeRowClick:^(ModelCollection *model) {
        ModelPractice *modelP = [sqlite getLocalPlayPracticeDetailModelWithId:model.hotspot_id userId:kLoginUserId];
        if (modelP) {
            [weakSelf showPlayVCWithPracticeArray:@[modelP] index:0];
        } else {
            [ZProgressHUD showMessage:kCMsgGeting];
            [snsV1 getQuerySpeechDetailWithSpeechId:model.hotspot_id userId:kLoginUserId resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    
                    NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                    if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                        ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                        
                        [sqlite setLocalPlayPracticeDetailWithModel:modelPractice userId:kLoginUserId];
                        
                        [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                    } else {
                        [ZProgressHUD showError:kGetInfoFail];
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
        [weakSelf setRefreshAnswerFooter];
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
    
    ///订阅
    [self.viewMain setOnBackgroundSubscribeClick:^(ZBackgroundState state) {
        [weakSelf setRefreshSubscribeData:YES];
    }];
    [self.viewMain setOnRefreshSubscribeHeader:^{
        [weakSelf setRefreshSubscribeHeader];
    }];
    [self.viewMain setOnRefreshSubscribeFooter:^{
        [weakSelf setRefreshSubscribeFooter];
    }];
    [self.viewMain setOnSubscribeRowClick:^(ModelCollection *model) {
        [weakSelf setShowSubscribeVC:model];
    }];
    [self.viewMain setOnDeleteSubscribeClick:^(ModelCollection *model) {
        [weakSelf setDeleteSubscribeClick:model];
    }];
    [self.viewMain setOnPageNumChangeSubscribe:^{
        [weakSelf setPageNumSubscribe:1];
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
    BOOL isRefreshAnswer = YES;
    if (dicAnswerLoacl && [dicAnswerLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshAnswer = NO;
        [self setAnswerViewDataWithDictionary:dicAnswerLoacl isHeader:YES isRefresh:isRefreshAnswer];
    }
    [self setRefreshAnswerData:isRefreshAnswer];
    
    NSString *localSubscribeKey = [NSString stringWithFormat:@"MyCollectionSubscribesKey%@",self.modelUB.userId];
    NSDictionary *dicSubscribeLoacl = [sqlite getLocalCacheDataWithPathKay:localSubscribeKey];
    BOOL isRefreshSubscribe = YES;
    if (dicSubscribeLoacl && [dicSubscribeLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshSubscribe = NO;
        [self setSubscribeViewDataWithDictionary:dicSubscribeLoacl isHeader:YES isRefresh:isRefreshSubscribe];
    }
    [self setRefreshSubscribeData:isRefreshSubscribe];
}
-(void)setShowSubscribeVC:(ModelCollection *)model
{
    if (model.free_read == 0) {
        ModelCurriculum *modelC = [sqlite getLocalPlayCurriculumDetailWithUserId:kLoginUserId ids:model.hotspot_id];
        if (modelC && modelC.ids.length > 0) {
            ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
            [itemVC setViewDataWithModel:modelC isCourse:NO];
            [self.navigationController pushViewController:itemVC animated:YES];
        } else {
            ZWEAKSELF
            [ZProgressHUD showMessage:kCMsgGeting];
            [snsV2 getCurriculumDetailWithCurriculumId:model.hotspot_id resultBlock:^(ModelCurriculum *resultModel, NSDictionary *result) {
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
    } else {
        ModelCurriculum *modelC = [sqlite getLocalPlayCurriculumDetailWithUserId:kLoginUserId ids:model.hotspot_id];
        if (modelC && modelC.ids.length > 0) {
            ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
            [itemVC setViewDataWithModel:modelC isCourse:NO];
            [self.navigationController pushViewController:itemVC animated:YES];
        } else {
            ZWEAKSELF
            [ZProgressHUD showMessage:kCMsgGeting];
            [snsV2 getCurriculumDetailWithCurriculumId:model.hotspot_id resultBlock:^(ModelCurriculum *resultModel, NSDictionary *result) {
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
}
-(void)showPracticeDetailVC:(ModelCollection *)model
{
    ModelPractice *modelP = [sqlite getLocalPlayPracticeDetailModelWithId:model.hotspot_id userId:kLoginUserId];
    if (modelP) {
        [self showPlayVCWithPracticeArray:@[modelP] index:0];
    } else {
        ZWEAKSELF
        [ZProgressHUD showMessage:kCMsgGeting];
        [snsV1 getQuerySpeechDetailWithSpeechId:model.hotspot_id userId:kLoginUserId resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                
                NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                    
                    [sqlite setLocalPlayPracticeDetailWithModel:modelPractice userId:kLoginUserId];
                    
                    [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                } else {
                    [ZProgressHUD showError:kGetInfoFail];
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
    [snsV1 getDelCollectionWithUserId:kLoginUserId cid:model.hotspot_id type:model.type resultBlock:nil errorBlock:nil];
}
-(void)setDeleteAnswerClick:(ModelCollectionAnswer *)model
{
    [snsV1 getDelCollectionWithUserId:kLoginUserId cid:model.answer_id type:@"6" resultBlock:nil errorBlock:nil];
}
-(void)setDeleteSubscribeClick:(ModelCollection *)model
{
    [snsV1 getDelCollectionWithUserId:kLoginUserId cid:model.hotspot_id type:@"7" resultBlock:nil errorBlock:nil];
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

-(void)setSubscribeViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewSubscribeWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyCollectionSubscribesKey%@",self.modelUB.userId];
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
    [snsV1 getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [snsV1 getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [snsV1 getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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

-(void)setRefreshSubscribeData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumSubscribe = 1;
    if (isRefresh){[weakSelf.viewMain setSubscribeBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV2 getMyCollectionWithUserId:self.modelUB.userId pageNum:self.pageNumSubscribe resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf setSubscribeViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
    } errorBlock:^(NSString *msg) {
        if (isRefresh) {
            [weakSelf.viewMain setSubscribeBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }];
}

-(void)setRefreshSubscribeHeader
{
    ZWEAKSELF
    self.pageNumSubscribe = 1;
    [snsV2 getMyCollectionWithUserId:self.modelUB.userId pageNum:self.pageNumSubscribe resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf.viewMain endRefreshSubscribeHeader];
        [weakSelf setSubscribeViewDataWithDictionary:result isHeader:YES isRefresh:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshSubscribeHeader];
    }];
}

-(void)setRefreshSubscribeFooter
{
    ZWEAKSELF
    [snsV2 getMyCollectionWithUserId:self.modelUB.userId pageNum:self.pageNumSubscribe+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSubscribe += 1;
        [weakSelf.viewMain endRefreshSubscribeFooter];
        [weakSelf setSubscribeViewDataWithDictionary:result isHeader:NO isRefresh:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshSubscribeFooter];
    }];
}
///刷新问题数据
-(void)setRefreshPracticeData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumPractice = 1;
    if (isRefresh){[weakSelf.viewMain setPracticeBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV1 getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [snsV1 getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [snsV1 getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
