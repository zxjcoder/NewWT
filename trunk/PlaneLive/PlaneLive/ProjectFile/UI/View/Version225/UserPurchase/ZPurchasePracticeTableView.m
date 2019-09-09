//
//  ZPurchasePracticeTableView.m
//  PlaneLive
//
//  Created by Daniel on 15/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPurchasePracticeTableView.h"
#import "ZNewPracticeItemTVC.h"
#import "ZGlobalPlayView.h"

@interface ZPurchasePracticeTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ZBaseTVC *tvcSpace;

@end

@implementation ZPurchasePracticeTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    self.tvcSpace = [[ZBaseTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    [self.tvcSpace innerInit];
    self.tvcSpace.cellH = [ZGlobalPlayView getMinH];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    //[self setRowHeight:[ZNewPracticeItemTVC getH]];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace.cellH;
    }
    return [ZNewPracticeItemTVC getH];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace;
    }
    static NSString *cellid = @"tvcellid";
    ZNewPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewPracticeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setHiddenPrice];
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.onRowSelected) {
            ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
            [model setIncreasedCourseCount:0];
            ZNewPracticeItemTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setCellDataWithModel:model];
            self.onRowSelected(self.arrMain, indexPath.row);
        }
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
