//
//  ZNewSubscribeAlreadyHasCourseTableView.h
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTableView.h"

/// 课程列表
@interface ZNewSubscribeAlreadyHasCourseTableView : ZBaseTableView

/// 课程列表高度改变
@property (copy, nonatomic) void(^onViewHeightChange)(CGFloat height);
/// 播放按钮点击
@property (copy, nonatomic) void(^onStopPlayClick)(ModelCurriculum *model);
/// 课件详情点击
@property (copy, nonatomic) void(^onCourseClick)(ModelCurriculum *model);
/// 下载状态点击
@property (copy, nonatomic) void(^onDownloadClick)(NSInteger row, ModelCurriculum *model);
///课程列表Item
@property (copy, nonatomic) void(^onItemClick)(NSArray *array, NSInteger index);

/// 设置数据源
-(CGFloat)setViewDataWithArray:(NSArray *)array isHeader:(BOOL)isHeader;

///设置是否播放中
-(void)setIsPlayStatus:(BOOL)status rowModel:(ModelCurriculum *)rowModel;
///设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row;
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row;

@end
