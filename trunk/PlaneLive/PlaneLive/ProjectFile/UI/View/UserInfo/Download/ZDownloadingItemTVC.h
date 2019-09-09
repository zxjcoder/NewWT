//
//  ZDownloadingItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "XMCacheTrack.h"

@interface ZDownloadingItemTVC : ZBaseTVC

/// 下载状态点击
@property (copy, nonatomic) void(^onDownloadClick)(NSInteger row, XMCacheTrack *model);

///设置数据源
-(CGFloat)setCellDataWithModel:(XMCacheTrack *)model;

///设置下载进度
-(void)setDownloadProgress:(double)progress;
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status;

@end
