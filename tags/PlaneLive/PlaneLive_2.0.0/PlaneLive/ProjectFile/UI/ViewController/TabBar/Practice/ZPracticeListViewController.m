//
//  ZPracticeListViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeListViewController.h"
#import "ZPracticeTableView.h"

@interface ZPracticeListViewController ()

@property (strong, nonatomic) ZPracticeTableView *tvMain;

@property (strong, nonatomic) ModelPracticeType *model;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZPracticeListViewController

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
    [self setTitle:self.model.type];
    
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
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{   
    NSArray *arrP = [sqlite getLocalPracticeArrayWithUserId:[AppSetting getUserDetauleId] typeId:self.model.ids];
    if (arrP && arrP.count > 0) {
        [self.tvMain setViewDataWithArray:arrP isHeader:YES];
    }
    
    [self setRefreshHeader];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [DataOper200 getPracticeArrayWithTypeId:self.model.ids pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalPracticeWithArray:arrResult typeId:weakSelf.model.ids userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    [DataOper200 getPracticeArrayWithTypeId:self.model.ids pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

-(void)setViewDataWithModel:(ModelPracticeType *)model
{
    [self setModel:model];
}

@end
