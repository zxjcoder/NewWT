//
//  ZCircleDynamicTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZCircleDynamicTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleDynamic *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCircleDynamic *model);

@end
