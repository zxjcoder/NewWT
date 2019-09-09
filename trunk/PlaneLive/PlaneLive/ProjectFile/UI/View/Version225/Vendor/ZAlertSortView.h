//
//  ZAlertSortView.h
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

///实务排序
@interface ZAlertSortView : ZView

///排序点击 0推荐 1最新 2热度
@property (copy, nonatomic) void(^onSortClick)(ZPracticeTypeSort sort);

///显示
-(void)show:(CGPoint)point;
///隐藏
-(void)dismiss;

@end
