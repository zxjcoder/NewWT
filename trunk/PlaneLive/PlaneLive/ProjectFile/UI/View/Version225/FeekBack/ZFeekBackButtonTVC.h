//
//  ZFeekBackButtonTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 底部按钮
@interface ZFeekBackButtonTVC : ZBaseTVC

///提交反馈点击
@property (copy, nonatomic) void(^onSubmitEvent)();

@end
