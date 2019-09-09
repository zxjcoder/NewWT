//
//  ZNewSubscribeAlreadyHasToolView.h
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

/// 系列课,培训课Tab工具栏 - 课程列表,课程简介
@interface ZNewSubscribeAlreadyHasToolView : ZView

/// 课程列表点击
@property (copy, nonatomic) void(^onListEvent)();
/// 课程简介点击
@property (copy, nonatomic) void(^onInfoEvent)();

/// 偏移x位置
-(void)setLineOffset:(CGFloat)offX;
/// 设置选中索引
-(void)setSelectIndex:(NSInteger)index;
+(CGFloat)getH;

@end
