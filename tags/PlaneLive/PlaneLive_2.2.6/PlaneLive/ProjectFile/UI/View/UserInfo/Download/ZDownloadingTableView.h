//
//  ZDownloadingTableView.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"
#import "XMCacheTrack.h"

@interface ZDownloadingTableView : ZBaseTableView

///下载按钮点击
@property (copy, nonatomic) void(^onDownloadButtonClick)(XMCacheTrackStatus status, NSInteger row);
///侧滑删除
@property (copy, nonatomic) void(^onDeleteClick)(XMCacheTrack *model);

///设置无按钮背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;

/// 移除对象
-(void)setDownloadRemoveObject:(XMTrack *)model;
/// 设置下载按钮状态
-(void)setDownloadButtonImage:(XMCacheTrackStatus)status row:(NSInteger)row;
/// 设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row;

@end
