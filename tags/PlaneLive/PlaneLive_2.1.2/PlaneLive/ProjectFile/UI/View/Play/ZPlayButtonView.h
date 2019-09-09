//
//  ZPlayButtonView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/6.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

#define kZPlayButtonViewHeight 40

///点赞,收藏,下载
@interface ZPlayButtonView : ZView

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZPlayTabBarViewType)type;

@property (copy, nonatomic) void(^onPracticePraiseClick)(ModelPractice *model);
@property (copy, nonatomic) void(^onCurriculumPraiseClick)(ModelCurriculum *model);
@property (copy, nonatomic) void(^onPracticeCollectionClick)(ModelPractice *model);
@property (copy, nonatomic) void(^onCurriculumCollectionClick)(ModelCurriculum *model);
@property (copy, nonatomic) void(^onDownloadClick)(ZDownloadStatus type);
///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;
///设置数据源
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model;
/// 设置播放按钮状态
-(void)setDownloadButtonImageNoSuspend:(ZDownloadStatus)status;

@end
