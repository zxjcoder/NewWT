//
//  ZDownloadEndTableView.m
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadEndTableView.h"
#import "ZDownloadItemTVC.h"
#import "ModelAudio.h"
#import "ZDownloadHeaderView.h"
#import "ZDownloadFooterView.h"

@interface ZDownloadEndTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (strong, nonatomic) NSMutableArray *arrSelect;
@property (strong, nonatomic) ZDownloadHeaderView *viewHeader;
@property (strong, nonatomic) ZDownloadFooterView *viewFooter;
@property (assign, nonatomic) BOOL isChecking;
@property (assign, nonatomic) BOOL isCheckAll;
@property (assign, nonatomic) CGRect tvFrame;
@property (assign, nonatomic) CGRect footerFrame;

@end

@implementation ZDownloadEndTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    self.arrSelect = [NSMutableArray array];
    [self setUserInteractionEnabled:YES];
    ZWEAKSELF
    self.viewHeader = [[ZDownloadHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, [ZDownloadHeaderView getH])];
    [self.viewHeader setUserInteractionEnabled:YES];
    [self.viewHeader setOnCheckClick:^(BOOL checkAll) {
        [weakSelf setIsCheckAll:checkAll];
        [weakSelf.arrSelect removeAllObjects];
        if (checkAll) {
            [weakSelf.arrSelect addObjectsFromArray:weakSelf.arrMain];
        }
        [weakSelf.viewFooter setDownloadSelCount:(int)weakSelf.arrSelect.count];
        [weakSelf.tvMain reloadData];
    }];
    [self.viewHeader setOnCancelClick:^{
        [weakSelf setIsChecking:NO];
        [weakSelf setHiddenFooterView];
        [weakSelf.tvMain reloadData];
    }];
    [self.viewHeader setOnDeleteClick:^{
        [weakSelf setIsChecking:YES];
        [weakSelf setShowFooterView];
        [weakSelf.tvMain reloadData];
    }];
    [self addSubview:self.viewHeader];
    
    self.footerFrame = CGRectMake(0, self.height, self.width, [ZDownloadFooterView getH]);
    self.viewFooter = [[ZDownloadFooterView alloc] initWithFrame:self.footerFrame];
    [self.viewFooter setUserInteractionEnabled:YES];
    [self.viewFooter setOnDeleteClick:^{
        if (weakSelf.onDeleteMultipleClick) {
            weakSelf.onDeleteMultipleClick(weakSelf.arrSelect);
        }
        [weakSelf.viewHeader setEndCheckButton];
        [weakSelf setIsCheckAll:NO];
        [weakSelf setIsChecking:NO];
        [weakSelf setHiddenFooterView];
    }];
    [self addSubview:self.viewFooter];
    
    CGRect tvFrame = self.bounds;
    tvFrame.origin.y = self.viewHeader.height;
    tvFrame.size.height -= self.viewHeader.height;
    self.tvFrame = tvFrame;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.tvFrame];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setRowHeight:[ZDownloadItemTVC getH]];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self addSubview:self.tvMain];
}
-(void)setShowFooterView
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        CGRect tvFrame = self.tvFrame;
        tvFrame.size.height -= self.viewFooter.height;
        [self.tvMain setFrame:tvFrame];
        
        CGRect footerFrame = self.footerFrame;
        footerFrame.origin.y -= footerFrame.size.height;
        [self.viewFooter setFrame:footerFrame];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)setHiddenFooterView
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        CGRect tvFrame = self.tvFrame;
        [self.tvMain setFrame:tvFrame];
        
        CGRect footerFrame = self.footerFrame;
        [self.viewFooter setFrame:footerFrame];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)addRefreshHeaderWithEndBlock:(void (^)(void))refreshBlock
{
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
}
-(void)endRefreshHeader
{
    [self.tvMain endRefreshHeader];
}
-(void)setScrollsToTop:(BOOL)isTop
{
    [self.tvMain setScrollsToTop:isTop];
}
-(void)setViewDataWithArray:(NSArray *)arrResult
{
    [self.arrMain removeAllObjects];
    if (arrResult && arrResult.count > 0) {
        [self.arrMain addObjectsFromArray:arrResult];
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNullNoButton)];
    }
    [self.viewHeader setDownloadMaxCount:arrResult.count];
    [self.tvMain reloadData];
}

-(void)dealloc
{
    [self.tvMain setDataSource:nil];
    [self.tvMain setDelegate:nil];
    OBJC_RELEASE(_viewFooter);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_arrSelect);
}
/// 获取选中对象集合
-(NSArray *)getCheckArray
{
    return self.arrSelect;
}
///设置是否开始勾选
-(void)setStartChecked:(BOOL)check
{
    [self setIsChecking:check];
    
    [self.tvMain reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isChecking;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWEAKSELF
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                             title:kDelete
                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                           {
                                               XMCacheTrack *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
                                               if (weakSelf.onDeleteClick) {
                                                   weakSelf.onDeleteClick(model);
                                               }
                                           }];
    [editRowAction setBackgroundColor:MAINCOLOR];
    return @[editRowAction];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZDownloadItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZDownloadItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    
    XMCacheTrack *model = [self.arrMain objectAtIndex:indexPath.row];
    
    [cell setCellDataWithModel:model];
    
    [cell setCheckShow:self.isChecking];
    
    [cell setCheckedStatus:self.isCheckAll];
    
    ZWEAKSELF
    [cell setOnCheckedClick:^(BOOL check, NSInteger row) {
        XMCacheTrack *modelCT = [weakSelf.arrMain objectAtIndex:row];
        if (check) {
            [weakSelf.arrSelect addObject:modelCT];
        } else {
            [weakSelf.arrSelect removeObject:modelCT];
        }
        [weakSelf.viewFooter setDownloadSelCount:(int)weakSelf.arrSelect.count];
        [weakSelf.viewHeader setCheckAllStatus:weakSelf.arrSelect.count==weakSelf.arrMain.count];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isChecking) {
        if (self.onRowSelected) {
            self.onRowSelected(self.arrMain, indexPath.row);
        }
    }
}


@end
