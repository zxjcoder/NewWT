//
//  ZNewSubscribeAlreadyHasContentTVC.h
//  PlaneLive
//
//  Created by WT on 02/04/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZNewSubscribeAlreadyHasCourseTVC : ZBaseTVC

///内容X偏移改变
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat offsetX);
///内容索引改变
@property (copy, nonatomic) void(^onPageChange)(CGFloat index);
///CELL高度改变
@property (copy, nonatomic) void(^onCellHeightChange)(CGFloat cellHeight);
/// 播放按钮点击
@property (copy, nonatomic) void(^onStopPlayClick)(ModelCurriculum *model);
/// 课件详情点击
@property (copy, nonatomic) void(^onCourseClick)(ModelCurriculum *model);
/// 下载状态点击
@property (copy, nonatomic) void(^onDownloadClick)(NSInteger row, ModelCurriculum *model);
///课程列表Item
@property (copy, nonatomic) void(^onCourseItemClick)(NSArray *array, NSInteger index);

/// 设置默认索引
-(void)setPageIndex:(NSInteger)page;
/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model;
/// 设置数据源
-(void)setViewDataWithArray:(NSArray *)array isHeader:(BOOL)isHeader;
///设置是否播放中
-(void)setIsPlayStatus:(BOOL)status rowModel:(ModelCurriculum *)rowModel;
///设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row;
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row;

@end
