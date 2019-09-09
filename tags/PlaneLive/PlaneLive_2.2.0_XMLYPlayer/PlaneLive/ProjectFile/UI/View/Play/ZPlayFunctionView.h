//
//  ZPlayFunctionView.h
//  PlaneLive
//
//  Created by Daniel on 07/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

#define kZPlayFunctionViewHeight 120

@interface ZPlayFunctionView : ZView

///初始化
-(instancetype)initWithPoint:(CGPoint)point;

///上一个
@property (copy, nonatomic) void(^onPreClick)();
///下一个
@property (copy, nonatomic) void(^onNextClick)();
///播放
@property (copy, nonatomic) void(^onPlayClick)();
///暂停
@property (copy, nonatomic) void(^onStopClick)();
///播放进度改变
@property (copy, nonatomic) void(^onSliderValueChange)(CGFloat sliderValue);
///播放倍率改变
@property (copy, nonatomic) void(^onRateChange)(float rate);
///播放列表
@property (copy, nonatomic) void(^onListClick)();

/// 停止播放
-(void)setStopPlay;
/// 开始播放
-(void)setStartPlay;
/// 暂停播放
-(void)setPausePlay;
/// 设置缓冲进度
-(void)setViewProgress:(CGFloat)progress;
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent;
/// 设置最大播放时间
-(void)setMaxDuratuin:(NSUInteger)duration;
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled;

@end
