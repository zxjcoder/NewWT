//
//  ZPlayerViewController.h
//  PlaneLive
//
//  Created by Daniel on 08/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "XMSDK.h"
#import "ModelTrack.h"

@interface ZPlayerViewController : ZBaseViewController<XMTrackPlayerDelegate>

///单例模式
+ (ZPlayerViewController *)sharedSingleton;
///播放进度
@property (copy, nonatomic) void(^onTrackPlayNotifyProcess)(CGFloat percent, NSUInteger currentSecond);
///数据缓冲
@property (copy, nonatomic) void(^onTrackPlayNotifyCacheProcess)(CGFloat percent);
///读取出错回调
@property (copy, nonatomic) void(^onTrackPlayFailed)(NSError *error);
///开始播放
@property (copy, nonatomic) void(^onTrackWillPlaying)(NSInteger duration);
///本地播放对象
@property (nonatomic, strong) ModelTrack *modelTrack;
///实务
@property (strong, nonatomic) ModelPractice *modelPractice;
///订阅
@property (strong, nonatomic) ModelCurriculum *modelCurriculum;
///转换后的数据集合
@property (nonatomic, strong) NSArray *arrayTrack;
///原数据
@property (nonatomic, strong) NSArray *arrayRawdata;
///当前播放索引
@property (nonatomic, assign) NSInteger playIndex;

///是否在播放中
-(BOOL)isPlaying;
///开始播放
-(void)setStartPlay;
///暂停播放
-(void)setPausePlay;
///恢复播放
-(void)setResumePlay;
///上一首
-(void)btnPreClick;
///下一首
-(void)btnNextClick;
///改变播放位置
-(void)setPlaySliderValue:(CGFloat)value;
///设置数据源
-(void)setRawdataWithArray:(NSArray *)array index:(NSInteger)index;
///设置播放功能按钮 必须在填充数据之前调用
-(void)setInnerPlayTabbarWithType:(ZPlayTabBarViewType)type;
///删除下载对象
-(void)setDeleteDownloadWithModel:(XMCacheTrack *)model;

@end
