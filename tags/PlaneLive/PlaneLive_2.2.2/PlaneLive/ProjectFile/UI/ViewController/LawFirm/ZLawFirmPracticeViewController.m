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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess:) name:ZCartPaySuccessNotification object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCartPaySuccessNotification object:nil];
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
    [self.tvMain addRefreshHeaderWithEndBlock:^{
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
    
    [self setRefreshHeader];
}
-(void)innerData
{
    
}
///购买成功刷新数据对象
-(void)setCartPaySuccess:(NSNotification *)sender
{
    if (sender.object && [sender.object isKindOfClass:[ModelPractice class]]) {
        [self.tvMain setPayPracticeSuccess:sender.object];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getLawFirmPracticeListWithLawFirmId:self.model.ids pageNum:self.pageNum resultBlock:^(NSArray *result) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:result isHeader:YES];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getLawFirmPracticeListWithLawFirmId:self.model.ids pageNum:self.pageNum+1 resultBlock:^(NSArray *result) {
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
