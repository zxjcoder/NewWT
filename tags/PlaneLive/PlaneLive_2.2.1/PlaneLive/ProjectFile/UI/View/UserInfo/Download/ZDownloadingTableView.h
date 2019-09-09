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

///下载点击
@property (copy, nonatomic) void(^onDownloadClick)(XMCacheTrack *model);
///删除点击
@property (copy, nonatomic) void(^onDeleteClick)(XMCacheTrack *model);
///设置无按钮背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;
///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);
/// 设置下载进度
-(void)setDownloadProgress:(double)progress model:(XMTrack *)model;
/// 设置下载按钮状态
-(void)setDownloadButtonImage:(XMCacheTrackStatus)status model:(XMTrack *)model;
/// 设置下载开始状态
-(void)setStartDownloadWithModel:(XMTrack *)model;
/// 设置下载停止状态
-(void)setStopDownloadWithModel:(XMTrack *)model;

@end
