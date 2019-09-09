//
//  ZNewHomeTrainView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 热门培训
@interface ZNewHomeTrainView : ZView

///课程点击
@property (copy, nonatomic) void(^onCourseClick)(ModelSubscribe *model);
///更多点击
@property (copy, nonatomic) void(^onMoreClick)();
///描述点击
@property (copy, nonatomic) void(^onDescClick)();

-(CGFloat)setViewData:(NSArray *)array;

@end
