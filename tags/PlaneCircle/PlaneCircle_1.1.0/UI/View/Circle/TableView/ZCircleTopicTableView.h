//
//  ZCircleTopicTableView.h
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZCircleTopicTableView : ZBaseTableView

///全部按钮点击
@property (copy, nonatomic) void(^onAllClick)(ModelTagType *model);
///话题点击
@property (copy, nonatomic) void(^onItemClick)(ModelTag *model);

@end
