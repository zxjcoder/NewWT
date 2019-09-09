//
//  ZPlayFunctionView.h
//  PlaneLive
//
//  Created by Daniel on 07/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

#define kZPlayFunctionViewHeight 145

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
@property (copy, nonatomic) void(^onSliderValueChange)(float sliderValue, float maxValue);

///播放倍率改变
@property (copy, nonatomic) void(^onRateChange)(float rate);

///下载按钮
@property (copy, nonatomic) void(^onDownloadClick)(ZDownloadStatus status);

/// 停止播放
-(void)setStopPlay;
/// 开始播放
-(void)setStartPlay;
/// 暂停播放
-(void)setPausePlay;
/// 设置播放进度
-(void)setViewProgress:(CGFloat)progress;
/// 设置播放时间
-(void)setViewCurrentTime:(NSTimeInterval)currentTime;
/// 设置最大滑动值
-(void)setMaxDuratuin:(NSTimeInterval)duration;
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled;
/// 设置播放按钮状态
-(void)setDownloadButtonImage:(ZDownloadStatus)status;
/// 设置播放按钮状态-无暂停状态
-(void)setDownloadButtonImageNoSuspend:(ZDownloadStatus)status;
/// 设置下载进度
-(void)setDownloadProgress:(CGFloat)progress;

@end
