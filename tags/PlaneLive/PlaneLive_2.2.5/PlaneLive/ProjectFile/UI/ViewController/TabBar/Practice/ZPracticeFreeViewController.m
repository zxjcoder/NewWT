//
//  ZPracticeFreeViewController.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPracticeFreeViewController.h"
#import "ZPracticeTableView.h"

@interface ZPracticeFreeViewController ()

@property (strong, nonatomic) ZPracticeTableView *tvMain;
@property (assign, nonatomic) int pageNum;

@end

@implementation ZPracticeFreeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"免费专区"];
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithSearch];
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
#define kPracticeFreeDataKey @"kPracticeFreeDataKey"
-(void)innerData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kPracticeFreeDataKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *arrR = [dicLocal objectForKey:kResultKey];
        NSMutableArray *arrResult = [NSMutableArray array];
        if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
            for (NSDictionary *dic in arrR) {
                [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
            }
        }
        [self.tvMain setViewDataWithArray:arrResult isHeader:YES];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeader];
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
    [snsV2 getV6FreePracticeArrayWithPageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalCacheDataWithDictionary:result pathKay:kPracticeFreeDataKey];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getV6FreePracticeArrayWithPageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
