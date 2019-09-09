//
//  ZPlayObjectInfoView.h
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayObjectInfoView : ZView

/// 设置背景改变
@property (copy, nonatomic) void(^onBackgroundChange)(UIImage *image);

/// 设置实务数据
-(void)setViewDataWithPracitce:(ModelPractice *)model;

/// 设置订阅数据
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model;

@end
