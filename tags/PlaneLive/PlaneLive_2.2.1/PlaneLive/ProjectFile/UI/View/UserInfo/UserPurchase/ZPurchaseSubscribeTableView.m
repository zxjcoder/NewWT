//
//  ZPurchaseSubscribeTableView.m
//  PlaneLive
//
//  Created by Daniel on 15/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPurchaseSubscribeTableView.h"
#import "ZHomeSubscribeItemTVC.h"

@interface ZPurchaseSubscribeTableView()<UITableViewDelegate,UITableViewDataSource>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (assign, nonatomic) BOOL isSubscribeNoData;

@end

@implementation ZPurchaseSubscribeTableView

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
    
    [self setRowHeight:[ZHomeSubscribeItemTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    ZWEAKSELF
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}
-(void)setViewDataWithNoLogin
{
    [self.arrMain removeAllObjects];
    [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    [self reloadData];
}
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self setIsSubscribeNoData:NO];
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setIsSubscribeNoData:YES];
                if (kIsAppAudit) {
                    [self setBackgroundViewWithState:(ZBackgroundStateSpecialColumnNoData)];
                } else {
                    [self setBackgroundViewWithState:(ZBackgroundStateSubscribeNoData)];
                }
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
-(void)setViewDataWithCurriculumArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateCurriculumNoData)];
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

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onSubscribeClick);
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
    ZHomeSubscribeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZHomeSubscribeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setHiddenPriceWithValue:YES];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onSubscribeClick) {
        ZHomeSubscribeItemTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setImageTotalHidden:YES];
        }
        ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onSubscribeClick(model);
    }
}

@end
