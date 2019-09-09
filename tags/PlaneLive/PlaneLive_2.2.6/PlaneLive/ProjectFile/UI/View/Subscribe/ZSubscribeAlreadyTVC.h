//
//  ZSubscribeAlreadyTVC.h
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZSubscribeAlreadyTVC : ZBaseTVC

///数据点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelCurriculum *model, int unReadCount);

@end
