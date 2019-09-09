//
//  ZPlayMainView.h
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayMainView : ZView

/// 播放
@property (copy, nonatomic) void(^onPlayClick)(BOOL isPlay);
/// 下一首
@property (copy, nonatomic) void(^onNextClick)();
/// 上一首
@property (copy, nonatomic) void(^onPreClick)();
/// 列表
@property (copy, nonatomic) void(^onListClick)();
/// 加倍
@property (copy, nonatomic) void(^onSpeedClick)();
/// 邮件
@property (copy, nonatomic) void(^onMailClick)();
/// PPT
@property (copy, nonatomic) void(^onPPTClick)();
/// 课程详情
@property (copy, nonatomic) void(^onDetailClick)();
/// 拖动播放进度
@property (copy, nonatomic) void(^onSliderValueChange)(CGFloat sliderValue);
///播放倍率改变
@property (copy, nonatomic) void(^onRateChange)(float rate);
@property (copy, nonatomic) void(^onCloseViewEvent)(ZPlayMainView *view);
@property (copy, nonatomic) void(^onShareViewEvent)();
@property (copy, nonatomic) void(^onCollectionEvent)(ZPlayTabBarViewType type, BOOL isCollection, NSString *ids);
@property (copy, nonatomic) void(^onDownloadClick)(ZDownloadStatus status);
@property (copy, nonatomic) void(^onCoursewareEvent)();
@property (copy, nonatomic) void(^onMessageEvent)();
@property (copy, nonatomic) void(^onRewardEvent)(ZPlayTabBarViewType type);

/// 设置类型
-(void)setTabType:(ZPlayTabBarViewType)type;
/// 设置微课数据
-(void)setViewDataWithPracitce:(ModelPractice *)model;
/// 设置订阅数据
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model;
/// 设置微课数据
-(void)setTabViewDataWithPracitce:(ModelPractice *)model;
/// 设置订阅数据
-(void)setTabViewDataWithSubscribe:(ModelCurriculum *)model;
/// 设置当前索引
-(void)setPageChange:(NSInteger)index total:(NSInteger)total;
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled;
/// 设置缓冲进度
-(void)setViewCacheProgress:(CGFloat)progress;
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent;
/// 设置最大播放时间
-(void)setMaxDuratuin:(NSUInteger)duration;
/// 获取当前倍率播放
-(CGFloat)getRate;
/// 状态是否播放中
-(BOOL)isPlaying;
/// 停止播放
-(void)setStopPlay;
/// 开始播放
-(void)setStartPlay;
/// 暂停播放
-(void)setPausePlay;
/// 设置播放按钮状态
-(void)setDownloadButtonImageNoSuspend:(ZDownloadStatus)status;

-(void)show;
-(void)dismiss;

@end
