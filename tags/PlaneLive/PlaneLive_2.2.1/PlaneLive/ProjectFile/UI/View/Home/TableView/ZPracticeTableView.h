//
//  ZPracticeTableView.h
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPracticeTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(NSArray *array, NSInteger row);

///设置无背景的数据集合
-(void)setViewDataBackNoneWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

-(void)setPayPracticeSuccess:(ModelPractice *)model;

@end
