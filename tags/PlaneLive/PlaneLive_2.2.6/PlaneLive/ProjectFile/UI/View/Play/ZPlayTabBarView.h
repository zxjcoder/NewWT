//
//  ZPlayTabBarView.h
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

#define kZPlayTabBarViewHeight 55

@interface ZPlayTabBarView : ZView

///初始化
-(instancetype)initWithPoint:(CGPoint)point;

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZPlayTabBarViewType)type;

///提问点击事件
@property (copy, nonatomic) void(^onQuestionClick)(ModelPractice *model);
///问答点击事件
@property (copy, nonatomic) void(^onAnswerClick)(ModelPractice *model);
///Pratice-文本点击事件
@property (copy, nonatomic) void(^onPracticeNoteClick)(ModelPractice *model);
///Pratice-ppt点击事件
@property (copy, nonatomic) void(^onPracticePPTClick)(ModelPractice *model);
///Curriculum-文本点击事件
@property (copy, nonatomic) void(^onCurriculumNoteClick)(ModelCurriculum *model);
///Curriculum-ppt点击事件
@property (copy, nonatomic) void(^onCurriculumPPTClick)(ModelCurriculum *model);
///收藏点击事件
@property (copy, nonatomic) void(^onCollectionClick)(ModelPractice *model);
///点赞点击事件
@property (copy, nonatomic) void(^onPauseClick)(ModelPractice *model);
///播放列表点击事件
@property (copy, nonatomic) void(^onPlayCurriculumClick)();
///播放列表点击事件
@property (copy, nonatomic) void(^onPlayPracticeClick)();

///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;
///设置数据源
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model;

/// 设置PPT按钮是否可点
-(void)setButtonPPTEnabled:(BOOL)isEnabled;

/// 设置按钮是否可点
-(void)setButtonAllEnabled:(BOOL)isEnabled;

@end
