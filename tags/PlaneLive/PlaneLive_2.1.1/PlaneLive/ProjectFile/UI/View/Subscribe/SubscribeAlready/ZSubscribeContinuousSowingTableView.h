//
//  ZSubscribeContinuousSowingTableView.h
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

///连续播
@interface ZSubscribeContinuousSowingTableView : ZBaseTableView

///课程每一期的内容
@property (copy, nonatomic) void(^onCurriculumClick)(NSArray *array, NSInteger row);

///内容高度改变
@property (copy, nonatomic) void(^onTableViewHeightChange)(CGFloat height);

@end