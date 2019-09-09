//
//  ZSubscribeAlreadyTableView.h
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

//已订阅TV
@interface ZSubscribeAlreadyTableView : ZBaseTableView

///数据点击事件
@property (copy, nonatomic) void(^onCurriculumClick)(ModelCurriculum *model);

///数据点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelCurriculum *model);

///设置没有登录状态
-(void)setViewNoLoginState;

@end
