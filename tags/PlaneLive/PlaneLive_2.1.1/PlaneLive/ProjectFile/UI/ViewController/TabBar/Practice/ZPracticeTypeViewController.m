//
//  ZPracticeTypeViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeTypeViewController.h"
#import "ZPracticeTypeTableView.h"

#import "ZPracticeListViewController.h"

@interface ZPracticeTypeViewController ()

@property (strong, nonatomic) ZPracticeTypeTableView *tvMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZPracticeTypeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPractice];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshHeader];
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
    self.tvMain = [[ZPracticeTypeTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnPracticeClick:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.tvMain setOnPracticeAllClick:^(ModelPracticeType *model) {
        ZPracticeListViewController *itemVC = [[ZPracticeListViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{
    NSArray *arrPT = [sqlite getLocalPracticeTypeArrayWithUserId:[AppSetting getUserDetauleId]];
    if (arrPT && arrPT.count > 0) {
        [self.tvMain setViewDataWithArray:arrPT isHeader:YES];
    }
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getPracticeTypeArrayWithPageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalPracticeTypeWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getPracticeTypeArrayWithPageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
