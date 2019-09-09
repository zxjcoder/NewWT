//
//  ZDownloadItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "XMCacheTrack.h"

@interface ZDownloadItemTVC : ZBaseTVC

///下载点击
@property (copy, nonatomic) void(^onDownloadClick)(XMCacheTrackStatus status, NSInteger row);

///选中点击
@property (copy, nonatomic) void(^onCheckedClick)(BOOL check, NSInteger row);

///设置下载按钮隐藏
-(void)setDownloadButtonHidden:(BOOL)hidden;
///设置数据源
-(CGFloat)setCellDataWithModel:(XMCacheTrack *)model;
///下载状态改变
-(void)setChangeDownloadStatusWithModel:(XMCacheTrack *)model;
///下载状态改变
-(void)setChangeDownloadStatusWithStatus:(XMCacheTrackStatus)status;
/// 是否选中
-(BOOL)isChecked;

///设置选中状态
-(void)setCheckedStatus:(BOOL)isCheck;

/// 显示勾选按钮
-(void)setCheckShow:(BOOL)showCheck;

/// 设置播放按钮状态
-(void)setDownloadButtonImage:(XMCacheTrackStatus)status;
/// 获取播放按钮状态
-(ZDownloadStatus)getDownloadStatus;
/// 设置下载进度
-(void)setDownloadProgress:(double)progress;
/// 设置停止下载文字内容
-(void)setStopDownload;
/// 设置开始下载文字内容
-(void)setStartDownload;

@end
