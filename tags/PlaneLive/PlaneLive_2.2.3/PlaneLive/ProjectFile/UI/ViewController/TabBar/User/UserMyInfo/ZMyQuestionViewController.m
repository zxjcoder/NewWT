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
{
    __block BOOL _isLoadNewData;
    BOOL _isRefreshNewData;
}
@property (strong, nonatomic) ZMyQuestionView *viewMain;

@property (assign, nonatomic) int pageNumAll;

@property (assign, nonatomic) BOOL isLoadUser;

@property (assign, nonatomic) int pageNumNew;

@property (strong, nonatomic) ModelUserBase *modelUB;

@property (strong, nonatomic) ModelUserProfile *modelUP;

@end

@implementation ZMyQuestionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
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
    self.viewMain = [[ZMyQuestionView alloc] initWithFrame:VIEW_ITEM_FRAME];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
    if ([Utils isMyUserId:self.modelUB.userId]) {
        [self.viewMain setViewNickNameDescType:0];
    } else {
        switch (self.modelUP.sex) {
            case WTSexTypeFeMale:
                [self.viewMain setViewNickNameDescType:2];
                break;
            default:
                [self.viewMain setViewNickNameDescType:1];
                break;
        }
    }
    NSString *localNewKey = [NSString stringWithFormat:@"MyQuestionNewKey%@",self.modelUB.userId];
    ///顶部切换
    [self.viewMain setOnSwitchToolChange:^(NSInteger itemIndex) {
        if (itemIndex == 1 && _isLoadNewData == NO) {
            _isLoadNewData = YES;
            NSDictionary *dicNewLoacl = [sqlite getLocalCacheDataWithPathKay:localNewKey];
            BOOL isRefreshNew = YES;
            if (dicNewLoacl && [dicNewLoacl isKindOfClass:[NSDictionary class]]) {
                isRefreshNew = NO;
                [weakSelf setNewViewDataWithDictionary:dicNewLoacl isHeader:YES isRefresh:isRefreshNew];
            }
            [weakSelf setRefreshNewData:isRefreshNew];
        }
    }];
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
        [weakSelf setRefreshAllFooter];
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
    [self.viewMain setOnNewRowClick:^(ModelQuestionBase *model) {
        [weakSelf setIsLoadUser:YES];
        [weakSelf showQuestionDetailVC:model];
    }];
    ///新答案头像点击
    [self.viewMain setOnNewPhotoClick:^(ModelUserBase *model) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    ///新答案回答内容点击
    [self.viewMain setOnNewAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf setIsLoadUser:YES];
        [weakSelf showAnswerDetailVC:model];
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
    
    if ([Utils isMyUserId:self.modelUB.userId]) {
        [self.viewMain setNewQuestionCount:[AppSetting getUserLogin].myQuesNewCount];
    } else {
        [self.viewMain setNewQuestionCount:0];
    }
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{
    NSString *localAllKey = [NSString stringWithFormat:@"MyQuestionAllKey%@",self.modelUB.userId];
    NSDictionary *dicAllLoacl = [sqlite getLocalCacheDataWithPathKay:localAllKey];
    BOOL isRefreshAll = YES;
    if (dicAllLoacl && [dicAllLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshAll = NO;
        [self setAllViewDataWithDictionary:dicAllLoacl isHeader:YES isRefresh:isRefreshAll];
    }
    [self setRefreshAllData:isRefreshAll];
    
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
    if (self.isLoadUser && [Utils isMyUserId:self.modelUB.userId]) {
        self.isLoadUser = NO;
        ZWEAKSELF
        [snsV1 postGetUserInfoWithUserId:kLoginUserId resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            if (resultModel) {
                [AppSetting setUserLogin:resultModel];
                
                [AppSetting save];
                
                [weakSelf.viewMain setNewQuestionCount:resultModel.myQuesNewCount];
            }
        } errorBlock:nil];
    }
}

-(void)setDeleteAllClick:(ModelMyAllQuestion *)model
{
    [snsV1 postDeleteQuestionWithUserId:kLoginUserId questionId:model.ids resultBlock:nil errorBlock:nil];
}

-(void)setDeleteNewClick:(ModelMyNewQuestion *)model
{
    [snsV1 postDeleteQuestionWithQuestionId:model.ids resultBlock:nil errorBlock:nil];
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
    [snsV1 postMyGetQueryQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumAll resultBlock:^(NSDictionary *result) {
        [weakSelf.viewMain setAllBackgroundViewWithState:(ZBackgroundStateNone)];
        [weakSelf setAllViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
    } errorBlock:^(NSString *msg) {
        if (isRefresh) {
            [weakSelf.viewMain setAllBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }];
}

-(void)setRefreshAllHeader
{
    ZWEAKSELF
    self.pageNumAll = 1;
    [snsV1 postMyGetQueryQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumAll resultBlock:^(NSDictionary *result) {
        [weakSelf.viewMain endRefreshAllHeader];
        [weakSelf setAllViewDataWithDictionary:result isHeader:YES isRefresh:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshAllHeader];
    }];
}

-(void)setRefreshAllFooter
{
    ZWEAKSELF
    [snsV1 postMyGetQueryQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumAll+1 resultBlock:^(NSDictionary *result) {
        weakSelf.pageNumAll += 1;
        [weakSelf.viewMain endRefreshAllFooter];
        [weakSelf setAllViewDataWithDictionary:result isHeader:NO isRefresh:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshAllFooter];
    }];
}

-(void)setRefreshNewData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumNew = 1;
    if (isRefresh){[weakSelf.viewMain setNewBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV1 postMyGetUpdQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        [weakSelf.viewMain setNewBackgroundViewWithState:(ZBackgroundStateNone)];
        [weakSelf setNewViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
    } errorBlock:^(NSString *msg) {
        if (isRefresh) {
            [weakSelf.viewMain setNewBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }];
}

-(void)setRefreshNewHeader
{
    ZWEAKSELF
    self.pageNumNew = 1;
    [snsV1 postMyGetUpdQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        [weakSelf.viewMain endRefreshNewHeader];
        [weakSelf setNewViewDataWithDictionary:result isHeader:YES isRefresh:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshNewHeader];
    }];
}

-(void)setRefreshNewFooter
{
    ZWEAKSELF
    [snsV1 postMyGetUpdQuestionWithUserId:self.modelUB.userId pageNum:self.pageNumNew+1 resultBlock:^(NSDictionary *result) {
        weakSelf.pageNumNew += 1;
        [weakSelf.viewMain endRefreshNewFooter];
        [weakSelf setNewViewDataWithDictionary:result isHeader:NO isRefresh:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshNewFooter];
    }];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

-(void)setViewDataWithUserProfileModel:(ModelUserProfile *)model
{
    [self setModelUP:model];
}

@end
