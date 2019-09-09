//
//  ZNewSubscribeAlreadyHasMainView.h
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"
#import <ZPlayerKit/XMTrackDownloadStatus.h>

/// 系列课,培训课主页面
@interface ZNewSubscribeAlreadyHasMainView : ZView

/// 开始刷新顶部数据
@property (copy, nonatomic) void(^onRefreshCourseHeader)();
/// 开始刷新底部数据
@property (copy, nonatomic) void(^onRefreshCourseFooter)();

/// 播放按钮点击
@property (copy, nonatomic) void(^onDownloadAllClick)(NSArray *arrayCourse);
/// 播放按钮点击
@property (copy, nonatomic) void(^onStopPlayClick)(ModelCurriculum *model);
/// 课件详情点击
@property (copy, nonatomic) void(^onCourseClick)(ModelCurriculum *model);
/// 下载状态点击
@property (copy, nonatomic) void(^onDownloadClick)(NSInteger row, ModelCurriculum *model);
/// 课程列表Item
@property (copy, nonatomic) void(^onCourseItemClick)(NSArray *array, NSInteger index);

///设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row;
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row;
/// 设置是否播放中
-(void)setIsPlayStatus:(BOOL)status rowModel:(ModelCurriculum *)rowModel;
/// 设置背景状态
-(void)setViewBackgroundState:(ZBackgroundState)state;
/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model;
/// 设置课程列表数据源
-(void)setViewDataWithCourseArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

@end
