//
//  ZPlaybackProgressView.h
//  PlaneLive
//
//  Created by Daniel on 03/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlaybackProgressView : ZView

///播放
@property (copy, nonatomic) void(^onPlayClick)();
///暂停
@property (copy, nonatomic) void(^onStopClick)();
///播放进度改变
@property (copy, nonatomic) void(^onSliderValueChange)(CGFloat sliderValue);

/// 停止播放
-(void)setStopPlay;
/// 开始播放
-(void)setStartPlay;
/// 暂停播放
-(void)setPausePlay;
/// 设置总时长
-(void)setTotalDuration:(NSInteger)duration;
/// 设置缓冲进度
-(void)setViewProgress:(CGFloat)progress;
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent;

@end
