//
//  ZCircleSearchContentTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleTableView.h"

@interface ZCircleSearchContentTableView : ZCircleTableView

///选中话题事件
@property (copy, nonatomic) void(^onTagSelected)(ModelTag *model);
///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleSearchContent *model);
///开始滑动
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

@end
