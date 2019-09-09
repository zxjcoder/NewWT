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
-(void)setDownloadRemoveWithIndex:(NSInteger)row
{
    if (self.arrMain.count > row) {
        [self.arrMain removeObjectAtIndex:row];
    }
    if (self.arrMain && self.arrMain.count > 0) {
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateNull)];
    }
    [self reloadData];
}
/// 设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row
{
    if (self.arrMain.count > row) {
        XMCacheTrack *rowModel = [self.arrMain objectAtIndex:row];
        rowModel.status = XMCacheTrackStatusDownloading;
        rowModel.updatedAt = progress;
        [self reloadData];
    }
}
/// 设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row
{
    if (self.arrMain.count > row) {
        XMCacheTrack *rowModel = [self.arrMain objectAtIndex:row];
        rowModel.status = status;
        [self reloadData];
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
    XMCacheTrack *modelT = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelT];
    [cell setDownloadStatus:(modelT.status)];
    //设置下载状态和进度
    if (modelT.updatedAt > 0) {
        [cell setDownloadProgress:modelT.updatedAt];
    } else {
        if (modelT.downloadedBytes && modelT.totalBytes > 0) {
            [cell setDownloadProgress:modelT.downloadedBytes/modelT.totalBytes];
        } else {
            [cell setDownloadProgress:0];
        }
    }
    ZWEAKSELF
    [cell setOnDownloadClick:^(NSInteger row, XMCacheTrack *model) {
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick(row, model);
        }
    }];
    return cell;
}

@end
