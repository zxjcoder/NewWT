//
//  ZSubscribeAlreadyHasTableView.h
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

///试读TV
@interface ZSubscribeAlreadyNoTableView : ZBaseTableView

///数据点击事件
@property (copy, nonatomic) void(^onCurriculumClick)(ModelCurriculum *model);

@end
