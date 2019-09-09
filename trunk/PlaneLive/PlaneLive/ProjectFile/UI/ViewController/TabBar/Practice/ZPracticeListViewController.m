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
    [self setTitle:self.model.type];
    
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
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}
-(void)innerData
{   
    NSArray *arrP = [sqlite getLocalPracticeArrayWithUserId:kLoginUserId typeId:self.model.ids];
    if (arrP && [arrP isKindOfClass:[NSArray class]] && arrP.count > 0) {
        [self.tvMain setViewDataWithArray:arrP isHeader:YES];
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
    if (self.isLoaded) {
        return;
    }
    self.isLoaded = true;
    ZWEAKSELF
    [snsV2 getPracticeArrayWithTypeId:self.model.ids pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.isLoaded = false;
        weakSelf.pageNum = 1;
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalPracticeWithArray:arrResult typeId:weakSelf.model.ids userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        weakSelf.isLoaded = false;
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getPracticeArrayWithTypeId:self.model.ids pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
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
