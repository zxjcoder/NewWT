//
//  ZMyAnswerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerViewController.h"
#import "ZMyAnswerView.h"

@interface ZMyAnswerViewController ()

@property (strong, nonatomic) ZMyAnswerView *viewMain;

@property (assign, nonatomic) int pageNumAnswer;

@property (assign, nonatomic) int pageNumComment;

@property (assign, nonatomic) BOOL isLoadUser;

@property (strong, nonatomic) ModelUserBase *modelUB;

@end

@implementation ZMyAnswerViewController

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
    self.viewMain = [[ZMyAnswerView alloc] init];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
    
    ///我的答案背景点击
    [self.viewMain setOnBackgroundAnswerClick:^(ZBackgroundState state) {
        [weakSelf setRefreshAnswerData:YES];
    }];
    ///我的答案刷新顶部
    [self.viewMain setOnRefreshAnswerHeader:^{
        [weakSelf setRefreshAnswerHeader];
    }];
    ///我的答案刷新底部
    [self.viewMain setOnRefreshAnswerFooter:^{
        [weakSelf setRefreshAnswerHeader];
    }];
    ///我的答案行选择
    [self.viewMain setOnAnswerRowClick:^(ModelQuestionMyAnswer *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setTitle:model.content];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    ///我的答案->问题选中
    [self.viewMain setOnQuestionRowClick:^(ModelQuestionMyAnswer *model) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    ///我的答案删除
    [self.viewMain setOnDeleteAnswerClick:^(ModelQuestionMyAnswer *model) {
        [weakSelf setDeleteAnswerClick:model];
    }];
    ///所有设置分页数量
    [self.viewMain setOnAnswerPageNumChange:^(int pageNum) {
        [weakSelf setPageNumAnswer:pageNum];
    }];
    
    ///收到的评论背景点击
    [self.viewMain setOnBackgroundCommentClick:^(ZBackgroundState state) {
        [weakSelf setRefreshCommentData:YES];
    }];
    ///收到的评论刷新顶部
    [self.viewMain setOnRefreshCommentHeader:^{
        [weakSelf setRefreshCommentHeader];
    }];
    ///收到的评论刷新底部
    [self.viewMain setOnRefreshCommentFooter:^{
        [weakSelf setRefreshCommentFooter];
    }];
    ///收到的评论行选择
    [self.viewMain setOnCommentRowClick:^(ModelQuestionMyAnswerComment *model) {
        [weakSelf setIsLoadUser:YES];
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.qid];
        [modelAB setTitle:model.acontent];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    ///收到的评论头像选中
    [self.viewMain setOnPhotoClick:^(ModelQuestionMyAnswerComment *model) {
        if (![Utils isMyUserId:model.userid]) {
            [weakSelf setIsLoadUser:YES];
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userid];
            [modelUB setNickname:model.nickname];
            [modelUB setHead_img:model.head_img];
            [weakSelf showUserProfileVC:modelUB];
        }
    }];
    ///收到的评论删除
    [self.viewMain setOnDeleteCommentClick:^(ModelQuestionMyAnswerComment *model) {
        [weakSelf setDeleteCommentClick:model];
    }];
    ///收到的评论设置分页数量
    [self.viewMain setOnCommentPageNumChange:^(int pageNum) {
        [weakSelf setPageNumComment:pageNum];
    }];
    [self.view addSubview:self.viewMain];
    
    if ([[AppSetting getUserId] isEqualToString:self.modelUB.userId]) {
        [self.viewMain setCommentCount:[AppSetting getUserLogin].myAnswerCommentcount];
    } else {
        [self.viewMain setCommentCount:0];
    }
    
    [self setViewFrame];
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_ITEM_FRAME];
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
                    
                    [weakSelf.viewMain setCommentCount:resultModel.myAnswerCommentcount];
                }
            });
        } errorBlock:nil];
    }
}

-(void)innerData
{
    NSString *localAnswerKey = [NSString stringWithFormat:@"MyAnswerAnswerKey%@",self.modelUB.userId];
    NSDictionary *dicAnswerLoacl = [sqlite getLocalCacheDataWithPathKay:localAnswerKey];
    BOOL isRefresh = YES;
    if (dicAnswerLoacl && [dicAnswerLoacl isKindOfClass:[NSDictionary class]]) {
        isRefresh = NO;
        [self setAnswerViewDataWithDictionary:dicAnswerLoacl isHeader:YES isRefresh:isRefresh];
    }
    [self setRefreshAnswerData:isRefresh];
    
    NSString *localCommentKey = [NSString stringWithFormat:@"MyAnswerCommentKey%@",self.modelUB.userId];
    NSDictionary *dicCommentLoacl = [sqlite getLocalCacheDataWithPathKay:localCommentKey];
    BOOL isRefreshComment = YES;
    if (dicCommentLoacl && [dicCommentLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshComment = NO;
        [self setCommentViewDataWithDictionary:dicCommentLoacl isHeader:YES isRefresh:isRefreshComment];
    }
    [self setRefreshCommentData:isRefreshComment];
}

-(void)setDeleteAnswerClick:(ModelQuestionMyAnswer *)model
{
    [sns postDeleteAnswerWithAnswerId:model.aid userId:[AppSetting getUserDetauleId] resultBlock:nil errorBlock:nil];
}

-(void)setDeleteCommentClick:(ModelQuestionMyAnswerComment *)model
{
    [sns postDeleteAnswerCommentWithCommentId:model.ids resultBlock:nil errorBlock:nil];
}

-(void)setAnswerViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewAnswerWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyAnswerAnswerKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setCommentViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewCommentWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyAnswerCommentKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}

-(void)setRefreshAnswerData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumAnswer = 1;
    if (isRefresh){[weakSelf.viewMain setAnswerBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain setAnswerBackgroundViewWithState:(ZBackgroundStateNone)];
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
    [sns postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSDictionary *result) {
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
    [sns postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSDictionary *result) {
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

-(void)setRefreshCommentData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumComment = 1;
    if (isRefresh){[weakSelf.viewMain setCommentBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getMyAnswerCommentWithUserId:self.modelUB.userId pageNum:self.pageNumComment resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain setCommentBackgroundViewWithState:(ZBackgroundStateNone)];
            [weakSelf setCommentViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.viewMain setCommentBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshCommentHeader
{
    ZWEAKSELF
    self.pageNumComment = 1;
    [sns getMyAnswerCommentWithUserId:self.modelUB.userId pageNum:self.pageNumComment resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshCommentHeader];
            [weakSelf setCommentViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshCommentHeader];
        });
    }];
}

-(void)setRefreshCommentFooter
{
    ZWEAKSELF
    self.pageNumComment += 1;
    [sns getMyAnswerCommentWithUserId:self.modelUB.userId pageNum:self.pageNumComment resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshCommentFooter];
            [weakSelf setCommentViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshCommentFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

@end
