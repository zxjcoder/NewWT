//
//  ZMyCommentViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCommentViewController.h"
#import "ZMyCommentReplyView.h"
#import "ZAnswerDetailViewController.h"

@interface ZMyCommentViewController ()

@property (strong, nonatomic) ZMyCommentReplyView *viewMain;

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ModelUserBase *modelUB;

@end

@implementation ZMyCommentViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
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
    self.viewMain = [[ZMyCommentReplyView alloc] initWithFrame:VIEW_ITEM_FRAME];
    
    [self.viewMain setViewIsDelete:[Utils isMyUserId:self.modelUB.userId]];
    
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
    ///评论对象点击事件
    [self.viewMain setOnCommentRowClick:^(ModelAnswerBase *model, ModelAnswerComment *modelAC) {
        [weakSelf showAnswerDetailVC:model defaultCommentModel:modelAC];
    }];
    ///收到的评论头像选中
    [self.viewMain setOnUserInfoClick:^(ModelUserBase *model) {
        [weakSelf showUserProfileVC:model];
    }];
    ///答案内容点击事件
    [self.viewMain setOnAnswerRowClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    [self.view addSubview:self.viewMain];
    
    [self innerData];
    
    [super innerInit];
}

-(void)innerData
{
    NSString *localCommentKey = [NSString stringWithFormat:@"MyAnswerCommentKey%@",self.modelUB.userId];
    NSDictionary *dicCommentLoacl = [sqlite getLocalCacheDataWithPathKay:localCommentKey];
    BOOL isRefreshComment = YES;
    if (dicCommentLoacl && [dicCommentLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshComment = NO;
        [self setCommentViewDataWithDictionary:dicCommentLoacl isHeader:YES isRefresh:isRefreshComment];
    }
    [self setRefreshCommentData:isRefreshComment];
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

-(void)setRefreshCommentData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNum = 1;
    if (isRefresh){[weakSelf.viewMain setCommentBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [DataOper130 getMyCommentArrayWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    self.pageNum = 1;
    [DataOper130 getMyCommentArrayWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
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
    [DataOper130 getMyCommentArrayWithUserId:self.modelUB.userId pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
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
