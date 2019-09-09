//
//  ZPayCartTableView.h
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPayCartTableView : ZBaseTableView

///删除点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelPayCart *model);
///选中改变
@property (copy, nonatomic) void(^onCheckedClick)(BOOL check, NSInteger row, NSInteger selCount, BOOL isMaxSel, CGFloat selMaxPrice);

///设置是否全选
-(void)setCheckedAll:(BOOL)checkAll;

///设置数据源
-(void)setViewDataWithArray:(NSArray *)arrResult;

///获取勾选微课
-(NSArray *)getCheckArray;
///获取微课
-(NSArray *)getMainArray;
///移除数据集合
-(void)removeDataWithArray:(NSArray *)array;

@end
