//
//  ZPurchasePracticeTableView.m
//  PlaneLive
//
//  Created by Daniel on 15/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPurchasePracticeTableView.h"
#import "ZNewPracticeItemTVC.h"

@interface ZPurchasePracticeTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZPurchasePracticeTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setRowHeight:[ZNewPracticeItemTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
    
    ZWEAKSELF
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}
-(void)setViewDataWithNoLogin
{
    [self.arrMain removeAllObjects];
    [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    [self removeRefreshFooter];
    [self reloadData];
}
-(void)setViewDataWithNoData
{
    [self.arrMain removeAllObjects];
    [self setBackgroundViewWithState:(ZBackgroundStatePracticeNoData)];
    [self reloadData];
}
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStatePracticeNoData)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
        __weak typeof(self) weakSelf = self;
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self setRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrResult];
    } else {
        if (self.arrMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZNewPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewPracticeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setHiddenPrice];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onRowSelected) {
        self.onRowSelected(self.arrMain, indexPath.row);
    }
}

#define mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (self.onContentOffsetChange) {
        self.onContentOffsetChange(scrollView.contentOffset.y);
    }
}


@end
