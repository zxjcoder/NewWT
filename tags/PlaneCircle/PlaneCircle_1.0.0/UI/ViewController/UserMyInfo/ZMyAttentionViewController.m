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

@property (strong, nonatomic) ZMyAttentionView *viewMain;

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
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_ITEM_FRAME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
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
    self.viewMain = [[ZMyAttentionView alloc] init];
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
    
    [self.viewMain setOnBackgroundUserClick:^(ZBackgroundState state) {
        [weakSelf setRefreshUserData:YES];
    }];
    [self.viewMain setOnRefreshUserHeader:^{
        [weakSelf setRefreshUserHeader];
    }];
    [self.viewMain setOnRefreshUserFooter:^{
        [weakSelf setRefreshUserFooter];
    }];
    [self.viewMain setOnUserRowClick:^(ModelUserBase *model) {
        if (![model.userId isEqualToString:[AppSetting getUserDetauleId]]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    [self.viewMain setOnDeleteUserClick:^(ModelUserBase *model) {
        [weakSelf setDeleteUserClick:model];
    }];
    [self.view addSubview:self.viewMain];
    
    [self setViewFrame];
    
    if ([self.modelUB.userId isEqualToString:[AppSetting getUserDetauleId]]) {
        [self.viewMain setViewIsDelete:YES];
    } else {
        [self.viewMain setViewIsDelete:NO];
    }
    
    [self innerData];
}

-(void)innerData
{
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
    NSString *localKey = [NSString stringWithFormat:@"MyAttentArticlesKey%@",self.modelUB.userId];
    if (isHeader) {
        NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
        [dicR setObject:@"YES" forKey:kIsHeaderKey];
        if (isRefresh) {
            [dicR setObject:@"YES" forKey:kIsRefreshKey];
        }
        [self.viewMain setViewTopicWithDictionary:dicR];
        
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    } else {
        [self.viewMain setViewTopicWithDictionary:dicResult];
    }
}

-(void)setUserViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSString *localKey = [NSString stringWithFormat:@"MyAttentUsersKey%@",self.modelUB.userId];
    if (isHeader) {
        NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
        [dicR setObject:@"YES" forKey:kIsHeaderKey];
        if (isRefresh) {
            [dicR setObject:@"YES" forKey:kIsRefreshKey];
        }
        [self.viewMain setViewUserWithDictionary:dicR];
        
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    } else {
        [self.viewMain setViewUserWithDictionary:dicResult];
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

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

@end
