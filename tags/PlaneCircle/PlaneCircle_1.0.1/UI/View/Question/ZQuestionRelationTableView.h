//
//  ZQuestionRelationTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleTableView.h"

///问题关联View
@interface ZQuestionRelationTableView : ZCircleTableView

///话题选中
@property (copy, nonatomic) void(^onTagSelected)(ModelTag *model);
///问题选择
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleSearchContent *model);

///开始滑动
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;

@end
