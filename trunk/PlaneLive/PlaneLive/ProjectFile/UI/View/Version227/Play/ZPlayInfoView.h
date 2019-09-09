//
//  ZPlayInfoView.h
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayInfoView : ZView

/// 播放||暂停
@property (copy, nonatomic) void(^onPlayClick)(BOOL isPlay);
/// 下一首
@property (copy, nonatomic) void(^onNextClick)();
/// 上一首
@property (copy, nonatomic) void(^onPreClick)();
/// 列表
@property (copy, nonatomic) void(^onListClick)();
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

-(void)setViewTabType:(ZPlayTabBarViewType)type;
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled;
/// 恢复到默认的偏移
-(void)setContentDefaultOffX;
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
/// 设置总时长
-(void)setTotalDuration:(NSInteger)duration;
/// 设置缓冲进度
-(void)setViewCacheProgress:(CGFloat)progress;
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent;
/// 设置微课数据
-(void)setViewDataWithPracitce:(ModelPractice *)model;
/// 设置订阅数据
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model;

@end
