//
//  ZMyCollectionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionViewController.h"
#import "ZMyCollectionView.h"

#import "ZPracticeDetailViewController.h"
#import "ZRankDetailViewController.h"
#import "ZRankUserViewController.h"
#import "ZRankCompanyViewController.h"

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
    self.viewMain = [[ZMyCollectionView alloc] init];
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
        [weakSelf showPracticeDetailVC:model];
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
    ///榜单
    [self.viewMain setOnBackgroundRankClick:^(ZBackgroundState state) {
        [weakSelf setRefreshRankData:YES];
    }];
    [self.viewMain setOnRefreshRankHeader:^{
        [weakSelf setRefreshRankHeader];
    }];
    [self.viewMain setOnRefreshRankFooter:^{
        [weakSelf setRefreshRankFooter];
    }];
    [self.viewMain setOnRankRowClick:^(ModelCollection *model) {
        ///类型  0:律所 1:会计 2证券 3:语音 4:人 5 机构 6回答
        switch ([model.type integerValue]) {
            case WTRankTypeL:
            {
                ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                [modelRC setCompany_name:@"律师事务所"];
                [modelRC setType:[model.type intValue]];
                [weakSelf btnShowDetail:modelRC];
                break;
            }
            case WTRankTypeK:
            {
                ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                [modelRC setCompany_name:@"会计事务所"];
                [modelRC setType:[model.type intValue]];
                [weakSelf btnShowDetail:modelRC];
                break;
            }
            case WTRankTypeZ:
            {
                ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                [modelRC setCompany_name:@"证券公司"];
                [modelRC setType:[model.type intValue]];
                [weakSelf btnShowDetail:modelRC];
                break;
            }
            case WTRankTypeU:
            {
                ModelRankUser *modelRU = [[ModelRankUser alloc] init];
                [modelRU setIds:model.hotspot_id];
                [modelRU setType:[model.type intValue]];
                [modelRU setIsAtt:YES];
                [modelRU setNickname:model.title];
                [modelRU setOperator_img:model.img];
                [weakSelf btnShowUser:modelRU];
                break;
            }
            case WTRankTypeO:
            {
                ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
                [modelRC setIds:model.hotspot_id];
                [modelRC setCompany_img:model.img];
                [modelRC setCompany_name:model.title];
                [modelRC setIsAtt:YES];
                [modelRC setType:[model.type intValue]];
                [weakSelf btnShowCompany:modelRC];
                break;
            }
            default: break;
        }
    }];
    [self.viewMain setOnDeleteRankClick:^(ModelCollection *model) {
        [weakSelf setDeleteRankClick:model];
    }];
    [self.viewMain setOnPageNumChangeRank:^{
        [weakSelf setPageNumRank:1];
    }];
    [self.view addSubview:self.viewMain];
    
    [self setViewFrame];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_ITEM_FRAME];
}
-(void)btnShowCompany:(ModelRankCompany *)model
{
    ZRankCompanyViewController *itemVC = [[ZRankCompanyViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnShowDetail:(ModelRankCompany *)model
{
    ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnShowUser:(ModelRankUser *)model
{
    ZRankUserViewController *itemVC = [[ZRankUserViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
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
    
    NSString *localRankKey = [NSString stringWithFormat:@"MyCollectionRanksKey%@",self.modelUB.userId];
    NSDictionary *dicRankLoacl = [sqlite getLocalCacheDataWithPathKay:localRankKey];
    BOOL isRefreshRank = YES;
    if (dicRankLoacl && [dicRankLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshRank = NO;
        [self setRankViewDataWithDictionary:dicRankLoacl isHeader:YES isRefresh:isRefreshRank];
    }
    [self setRefreshRankData:isRefreshRank];
}

-(void)showPracticeDetailVC:(ModelCollection *)model
{
    ModelPractice *modelP = [sqlite getLocalPracticeModelWithId:model.hotspot_id];
    if (modelP) {
        ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:modelP];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        ZWEAKSELF
        [ZProgressHUD showMessage:@"获取语音,请稍等..."];
        [sns getQuerySpeechDetailWithSpeechId:model.hotspot_id userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                
                NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dicReuslt];
                    
                    [sqlite setLocalPracticeWithModel:modelP];
                    
                    ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
                    [itemVC setViewDataWithModel:modelP];
                    [itemVC setHidesBottomBarWhenPushed:YES];
                    [weakSelf.navigationController pushViewController:itemVC animated:YES];
                } else {
                    [ZProgressHUD showError:@"获取语音信息失败"];
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
    [sns getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:model.hotspot_id type:model.type resultBlock:nil errorBlock:nil];
}
-(void)setDeleteAnswerClick:(ModelCollectionAnswer *)model
{
    [sns getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:model.answer_id type:@"6" resultBlock:nil errorBlock:nil];
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
    [sns getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [sns getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [sns getMyCollectionAnswerWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAnswerFooter];
            [weakSelf setAnswerViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAnswerFooter];
        });
    }];
}

-(void)setRefreshRankData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumRank = 1;
    if (isRefresh){[weakSelf.viewMain setRankBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getMyCollectionWithUserId:self.modelUB.userId type:1 pageNum:self.pageNumRank resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [sns getMyCollectionWithUserId:self.modelUB.userId type:1 pageNum:self.pageNumRank resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [sns getMyCollectionWithUserId:self.modelUB.userId type:1 pageNum:self.pageNumRank resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshRankFooter];
            [weakSelf setRankViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
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
    [sns getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [sns getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [sns getMyCollectionWithUserId:self.modelUB.userId type:2 pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
