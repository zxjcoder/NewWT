//
//  ZDownloadEndTableView.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"
#import "XMCacheTrack.h"

@interface ZDownloadEndTableView : UIView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(NSArray *array, NSInteger row);
///删除点击
@property (copy, nonatomic) void(^onDeleteClick)(XMCacheTrack *model);
///删除多个点击
@property (copy, nonatomic) void(^onDeleteMultipleClick)(NSArray *array);

///设置无按钮背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;

/// 获取选中对象集合
-(NSArray *)getCheckArray;
///设置是否开始勾选
-(void)setStartChecked:(BOOL)check;
///添加刷新顶部功能
-(void)addRefreshHeaderWithEndBlock:(void (^)(void))refreshBlock;
///结束顶部刷新
-(void)endRefreshHeader;
///移除顶部刷新
-(void)removeRefreshHeader;
///设置是否点击状态栏回到顶部
-(void)setScrollsToTop:(BOOL)isTop;

@end
