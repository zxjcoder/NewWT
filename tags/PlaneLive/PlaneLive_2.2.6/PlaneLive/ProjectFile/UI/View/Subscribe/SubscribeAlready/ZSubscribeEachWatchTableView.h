//
//  ZSubscribeEachWatchTableView.h
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

///每期看
@interface ZSubscribeEachWatchTableView : ZBaseTableView

///课程每一期的内容
@property (copy, nonatomic) void(^onCurriculumClick)(ModelCurriculum *model);

///内容高度改变
@property (copy, nonatomic) void(^onTableViewHeightChange)(CGFloat height);

@end
