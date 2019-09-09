//
//  ZCircleSearchUserTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZCircleSearchUserTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelUserBase *model);

///开始滑动
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

@end
