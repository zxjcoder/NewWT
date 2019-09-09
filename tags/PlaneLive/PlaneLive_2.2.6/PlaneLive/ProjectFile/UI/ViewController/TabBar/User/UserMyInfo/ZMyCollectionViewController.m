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
    [self.viewMain setOnPracticeRowClick:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.viewMain setOnDeletePracticeClick:^(ModelCollection *model) {
        [weakSelf setDeletePracticeClick:model];
    }];
    [self.viewMain setOnPageNumChangePractice:^{
        [weakSelf setPageNumPractice:1];
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
    NSString *localPracticeKey = [NSString stringWithFormat:@"MyCollectionPracticeNewKey%@",self.modelUB.userId];
    NSDictionary *dicPracticeLoacl = [sqlite getLocalCacheDataWithPathKay:localPracticeKey];
    BOOL isRefreshPractice = YES;
    if (dicPracticeLoacl && [dicPracticeLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshPractice = NO;
        [self setPracticeViewDataWithDictionary:dicPracticeLoacl isHeader:YES isRefresh:isRefreshPractice];
    }
    [self.viewMain setPracticeBackgroundViewWithState:(ZBackgroundStateLoading)];
    [self setRefreshPracticeData:isRefreshPractice];
    
    NSString *localSubscribeKey = [NSString stringWithFormat:@"MyCollectionSubscribesKey%@", self.modelUB.userId];
    NSDictionary *dicSubscribeLoacl = [sqlite getLocalCacheDataWithPathKay:localSubscribeKey];
    BOOL isRefreshSubscribe = YES;
    if (dicSubscribeLoacl && [dicSubscribeLoacl isKindOfClass:[NSDictionary class]]) {
        isRefreshSubscribe = NO;
        [self setSubscribeViewDataWithDictionary:dicSubscribeLoacl isHeader:YES isRefresh:isRefreshSubscribe];
    }
    [self.viewMain setSubscribeBackgroundViewWithState:(ZBackgroundStateLoading)];
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
-(void)setDeletePracticeClick:(ModelPractice *)model
{
    [snsV1 getDelCollectionWithUserId:kLoginUserId cid:model.hotspot_id type:@"3" resultBlock:nil errorBlock:nil];
}
-(void)setDeleteSubscribeClick:(ModelCollection *)model
{
    [snsV1 getDelCollectionWithUserId:kLoginUserId cid:model.hotspot_id type:@"7" resultBlock:nil errorBlock:nil];
}
///设置订阅数据
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
///设置实务数据
-(void)setPracticeViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicResult];
    [dicR setObject:[NSNumber numberWithBool:isHeader] forKey:kIsHeaderKey];
    [dicR setObject:[NSNumber numberWithBool:isRefresh] forKey:kIsRefreshKey];
    
    [self.viewMain setViewPracticeWithDictionary:dicR];
    
    if (isHeader) {
        NSString *localKey = [NSString stringWithFormat:@"MyCollectionPracticeNewKey%@",self.modelUB.userId];
        [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
    }
}
///初始化订阅数据
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
///刷新订阅顶部
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
///刷新订阅底部
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
///刷新实务数据
-(void)setRefreshPracticeData:(BOOL)isRefresh
{
    ZWEAKSELF
    if (isRefresh){[weakSelf.viewMain setPracticeBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [snsV2 getV6CollectPracticeArrayWithPageNum:1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumPractice = 1;
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
///刷新实务顶部数据
-(void)setRefreshPracticeHeader
{
    ZWEAKSELF
    [snsV2 getV6CollectPracticeArrayWithPageNum:1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumPractice = 1;
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
    [snsV2 getV6CollectPracticeArrayWithPageNum:self.pageNumPractice+1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNumPractice += 1;
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
