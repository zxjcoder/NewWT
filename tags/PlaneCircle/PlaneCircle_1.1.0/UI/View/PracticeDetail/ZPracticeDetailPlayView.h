//
//  ZPracticeDetailPlayView.h
//  PlaneCircle
//
//  Created by Daniel on 6/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"
#import "ModelEntity.h"

@interface ZPracticeDetailPlayView : ZView

///评论
@property (copy, nonatomic) void(^onCommentClick)();
///上5秒
@property (copy, nonatomic) void(^onPreClick)(CGFloat value, CGFloat ratio);
///下5秒
@property (copy, nonatomic) void(^onNextClick)(CGFloat value, CGFloat ratio);
///停止
@property (copy, nonatomic) void(^onStopClick)();
///播放
@property (copy, nonatomic) void(^onPlayClick)();
///拖动
@property (copy, nonatomic) void(^onSlideValueChanged)(CGFloat ratio);

///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;
///设置播放到什么位置
-(void)setSliderValue:(CGFloat)ratio;
///隐藏显示功能键
-(void)setShowPreOrNextButton:(BOOL)isShow;

///开始播放
-(void)setStartPlay;
///停止播放
-(void)setStopPlay;
///缓冲中
-(void)setWaitingPlay;

///上5秒播放
-(void)setPrePlay;
///下5秒播放
-(void)setNextPlay;

@end
