//
//  ZDownloadingTableView.m
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadingTableView.h"
#import "ZDownloadItemTVC.h"
#import "ModelAudio.h"

@interface ZDownloadingTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZDownloadingTableView

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
    
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self setRowHeight:[ZDownloadItemTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNullNoButton)];
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
/// 设置下载进度
-(void)setDownloadProgress:(double)progress model:(XMTrack *)model
{
    if (self.arrMain == nil || self.arrMain.count == 0) {
        return;
    }
    NSInteger index = 0;
    for (XMCacheTrack *modelCT in self.arrMain) {
        if (model.trackId == modelCT.trackId && model.source == modelCT.source) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            ZDownloadItemTVC *cell = (ZDownloadItemTVC*)[self cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell setDownloadProgress:progress];
            }
            break;
        }
        index++;
    }
}
/// 设置下载按钮状态
-(void)setDownloadButtonImage:(XMCacheTrackStatus)status model:(XMTrack *)model
{
    if (self.arrMain == nil || self.arrMain.count == 0) {
        return;
    }
    NSInteger index = 0;
    for (XMCacheTrack *modelCT in self.arrMain) {
        if (model.trackId == modelCT.trackId && model.source == modelCT.source) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            ZDownloadItemTVC *cell = (ZDownloadItemTVC*)[self cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell setChangeDownloadStatusWithStatus:status];
            }
            break;
        }
        index++;
    }
}
/// 设置下载停止状态
-(void)setStopDownloadWithModel:(XMTrack *)model
{
    if (self.arrMain == nil || self.arrMain.count == 0) {
        return;
    }
    NSInteger index = 0;
    for (XMCacheTrack *modelCT in self.arrMain) {
        if (model.trackId == modelCT.trackId && model.source == modelCT.source) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            ZDownloadItemTVC *cell = (ZDownloadItemTVC*)[self cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell setStopDownload];
            }
            break;
        }
        index++;
    }
}
/// 设置下载开始状态
-(void)setStartDownloadWithModel:(XMTrack *)model
{
    if (self.arrMain == nil || self.arrMain.count == 0) {
        return;
    }
    NSInteger index = 0;
    for (XMCacheTrack *modelCT in self.arrMain) {
        if (model.trackId == modelCT.trackId && model.source == modelCT.source) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            ZDownloadItemTVC *cell = (ZDownloadItemTVC*)[self cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell setStartDownload];
            }
            break;
        }
        index++;
    }
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
    
    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_onDownloadClick);
    OBJC_RELEASE(_onContentOffsetChange);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    
    __weak typeof(XMCacheTrack) *model = [self.arrMain objectAtIndex:indexPath.row];
    
    [cell setCellDataWithModel:model];
    
    [cell setDownloadButtonHidden:NO];
    
    ZWEAKSELF
    [cell setOnDownloadClick:^(XMCacheTrackStatus status, NSInteger row) {
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick(model);
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(XMCacheTrack) *model = [self.arrMain objectAtIndex:indexPath.row];
    if (model && self.onDownloadClick) {
        self.onDownloadClick(model);
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
