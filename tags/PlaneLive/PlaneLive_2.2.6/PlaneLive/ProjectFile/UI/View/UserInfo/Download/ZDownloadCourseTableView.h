//
//  ZDownloadCourseTableView.h
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTableView.h"

/// 下载 微课-系列课-培训课
@interface ZDownloadCourseTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(NSArray *array, NSInteger row);
///选中改变
@property (copy, nonatomic) void(^onCheckChange)(BOOL isAll, NSInteger count);
///删除点击
@property (copy, nonatomic) void(^onDeleteClick)(XMCacheTrack *model);

///设置无按钮背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;
///添加一个已经完成的对象
-(void)addViewData:(XMCacheTrack*)model;
///删除一个已经完成的对象
-(void)removeViewData:(XMCacheTrack*)model;
/// 批量设置选中状态
-(void)setStartCheckAll:(BOOL)checkAll;
///设置是否开始勾选
-(void)setStartChecking:(BOOL)check;
/// 获取选中对象集合
-(NSArray *)getCheckArray;
/// 获取全部对象集合
-(NSArray *)getAllArray;
/// 获取全部对象集合数量
-(NSInteger)getAllArrayCount;

@end
