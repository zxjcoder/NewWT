//
//  ZPlayerViewController.h
//  PlaneLive
//
//  Created by Daniel on 08/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "PlayerManager.h"
#import "ModelTrack.h"

#define kPlayerVCViewTag 101

@interface ZPlayerViewController : ZBaseViewController

///单例模式
+ (ZPlayerViewController *)sharedSingleton;
/////播放进度
//@property (copy, nonatomic) void(^onTrackPlayNotifyProcess)(CGFloat percent, NSUInteger currentSecond);
/////数据缓冲
//@property (copy, nonatomic) void(^onTrackPlayNotifyCacheProcess)(CGFloat percent);
/////读取出错回调
//@property (copy, nonatomic) void(^onTrackPlayFailed)(NSError *error);
/////开始播放
//@property (copy, nonatomic) void(^onTrackWillPlaying)(NSInteger duration);
/////播放状态更改
//@property (copy, nonatomic) void(^onTrackPlayStatusChange)(BOOL isPlaying);
/////播放下一首
//@property (copy, nonatomic) void(^onPlayNextChange)(ModelTrack *model, NSInteger rowIndex);
/////培训课,系列课播放改变
//@property (copy, nonatomic) void(^onPlayCourseChange)(ModelCurriculum *model, BOOL isPlaying);
/////写留言
//@property (copy, nonatomic) void(^onWriteMessageEvent)(ModelCurriculum *model);
///课件点击 - 微课或系列课或订阅
//@property (copy, nonatomic) void(^onCoursewareEvent)(id model);
///课程详情 - 微课或系列课或订阅
//@property (copy, nonatomic) void(^onCourseDetailEvent)(ZPlayTabBarViewType type, id model);
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
///是否添加到容器
@property (nonatomic, assign) BOOL isAddWindow;

///是否在播放中
-(BOOL)isPlaying;
///开始播放
-(void)setStartPlay;
///停止播放
-(void)setStopPlay;
///暂停播放
-(void)setPausePlay;
///恢复播放
-(void)setResumePlay;
///上一首
-(void)playPrevTrack;
///下一首
-(void)playNextTrack;
///改变播放位置
-(void)setPlaySliderValue:(CGFloat)value;
///设置数据源
-(void)setRawdataWithArray:(NSArray *)array index:(NSInteger)index;
///设置播放功能按钮 必须在填充数据之前调用
-(void)setInnerPlayTabbarWithType:(ZPlayTabBarViewType)type;
///删除下载对象
-(void)setDeleteDownloadWithModel:(XMCacheTrack *)model;
/// 设置当前播放语音的效果
- (void)setNowPlayingInfo;

@end