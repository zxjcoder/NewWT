//
//  ZDownloadingTableView.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZDownloadingTableView : ZBaseTableView

///下载点击
@property (copy, nonatomic) void(^onDownloadClick)(NSArray *array, NSInteger row);

///删除点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelAudio *model);

///设置无按钮背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

/// 开始下载
-(void)setStartDownloadWithModel:(ModelAudio *)model;
/// 暂停下载
-(void)setSuspendDownloadWithModel:(ModelAudio *)model;
/// 设置下载进度
-(void)setDownloadProgress:(CGFloat)progress model:(ModelAudio *)model;

@end
