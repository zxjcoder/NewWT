//
//  ZDownloadingTableView.m
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadingTableView.h"
#import "ZDownloadingItemTVC.h"
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
    
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setRowHeight:[ZDownloadingItemTVC getH]];
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
        [self setBackgroundViewWithState:(ZBackgroundStateNull)];
    }
    [self reloadData];
}
/// 移除对象
-(void)setDownloadRemoveObject:(XMTrack *)model
{
    [self.arrMain removeObject:model];
    
    [self reloadData];
}
/// 设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row
{
    if (self.arrMain == nil || self.arrMain.count == 0) {
        return;
    }
    if (row < self.arrMain.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        ZDownloadingItemTVC *cell = (ZDownloadingItemTVC*)[self cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[ZDownloadingItemTVC class]]) {
            [cell setDownloadProgress:progress];
        }
    }
}
/// 设置下载按钮状态
-(void)setDownloadButtonImage:(XMCacheTrackStatus)status row:(NSInteger)row
{
    if (self.arrMain == nil || self.arrMain.count == 0) {
        return;
    }
    if (row < self.arrMain.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        ZDownloadingItemTVC *cell = (ZDownloadingItemTVC*)[self cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[ZDownloadingItemTVC class]]) {
            [cell setDownloadStatus:status];
        }
    }
}
-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onDeleteClick);
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            XMCacheTrack *model = [self.arrMain objectAtIndex:indexPath.row];
            if (self.onDeleteClick) {
                self.onDeleteClick(model);
            }
            break;
        }
        default:
            break;
    }
}
/// TODO: ZWW - 在IOS8.1-iPhone5部分设备下有BUG故此没有使用这个方法
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZWEAKSELF
//    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                                             title:kDelete
//                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                           {
//                                               XMCacheTrack *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
//                                               if (weakSelf.onDeleteClick) {
//                                                   weakSelf.onDeleteClick(model);
//                                               }
//                                           }];
//    [editRowAction setBackgroundColor:COLORDELETE];
//    return @[editRowAction];
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZDownloadingItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZDownloadingItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    __weak typeof(XMCacheTrack) *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnDownloadButtonClick:^(XMCacheTrackStatus status, NSInteger row) {
        if (weakSelf.onDownloadButtonClick) {
            weakSelf.onDownloadButtonClick(status, row);
        }
    }];
    return cell;
}

@end
