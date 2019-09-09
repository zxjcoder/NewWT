//
//  ZNewSubscribeAlreadyHasItemTVC.h
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 已购系列课,培训课 课程列表Item TVC
@interface ZNewSubscribeAlreadyHasItemTVC : ZBaseTVC

/// 播放按钮点击
@property (copy, nonatomic) void(^onStopPlayClick)(ModelCurriculum *model);
/// 播放按钮点击
@property (copy, nonatomic) void(^onStartPlayClick)(NSInteger row);
/// 课件详情点击
@property (copy, nonatomic) void(^onCourseClick)(ModelCurriculum *model);
/// 下载状态点击
@property (copy, nonatomic) void(^onDownloadClick)(NSInteger row, ModelCurriculum *model);

///设置数据源
-(CGFloat)setCellDataWithModel:(ModelCurriculum *)model;

///设置是否播放中
-(void)setIsPlayStatus:(BOOL)status;
///设置下载进度
-(void)setDownloadProgress:(double)progress;
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status;

@end
