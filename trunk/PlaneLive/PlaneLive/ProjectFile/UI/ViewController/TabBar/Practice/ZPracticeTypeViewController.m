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
#import "ZAlertSortView.h"

@interface ZPracticeTypeViewController ()

@property (strong, nonatomic) ZPracticeTypeTableView *tvMain;
@property (assign, nonatomic) int pageNum;
@property (assign, nonatomic) ZPracticeTypeSort sort;

@end

@implementation ZPracticeTypeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPractice];
    [self innerInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPracticePaySuccess:) name:ZPracticePaySuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightButtonWithSearch];
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageHomePracticeKey];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageHomePracticeKey dictionary:nil];
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
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshType];
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
    [self.tvMain setOnSortClick:^(ZPracticeTypeSort sort) {
        [weakSelf setSortClick:sort];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self setSort:self.tvMain.getSortValue];
    [self innerLocalPracticeTypeData];
    [self innerLocalPracticeData];
    [self setRefreshType];
    [self setRefreshHeader];
}
-(NSString *)getLocalPracticeTypeKey
{
    return [NSString stringWithFormat:@"DataPracticeTypeKey%@", kLoginUserId];
}
-(NSString *)getLocalPracticeKey
{
    return [NSString stringWithFormat:@"DataPracticeKey%@", kLoginUserId];
}
-(void)innerLocalPracticeData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:[self getLocalPracticeKey]];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *arrR = [dicLocal objectForKey:kResultKey];
        NSMutableArray *arrResult = [NSMutableArray array];
        if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
            for (NSDictionary *dic in arrR) {
                [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
            }
        }
        [self.tvMain setViewPracticeDataWithArray:arrResult isHeader:YES];
    }
}
-(void)innerLocalPracticeTypeData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:[self getLocalPracticeTypeKey]];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *arrR = [dicLocal objectForKey:kResultKey];
        NSMutableArray *arrResult = [NSMutableArray array];
        if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
            for (NSDictionary *dic in arrR) {
                [arrResult addObject:[[ModelPracticeType alloc] initWithCustom:dic]];
            }
        }
        [self.tvMain setViewTypeDataWithArray:arrResult];
    }
}
///购买成功刷新数据对象
-(void)setPracticePaySuccess:(NSNotification *)sender
{
    if (sender.object && [sender.object isKindOfClass:[ModelPractice class]]) {
        [self.tvMain setPayPracticeSuccess:sender.object];
    }
}
-(void)setSortClick:(ZPracticeTypeSort)sort
{
    ZAlertSortView *viewAlert = [[ZAlertSortView alloc] init];
    ZWEAKSELF
    [viewAlert setOnSortClick:^(ZPracticeTypeSort sort) {
        weakSelf.sort = sort;
        [weakSelf.tvMain setSortButton:sort];
        [weakSelf setRefreshHeader];
    }];
    __weak UIButton *btnSort = self.tvMain.viewHeader.btnSort;
    CGPoint sortPoint = [btnSort.superview convertPoint:btnSort.frame.origin toView:self.view];
    CGPoint alertPoint = CGPointMake(viewAlert.width-20-130, sortPoint.y+32);
    [viewAlert show:alertPoint];
}
-(void)setRefreshType
{
    ZWEAKSELF
    [snsV2 getPracticeTypeArrayWithPageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewTypeDataWithArray:arrResult];
        
        [sqlite setLocalCacheDataWithDictionary:result pathKay:[weakSelf getLocalPracticeTypeKey]];
        //[sqlite setLocalPracticeTypeWithArray:arrResult userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewTypeDataWithArray:nil];
    }];
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getPracticeTypePracticeArrayWithParam:kEmpty pageNum:1 sort:self.sort resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNum = 1;
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:YES];
        if (weakSelf.sort == ZPracticeTypeSortRecommend) {
            [sqlite setLocalCacheDataWithDictionary:result pathKay:[weakSelf getLocalPracticeKey]];
        }
        //[sqlite setLocalPracticeTypePracticeListWithArray:arrResult userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewPracticeDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getPracticeTypePracticeArrayWithParam:kEmpty pageNum:self.pageNum+1 sort:self.sort resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
