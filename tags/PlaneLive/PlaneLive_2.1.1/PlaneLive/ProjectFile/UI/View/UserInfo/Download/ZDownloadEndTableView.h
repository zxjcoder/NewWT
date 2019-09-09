//
//  ZDownloadEndTableView.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZDownloadEndTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(NSArray *array, NSInteger row);

///选中点击
@property (copy, nonatomic) void(^onCheckedClick)(BOOL check, NSInteger row, NSInteger selCount, BOOL isMaxSel);

///删除点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelAudio *model, int maxCount);

///设置无按钮背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

/// 获取选中对象集合
-(NSArray *)getCheckArray;

/// 获取数据数量
-(NSInteger)getDataCount;

/// 设置是否开始勾选
-(void)setStartChecked:(BOOL)check;

/// 设置是否选中全部
-(void)setCheckedAll:(BOOL)check;

@end
