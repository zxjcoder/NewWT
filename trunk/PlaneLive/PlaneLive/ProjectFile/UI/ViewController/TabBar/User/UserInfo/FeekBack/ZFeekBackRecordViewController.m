//
//  ZFeekBackRecordViewController.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackRecordViewController.h"
#import "ZBaseTableView.h"
#import "ZFeekBackListItemTVC.h"

@interface ZFeekBackRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZFeekBackListItemTVC *tvcItem;
@property (strong, nonatomic) NSMutableArray *arrayMain;
@property (assign, nonatomic) int pageNum;

@end

@implementation ZFeekBackRecordViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"反馈记录"];
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
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrayMain = [NSMutableArray array];
    self.tvcItem = [[ZFeekBackListItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
    }];
    [super innerInit];
    [self setReloadLocalData];
    
    ModelUser *modelU = [AppSetting getUserLogin];
    modelU.myFeedbackReplyCount = 0;
    [AppSetting setUserLogin:modelU];
    [AppSetting save];
}
static NSString *keyFeekBackLocalData = @"keyFeekBackLocalData";
-(void)setReloadLocalData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:keyFeekBackLocalData];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *arrResult = [NSMutableArray array];
        NSArray *arrR = [dicLocal objectForKey:kResultKey];
        if (arrR && [arrR isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrR) {
                [arrResult addObject:[[ModelFeedBack alloc] initWithCustom:dic]];
            }
        }
        [self.arrayMain removeAllObjects];
        [self.arrayMain addObjectsFromArray:arrResult];
        [self.tvMain reloadData];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeader];
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getV6FeedBackArrayWithPageNum:1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNum = 1;
        [weakSelf.arrayMain removeAllObjects];
        [weakSelf.arrayMain addObjectsFromArray:array];
        if (array.count == 0) {
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
        } else {
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
        }
        if (array && array.count >= kPAGE_MAXCOUNT) {
            [weakSelf.tvMain setRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [weakSelf.tvMain removeRefreshFooter];
        }
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain reloadData];
        
        [sqlite setLocalCacheDataWithDictionary:result pathKay:keyFeekBackLocalData];
    } errorBlock:^(NSString *msg) {
        if (weakSelf.arrayMain.count == 0) {
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
        [weakSelf.tvMain endRefreshHeader];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getV6FeedBackArrayWithPageNum:self.pageNum+1 resultBlock:^(NSArray *array, NSDictionary *result) {
        weakSelf.pageNum += 1;
        [weakSelf.arrayMain addObjectsFromArray:array];
        if (array && array.count >= kPAGE_MAXCOUNT) {
            [weakSelf.tvMain setRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [weakSelf.tvMain removeRefreshFooter];
        }
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain reloadData];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelFeedBack *model = [self.arrayMain objectAtIndex:indexPath.row];
    CGFloat rowHeight = [self.tvcItem setCellDataWithModel:model];
    return rowHeight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZFeekBackListItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZFeekBackListItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelFeedBack *model = [self.arrayMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnImageItemClick:^(NSArray *images, NSInteger index) {
        NSMutableArray *imageUrls = [NSMutableArray new];
        for (NSString *url in images) {
            if (url) {
                [imageUrls addObject:[NSURL URLWithString:url]];
            }
        }
        [weakSelf showPhotoBrowserWithArray:imageUrls index:index];
    }];
    return cell;
}

@end
