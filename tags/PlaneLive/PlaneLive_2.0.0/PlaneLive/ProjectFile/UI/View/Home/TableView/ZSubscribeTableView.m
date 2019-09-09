//
//  ZSubscribeTableView.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeTableView.h"
#import "ZHomeSubscribeTVC.h"

@interface ZSubscribeTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZSubscribeTableView

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
    [self setRowHeight:[ZHomeSubscribeTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
        ZWEAKSELF
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
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

-(void)setViewDataBackNoneWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            [self.arrMain removeAllObjects];
        }
        ZWEAKSELF
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrResult];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    }
    [self reloadData];
}

///获取实务数据集合
-(NSArray *)getPracticeArray
{
    return self.arrMain;
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
    ZHomeSubscribeTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZHomeSubscribeTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onRowSelected) {
        self.onRowSelected([self.arrMain objectAtIndex:indexPath.row]);
    }
}

#define mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onContentOffsetChange) {
        self.onContentOffsetChange(scrollView.contentOffset.y);
    }
}

@end
