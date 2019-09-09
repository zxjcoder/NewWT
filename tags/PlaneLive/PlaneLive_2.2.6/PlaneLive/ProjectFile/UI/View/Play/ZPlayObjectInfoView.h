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
///课件点击事件
@property (copy, nonatomic) void(^onTextClick)();
///PPT点击事件
@property (copy, nonatomic) void(^onPPTClick)();

/// 设置微课数据
-(void)setViewDataWithPracitce:(ModelPractice *)model;

/// 设置订阅数据
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model;

/// 恢复到默认的偏移
-(void)setContentDefaultOffX;

/// 图片大小
+(CGFloat)getViewImageHeight;

@end
