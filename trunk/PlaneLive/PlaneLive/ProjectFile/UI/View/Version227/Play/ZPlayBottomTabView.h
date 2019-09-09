//
//  ZPlayBottomTabView.h
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayBottomTabView : ZView

/// 收藏
@property (copy, nonatomic) void(^onCollectionEvent)(ZPlayTabBarViewType type, BOOL isCollection, NSString *ids);
/// 下载
@property (copy, nonatomic) void(^onDownloadEvent)(ZDownloadStatus status);
/// 课件
@property (copy, nonatomic) void(^onCoursewareEvent)();
/// 留言
@property (copy, nonatomic) void(^onMessageEvent)();
/// 打赏
@property (copy, nonatomic) void(^onRewardEvent)(ZPlayTabBarViewType type);

/// 初始化
-(id)initWithFrame:(CGRect)frame type:(ZPlayTabBarViewType)type;
/// 设置类型
-(void)setViewTabType:(ZPlayTabBarViewType)type;
/// 设置下载状态
-(void)setDownloadStatus:(ZDownloadStatus)status;
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled;
///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;
///设置数据源
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model;

+(CGFloat)getH;

@end
