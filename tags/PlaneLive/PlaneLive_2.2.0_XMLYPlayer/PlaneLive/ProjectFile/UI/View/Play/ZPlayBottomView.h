//
//  ZPlayBottomView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/6.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

#define kZPlayBottomViewHeight 55

///底部功能按钮
@interface ZPlayBottomView : ZView

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZPlayTabBarViewType)type;

///问答点击事件
@property (copy, nonatomic) void(^onAnswerClick)(ModelPractice *model);
///实务打赏
@property (copy, nonatomic) void(^onPracticeRewardClick)(ModelPractice *model);
///课程内容打赏
@property (copy, nonatomic) void(^onCurriculumRewardClick)(ModelCurriculum *model);
///留言
@property (copy, nonatomic) void(^onMessageListClick)(ModelCurriculum *model);
///写留言
@property (copy, nonatomic) void(^onMessageWriteClick)(ModelCurriculum *model);

///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;
///设置数据源
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model;

/// 设置按钮是否可点
-(void)setButtonAllEnabled:(BOOL)isEnabled;

@end
