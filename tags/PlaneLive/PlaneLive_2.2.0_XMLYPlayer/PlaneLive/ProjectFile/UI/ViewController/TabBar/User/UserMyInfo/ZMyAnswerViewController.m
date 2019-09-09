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
    self.viewMain = [[ZMyAnswerView alloc] initWithFrame:VIEW_ITEM_FRAME];
    
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
    ///我的答案头像点击
    [self.viewMain setOnImagePhotoClick:^(ModelUserBase *model) {
        if ([Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    ///我的答案行选择
    [self.viewMain setOnAnswerRowClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    ///我的答案->问题选中
    [self.viewMain setOnQuestionRowClick:^(ModelQuestionBase *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    ///我的答案删除
    [self.viewMain setOnDeleteAnswerClick:^(ModelQuestionMyAnswer *model) {
        [weakSelf setDeleteAnswerClick:model];
    }];
    ///所有设置分页数量
    [self.viewMain setOnAnswerPageNumChange:^(int pageNum) {
        [weakSelf setPageNumAnswer:pageNum];
    }];
    
    [self.view addSubview:self.viewMain];
    
    [super innerInit];
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
}

-(void)setDeleteAnswerClick:(ModelQuestionMyAnswer *)model
{
    [snsV1 postDeleteAnswerWithAnswerId:model.aid userId:[AppSetting getUserDetauleId] resultBlock:nil errorBlock:nil];
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

-(void)setRefreshAnswerData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNumAnswer = 1;
    if (isRefresh){[weakSelf.viewMain setAnswerBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV1 postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSDictionary *result) {
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
    [snsV1 postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer resultBlock:^(NSDictionary *result) {
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
    [snsV1 postMyGetReplyWithUserId:self.modelUB.userId pageNum:self.pageNumAnswer+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNumAnswer += 1;
            [weakSelf.viewMain endRefreshAnswerFooter];
            [weakSelf setAnswerViewDataWithDictionary:result isHeader:NO isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshAnswerFooter];
        });
    }];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

@end
