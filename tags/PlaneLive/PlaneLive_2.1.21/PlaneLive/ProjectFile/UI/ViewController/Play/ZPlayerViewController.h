//
//  ZPlayerViewController.h
//  PlaneLive
//
//  Created by Daniel on 08/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "ZPlayTabBarView.h"

@interface ZPlayerViewController : ZBaseViewController

///单例模式
+ (ZPlayerViewController *)sharedSingleton;

/**
 *  播放器数据传入-实务
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)setViewPlayArray:(NSArray *)array index:(NSInteger)index;
/**
 *  播放器数据传入-订阅
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)setViewPlayWithCurriculumArray:(NSArray *)array index:(NSInteger)index;

///设置播放功能按钮 必须在填充数据之前调用
-(void)setInnerPlayTabbarWithType:(ZPlayTabBarViewType)type;
///获取播放功能按钮 必须在填充数据之前调用
-(ZPlayTabBarViewType)getInnerPlayTabbarWithType;

///获取播放中的对象
-(ModelAudio *)getPlayingModelAudio;

/// 写入播放时间到文件
-(void)setPlayTimeToFile;
///开始播放
-(void)setStartPlay;
///暂停播放
-(void)setPausePlay;

///是否在播放中
-(BOOL)isStartPlaying;

///获取播放中的列表
-(NSArray *)getPlayDataArray;

///远程控制播放器
- (void)setPlayRemoteControlReceivedWithEvent:(UIEvent *)event;

///设置网络状况
- (void)setNetworkReachabilityStatus:(ZNetworkReachabilityStatus)status;

///获取网络状况
- (ZNetworkReachabilityStatus)getNetworkReachabilityStatus;

@end
