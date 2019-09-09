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

@property (assign, nonatomic) int pageNumNew;

@property (strong, nonatomic) ModelUserBase *modelUB;

@end

@implementation ZMyQuestionViewController

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
    [self.viewMain setOnBackgroundAllClick:^(ZBackgroundState state) {
        [weakSelf setRefreshAllData:YES];
    }];
    [self.viewMain setOnRefreshAllHeader:^{
        [weakSelf setRefreshAllHeader];
    }];
    [self.viewMain setOnRefreshAllFooter:^{
        [weakSelf setRefreshAllHeader];
    }];
    [self.viewMain setOnAllRowClick:^(ModelQuestionDetail *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    [self.viewMain setOnDeleteAllClick:^(ModelQuestionDetail *model) {
        [weakSelf setDeleteClick:model];
    }];
    
    [self.viewMain setOnBackgroundNewClick:^(ZBackgroundState state) {
        [weakSelf setRefreshNewData:YES];
    }];
    [self.viewMain setOnRefreshNewHeader:^{
        [weakSelf setRefreshNewHeader];
    }];
    [self.viewMain setOnRefreshNewFooter:^{
        [weakSelf setRefreshNewFooter];
    }];
    [self.viewMain setOnNewRowClick:^(ModelQuestionDetail *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    [self.viewMain setOnDeleteNewClick:^(ModelQuestionDetail *model) {
        [weakSelf setDeleteClick:model];
    }];
    [self.view addSubview:self.viewMain];
    
    [self setViewFrame];
    
    if ([self.modelUB.userId isEqualToString:[AppSetting getUserId]]) {
        [self.viewMain setViewIsDelete:YES];
    } else {
        [self.viewMain setViewIsDelete:NO];
    }
    
    [self innerData];
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

-(void)setDeleteClick:(ModelQuestionDetail *)model
{
    [sns postDeleteQuestionWithUserId:[AppSetting getUserDetauleId] questionId:model.ids resultBlock:nil errorBlock:nil];
}

-(void)setAllViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSString *localKey = [NSString stringWithFormat:@"MyQuestionAllKey%@",self.modelUB.userId];
    if (isHeader) {
        NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
        [dicR setObject:@"YES" forKey:kIsHeaderKey];
        if (isRefresh) {
            [dicR setObject:@"YES" forKey:kIsRefreshKey];
        }
        [self.viewMain setViewAllWithDictionary:dicR];
        
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    } else {
        [self.viewMain setViewAllWithDictionary:dicResult];
    }
}

-(void)setNewViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSString *localKey = [NSString stringWithFormat:@"MyQuestionNewKey%@",self.modelUB.userId];
    if (isHeader) {
        NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
        [dicR setObject:@"YES" forKey:kIsHeaderKey];
        if (isRefresh) {
            [dicR setObject:@"YES" forKey:kIsRefreshKey];
        }
        [self.viewMain setViewNewWithDictionary:dicR];
        
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    } else {
        [self.viewMain setViewNewWithDictionary:dicResult];
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
