//
//  ZLawFirmPracticeViewController.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmPracticeViewController.h"
#import "ZPracticeTableView.h"

@interface ZLawFirmPracticeViewController ()

@property (strong, nonatomic) ZPracticeTableView *tvMain;
@property (strong, nonatomic) ModelLawFirm *model;
@property (assign, nonatomic) int pageNum;

@end

@implementation ZLawFirmPracticeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kLawFirmRecommendedPractice];
    [self innerInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPracticePaySuccess:) name:ZPracticePaySuccessNotification object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPracticePaySuccessNotification object:nil];
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
    self.tvMain = [[ZPracticeTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    [self innerData];
}
-(NSString *)getLocalKey
{
    return [NSString stringWithFormat:@"keyLawFirmPracticeDataKey%@", self.model.ids==nil?kEmpty:self.model.ids];
}
-(void)innerData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:[self getLocalKey]];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dicLocal objectForKey:kResultKey];
        if (array && [array isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrayResult = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
                [arrayResult addObject:model];
            }
            [self.tvMain setViewDataWithArray:arrayResult isHeader:YES];
        }
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeader];
}
///购买成功刷新数据对象
-(void)setPracticePaySuccess:(NSNotification *)sender
{
    if (sender.object && [sender.object isKindOfClass:[ModelPractice class]]) {
        [self.tvMain setPayPracticeSuccess:sender.object];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getLawFirmPracticeListWithLawFirmId:self.model.ids pageNum:1 resultBlock:^(NSArray *result, NSDictionary *dic) {
        weakSelf.pageNum = 1;
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:YES];
        
        [sqlite setLocalCacheDataWithDictionary:dic pathKay:[weakSelf getLocalKey]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getLawFirmPracticeListWithLawFirmId:self.model.ids pageNum:self.pageNum+1 resultBlock:^(NSArray *result, NSDictionary *dic) {
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

-(void)setViewDataWithModel:(ModelLawFirm *)model
{
    [self setModel:model];
}

@end
