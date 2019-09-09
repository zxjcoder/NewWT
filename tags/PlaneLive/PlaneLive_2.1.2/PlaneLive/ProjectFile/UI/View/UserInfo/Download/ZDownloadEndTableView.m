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

@interface ZDownloadEndTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;
///选中集合
@property (strong, nonatomic) NSMutableArray *arrSelect;

///是否开始勾选
@property (assign, nonatomic) BOOL check;
///是否选中全部
@property (assign, nonatomic) BOOL checkAll;

@end

@implementation ZDownloadEndTableView

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
    self.arrSelect = [NSMutableArray array];
    
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self setRowHeight:[ZDownloadItemTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
}

-(void)setViewDataWithArray:(NSArray *)arrResult
{
    [self.arrMain removeAllObjects];
    if (arrResult && arrResult.count > 0) {
        [self.arrMain addObjectsFromArray:arrResult];
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateNullNoButton)];
    }
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_onCheckedClick);
    OBJC_RELEASE(_onContentOffsetChange);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_arrSelect);
}

/// 获取选中对象集合
-(NSArray *)getCheckArray
{
    return self.arrSelect;
}
/// 获取数据数量
-(NSInteger)getDataCount
{
    return self.arrMain.count;
}
///设置是否开始勾选
-(void)setStartChecked:(BOOL)check
{
    [self setCheck:check];
    
    [self reloadData];
}

///设置是否选中全部
-(void)setCheckedAll:(BOOL)checkAll
{
    [self setCheckAll:checkAll];
    
    NSArray *arrPath = [self indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in arrPath) {
        ZDownloadItemTVC *cell = (ZDownloadItemTVC*)[self cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setCheckedStatus:checkAll];
        }
    }
    [self.arrSelect removeAllObjects];
    if (checkAll) {
        [self.arrSelect addObjectsFromArray:self.arrMain];
    }
    [self reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.check;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWEAKSELF
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                             title:kDelete
                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                           {
                                               ModelAudio *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
                                               
                                               [weakSelf.arrMain removeObjectAtIndex:indexPath.row];
                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                               
                                               if (weakSelf.arrMain.count == 0) {
                                                   [weakSelf setBackgroundViewWithState:(ZBackgroundStateNullNoButton)];
                                               }
                                               if (weakSelf.onDeleteClick) {
                                                   weakSelf.onDeleteClick(model, (int)weakSelf.arrMain.count);
                                               }
                                               GCDMainBlock(^{
                                                   [tableView reloadData];
                                               });
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
    
    ModelAudio *model = [self.arrMain objectAtIndex:indexPath.row];
    
    [cell setCellDataWithModel:model];
    
    [cell setCheckShow:self.check];
    
    [cell setCheckedStatus:self.checkAll];
    
    ZWEAKSELF
    [cell setOnCheckedClick:^(BOOL check, NSInteger row) {
        ModelAudio *modelA = [weakSelf.arrMain objectAtIndex:row];
        if (check) {
            [weakSelf.arrSelect addObject:modelA];
        } else {
            [weakSelf.arrSelect removeObject:modelA];
        }
        if (weakSelf.onCheckedClick) {
            weakSelf.onCheckedClick(check, row, weakSelf.arrSelect.count, weakSelf.arrSelect.count==weakSelf.arrMain.count);
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.check) {
        if (self.onRowSelected) {
            self.onRowSelected(self.arrMain, indexPath.row);
        }
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
