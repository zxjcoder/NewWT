//
//  ZPurchasePracticeTableView.h
//  PlaneLive
//
//  Created by Daniel on 15/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPurchasePracticeTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(NSArray *array, NSInteger row);

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

@end
