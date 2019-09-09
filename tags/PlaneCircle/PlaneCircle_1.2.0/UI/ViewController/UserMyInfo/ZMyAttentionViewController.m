//
//  ZMyAttentionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAttentionViewController.h"
#import "ZMyAttentionView.h"

#import "ZTopicListViewController.h"

@interface ZMyAttentionViewController ()

///用户选中行
@property (assign, nonatomic) NSInteger userRow;
///选中用户是否关注
@property (assign, nonatomic) BOOL isUserAtt;
///主视图
@property (strong, nonatomic) ZMyAttentionView *viewMain;

@property (assign, nonatomic) int pageNumQuestion;

@property (assign, nonatomic) int pageNumTopic;

@property (assign, nonatomic) int pageNumUser;

@property (strong, nonatomic) ModelUserBase *modelUB;

@end

@implementation ZMyAttentionViewController

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
    
    if (!self.isUserAtt && self.userRow >= 0) {
        [self.viewMain setDeleteUserWithRow:self.userRow];
    } else if (self.isUserAtt && self.userRow == -1) {
        [self setRefreshUserData];
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
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_modelUB);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.userRow = -2;
    ZWEAKSELF
    self.viewMain = [[ZMyAttentionView alloc] init];
    ///问题
    [self.viewMain setOnBackgroundQuestionClick:^(ZBackgroundState state) {
        [weakSelf setRefreshQuestionData:YES];
    }];
    [self.viewMain setOnRefreshQuestionHeader:^{
        [weakSelf setRefreshQuestionHeader];
    }];
    [self.viewMain setOnRefreshQuestionFooter:^{
        [weakSelf setRefreshQuestionHeader];
    }];
    [self.viewMain setOnPhotoClick:^(ModelAttentionQuestion *model) {
        if (![Utils isMyUserId:model.userIdQ]) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userIdQ];
            [modelUB setNickname:model.nicknameQ];
            [modelUB setHead_img:model.head_imgQ];
            [weakSelf setUserRow:-1];
            [weakSelf showUserProfileVC:modelUB preVC:weakSelf];
        }
    }];
    [self.viewMain setOnQuestionRowClick:^(ModelAttentionQuestion *model) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    [self.viewMain setOnAnswerRowClick:^(ModelAttentionQuestion *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.answerContent];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    [self.viewMain setOnDeleteQuestionClick:^(ModelAttentionQuestion *model) {
        [weakSelf setDeleteQuestionClick:model];
    }];
    [self.viewMain setOnPageNumChangeQuestion:^{
        [weakSelf setPageNumQuestion:1];
    }];
    ///话题
    [self.viewMain setOnBackgroundTopicClick:^(ZBackgroundState state) {
        [weakSelf setRefreshTopicData:YES];
    }];
    [self.viewMain setOnRefreshTopicHeader:^{
        [weakSelf setRefreshTopicHeader];
    }];
    [self.viewMain setOnRefreshTopicFooter:^{
        [weakSelf setRefreshTopicHeader];
    }];
    [self.viewMain setOnTagRowClick:^(ModelTag *model) {
        [weakSelf showTopicVCWithModel:model];
    }];
    [self.viewMain setOnDeleteTopicClick:^(ModelTag *model) {
        [weakSelf setDeleteTopicClick:model];
    }];
    [self.viewMain setOnPageNumChangeTopic:^{
        [weakSelf setPageNumTopic:1];
    }];
    ///用户
    [self.viewMain setOnBackgroundUserClick:^(ZBackgroundState state) {
        [weakSelf setRefreshUserData:YES];
    }];
    [self.viewMain setOnRefreshUserHeader:^{
        [weakSelf setRefreshUserHeader];
    }];
    [self.viewMain setOnRefreshUserFooter:^{
        [weakSelf setRefreshUserFooter];
    }];
    [self.viewMain setOnUserRowClick:^(ModelUserBase *model, NSInteger row) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf setUserRow:row];
            [weakSelf setIsUserAtt:YES];
            [weakSelf showUserProfileVC:model preVC:weakSelf];
        }
    }];
    [self.viewMain setOnDeleteUserClick:^(ModelUserBase *model) {
        [weakSelf setDeleteUserClick:model];
    }];
    [self.viewMain setOnPageNumChangeUser:^{
        [weakSelf setPageNumUser:1];
    }];
    [self.view addSubview:self.viewMain];
    
    [self setViewFrame];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
}

-(void)setDeleteUserWithRow:(NSNumber *)row
{
    [self setIsUserAtt:[row boolValue]];
}

-(void)setRefreshUserData
{
    if (self.pageNumUser == 1) {
        ZWEAKSELF
        self.pageNumUser = 1;
        [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:1 pageNum:self.pageNumUser resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setUserViewDataWithDictionary:result isHeader:YES isRefresh:NO];
            });
        } errorBlock:nil];
    }
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_ITEM_FRAME];
}

-(void)innerData
{
    NSString *localQuestionKey = [NSString stringWithFormat:@"MyAttentQuestionsKey%@",self.modelUB.userId];
    NSDictionary *dicQuestionLoacl = [sqlite getLocalCacheDataWithPathKay:localQuestionKey];
    BOOL isRefreshQuestion = YES;
    if (dicQuestionLoacl && [dicQuestionLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshQuestion = NO;
        [self setQuestionViewDataWithDictionary:dicQuestionLoacl isHeader:YES isRefresh:isRefreshQuestion];
    }
    [self setRefreshQuestionData:isRefreshQuestion];
    
    NSString *localTopicKey = [NSString stringWithFormat:@"MyAttentArticlesKey%@",self.modelUB.userId];
    NSDictionary *dicTopicLoacl = [sqlite getLocalCacheDataWithPathKay:localTopicKey];
    BOOL isRefresh = YES;
    if (dicTopicLoacl && [dicTopicLoacl isKindOfClass:[NSDictionary class]]) {
        isRefresh = NO;
        [self setTopicViewDataWithDictionary:dicTopicLoacl isHeader:YES isRefresh:isRefresh];
    }
    [self setRefreshTopicData:isRefresh];
    
    NSString *localUserKey = [NSString stringWithFormat:@"MyAttentUsersKey%@",self.modelUB.userId];
    NSDictionary *dicUserLoacl = [sqlite getLocalCacheDataWithPathKay:localUserKey];
    BOOL isRefreshUser = YES;
    if (dicUserLoacl && [dicUserLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshUser = NO;
        [self setUserViewDataWithDictionary:dicUserLoacl isHeader:YES isRefresh:isRefreshUser];
    }
    [self setRefreshUserData:isRefreshUser];
}

-(void)showTopicVCWithModel:(ModelTag *)model
{
    ZTopicListViewController *itemVC = [[ZTopicListViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)setDeleteQuestionClick:(ModelAttentionQuestion *)model
{
    [sns postDeleteAttentionWithAId:model.ids userId:[AppSetting getUserDetauleId] type:@"0" resultBlock:nil errorBlock:nil];
}
-(void)setDeleteTopicClick:(ModelTag *)model
{
    [sns postDeleteAttentionWithAId:model.tagId userId:[AppSetting getUserDetauleId] type:@"3" resultBlock:nil errorBlock:nil];
}
-(void)setDeleteUserClick:(ModelUserBase *)model
{
    [sns postDeleteAttentionWithAId:model.userId userId:[AppSetting getUserDetauleId] type:@"1" resultBlock:nil errorBlock:nil];
}

-(void)setTopicViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewTopicWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyAttentArticlesKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setUserViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewUserWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyAttentUsersKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setQuestionViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewQuestionWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyAttentQuestionsKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setRefreshTopicData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumTopic = 1;
    if (isRefresh){[weakSelf.viewMain setTopicBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:2 pageNum:self.pageNumTopic resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setTopicViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setTopicBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshTopicHeader
{
    ZWEAKSELF
    self.pageNumTopic = 1;
    [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:2 pageNum:self.pageNumTopic resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshTopicHeader];
            [weakSelf setTopicViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshTopicHeader];
        });
    }];
}

-(void)setRefreshTopicFooter
{
    ZWEAKSELF
    self.pageNumTopic += 1;
    [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:2 pageNum:self.pageNumTopic resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshTopicFooter];
            [weakSelf setTopicViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshTopicFooter];
        });
    }];
}

-(void)setRefreshUserData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumUser = 1;
    if (isRefresh){[weakSelf.viewMain setUserBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:1 pageNum:self.pageNumUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setUserViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setUserBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshUserHeader
{
    ZWEAKSELF
    self.pageNumUser = 1;
    [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:1 pageNum:self.pageNumUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshUserHeader];
            [weakSelf setUserViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshUserHeader];
        });
    }];
}

-(void)setRefreshUserFooter
{
    ZWEAKSELF
    self.pageNumUser += 1;
    [sns postMyGetAttentionWithUserId:self.modelUB.userId flag:1 pageNum:self.pageNumUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshUserFooter];
            [weakSelf setUserViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshUserFooter];
        });
    }];
}
///刷新问题数据
-(void)setRefreshQuestionData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumQuestion = 1;
    if (isRefresh){[weakSelf.viewMain setTopicBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getCircleAttentionListWithUserId:self.modelUB.userId pageNum:self.pageNumQuestion resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setQuestionViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setQuestionBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}
///刷新问题顶部数据
-(void)setRefreshQuestionHeader
{
    ZWEAKSELF
    self.pageNumQuestion = 1;
    [sns getCircleAttentionListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumQuestion resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshQuestionHeader];
            [weakSelf setQuestionViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshQuestionHeader];
        });
    }];
}
///刷新问题底部数据
-(void)setRefreshQuestionFooter
{
    ZWEAKSELF
    self.pageNumQuestion += 1;
    [sns getCircleAttentionListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumQuestion resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshQuestionFooter];
            [weakSelf setQuestionViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumQuestion -= 1;
            [weakSelf.viewMain endRefreshQuestionFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

@end
