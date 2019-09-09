//
//  ZLawFirmSubscribeViewController.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmSubscribeViewController.h"
#import "ZLawFirmSubscribeTableView.h"
#import "ZSubscribeDetailViewController.h"

@interface ZLawFirmSubscribeViewController ()

@property (strong, nonatomic) ZLawFirmSubscribeTableView *tvMain;
@property (strong, nonatomic) ModelLawFirm *model;
@property (assign, nonatomic) int pageNum;

@end

@implementation ZLawFirmSubscribeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kLawFirmRecommendedSubscribe];
    [self innerInit];
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
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZLawFirmSubscribeTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnSubscribeClick:^(ModelSubscribe *model) {
        ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}
-(NSString *)getLocalKey
{
    return [NSString stringWithFormat:@"keyLawFirmSubscribeDataKey%@", self.model.ids==nil?kEmpty:self.model.ids];
}
-(void)innerData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:[self getLocalKey]];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dicLocal objectForKey:kResultKey];
        if (array && [array isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrayResult = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                [arrayResult addObject:model];
            }
            [self.tvMain setViewDataWithArray:arrayResult isHeader:YES];
        }
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeader];
}
-(void)setViewDataWithModel:(ModelLawFirm *)model
{
    [self setModel:model];
}
///刷新顶部数据
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getLawFirmSubscribeListWithLawFirmId:self.model.ids pageNum:1 resultBlock:^(NSArray *result, NSDictionary *dic) {
        
        weakSelf.pageNum = 1;
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:YES];
        
        [sqlite setLocalCacheDataWithDictionary:dic pathKay:[weakSelf getLocalKey]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新推荐底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getLawFirmSubscribeListWithLawFirmId:self.model.ids pageNum:self.pageNum resultBlock:^(NSArray *result, NSDictionary *dic) {
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
