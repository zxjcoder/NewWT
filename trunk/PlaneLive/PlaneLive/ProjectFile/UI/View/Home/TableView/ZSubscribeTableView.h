//
//  ZSubscribeTableView.h
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZSubscribeTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelSubscribe *model);

///设置无背景的数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader backState:(ZBackgroundState)backState;

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

@end
