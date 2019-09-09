//
//  ZMyQuestionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyQuestionViewController.h"
#import "ZMyQuestionView.h"

@interface ZMyQuestionViewController ()

@property (strong, nonatomic) ZMyQuestionView *viewMain;

@property (assign, nonatomic) int pageNumAll;

@property (assign, nonatomic) BOOL isLoadUser;

@property (assign, nonatomic) int pageNumNew;

@property (strong, nonatomic) ModelUserBase *modelUB;

@end

@implementation ZMyQuestionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    [self innerData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadUserInfoData];
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
    self.viewMain = [[ZMyQuestionView alloc] init];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
    
    ///所有问题背景点击
    [self.viewMain setOnBackgroundAllClick:^(ZBackgroundState state) {
        [weakSelf setRefreshAllData:YES];
    }];
    ///所有问题刷新顶部
    [self.viewMain setOnRefreshAllHeader:^{
        [weakSelf setRefreshAllHeader];
    }];
    ///所有问题刷新底部
    [self.viewMain setOnRefreshAllFooter:^{
        [weakSelf setRefreshAllHeader];
    }];
    ///所有问题行选择
    [self.viewMain setOnAllRowClick:^(ModelMyAllQuestion *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    ///所有问题删除
    [self.viewMain setOnDeleteAllClick:^(ModelMyAllQuestion *model) {
        [weakSelf setDeleteAllClick:model];
    }];
    ///所有设置分页数量
    [self.viewMain setOnAllPageNumChange:^(int pageNum) {
        [weakSelf setPageNumAll:pageNum];
    }];
    
    ///新答案背景点击
    [self.viewMain setOnBackgroundNewClick:^(ZBackgroundState state) {
        [weakSelf loadUserInfoData];
        [weakSelf setRefreshNewData:YES];
    }];
    ///新答案刷新顶部
    [self.viewMain setOnRefreshNewHeader:^{
        [weakSelf loadUserInfoData];
        [weakSelf setRefreshNewHeader];
    }];
    ///新答案刷新底部
    [self.viewMain setOnRefreshNewFooter:^{
        [weakSelf loadUserInfoData];
        [weakSelf setRefreshNewFooter];
    }];
    ///新答案行选择
    [self.viewMain setOnNewRowClick:^(ModelMyNewQuestion *model) {
        [weakSelf setIsLoadUser:YES];
        [weakSelf showQuestionDetailVC:model];
    }];
    ///新答案头像点击
    [self.viewMain setOnNewPhotoClick:^(ModelMyNewQuestion *model) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf setIsLoadUser:YES];
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userId];
            [modelUB setNickname:model.nickname];
            [modelUB setHead_img:model.head_img];
            [weakSelf showUserProfileVC:modelUB];
        }
    }];
    ///新答案回答内容点击
    [self.viewMain setOnNewAnswerClick:^(ModelMyNewQuestion *model) {
        [weakSelf setIsLoadUser:YES];
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setTitle:model.aContent];
        [modelAB setQuestion_id:model.ids];
        [modelAB setQuestion_title:model.title];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    ///新答案删除
    [self.viewMain setOnDeleteNewClick:^(ModelMyNewQuestion *model) {
        [weakSelf setDeleteNewClick:model];
    }];
    ///新答案设置分页数量
    [self.viewMain setOnNewPageNumChange:^(int pageNum) {
        [weakSelf setPageNumNew:pageNum];
    }];
    [self.view addSubview:self.viewMain];
    
    if ([[AppSetting getUserId] isEqualToString:self.modelUB.userId]) {
        [self.viewMain setNewQuestionCount:[AppSetting getUserLogin].myQuesNewCount];
    } else {
        [self.viewMain setNewQuestionCount:0];
    }
    
    [self setViewFrame];
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_ITEM_FRAME];
}

-(void)innerData
{
    NSString *localAllKey = [NSString stringWithFormat:@"MyQuestionAllKey%@",self.modelUB.userId];
    NSDictionary *dicAllLoacl = [sqlite getLocalCacheDataWithPathKay:localAllKey];
    BOOL isRefresh = YES;
    if (dicAllLoacl && [dicAllLoacl isKindOfClass:[NSDictionary class]]) {
        isRefresh = NO;
        [self setAllViewDataWithDictionary:dicAllLoacl isHeader:YES isRefresh:isRefresh];
    }
    [self setRefreshAllData:isRefresh];
    
    NSString *localNewKey = [NSString stringWithFormat:@"MyQuestionNewKey%@",self.modelUB.userId];
    NSDictionary *dicNewLoacl = [sqlite getLocalCacheDataWithPathKay:localNewKey];
    BOOL isRefreshNew = YES;
    if (dicNewLoacl && [dicNewLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshNew = NO;
        [self setNewViewDataWithDictionary:dicNewLoacl isHeader:YES isRefresh:isRefreshNew];
    }
    [self setRefreshNewData:isRefreshNew];
}

-(void)loadUserInfoData
{
    if (self.isLoadUser && [[AppSetting getUserId] isEqualToString:self.modelUB.userId]) {
        self.isLoadUser = NO;
        ZWEAKSELF
        [sns postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                if (resultModel) {
                    [AppSetting setUserLogin:resultModel];
                    [AppSetting save];
                    
                    [weakSelf.viewMain setNewQuestionCount:resultModel.myQuesNewCount];
                }
            });
        } errorBlock:nil];
    }
}

-(void)setDeleteAllClick:(ModelMyAllQuestion *)model
{
    ZWEAKSELF
    [sns postDeleteQuestionWithUserId:[AppSetting getUserDetauleId] questionId:model.ids resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf postPublishQuestionNotification];
        });
    } errorBlock:nil];
}

-(void)setDeleteNewClick:(ModelMyNewQuestion *)model
{
    [sns postDeleteQuestionWithQuestionId:model.ids resultBlock:nil errorBlock:nil];
}

-(void)setAllViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewAllWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyQuestionAllKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setNewViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewNewWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyQuestionNewKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setRefreshAllData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumAll = 1;
    if (isRefresh){[weakSelf.viewMain setAllBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetQueryQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumAll resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain setAllBackgroundViewWithState:(ZBackgroundStateNone)];
            [weakSelf setAllViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setAllBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshAllHeader
{
    ZWEAKSELF
    self.pageNumAll = 1;
    [sns postMyGetQueryQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumAll resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAllHeader];
            [weakSelf setAllViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAllHeader];
        });
    }];
}

-(void)setRefreshAllFooter
{
    ZWEAKSELF
    self.pageNumAll += 1;
    [sns postMyGetQueryQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumAll resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAllFooter];
            [weakSelf setAllViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAllFooter];
        });
    }];
}

-(void)setRefreshNewData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumNew = 1;
    if (isRefresh){[weakSelf.viewMain setNewBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetUpdQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain setNewBackgroundViewWithState:(ZBackgroundStateNone)];
            [weakSelf setNewViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setNewBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshNewHeader
{
    ZWEAKSELF
    self.pageNumNew = 1;
    [sns postMyGetUpdQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshNewHeader];
            [weakSelf setNewViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshNewHeader];
        });
    }];
}

-(void)setRefreshNewFooter
{
    ZWEAKSELF
    self.pageNumNew += 1;
    [sns postMyGetUpdQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshNewFooter];
            [weakSelf setNewViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshNewFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

@end
