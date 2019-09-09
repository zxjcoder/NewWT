//
//  ZPlayViewController.h
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "ZPlayTabBarView.h"

@interface ZPlayViewController : ZBaseViewController

///单例模式
+ (ZPlayViewController *)sharedSingleton;

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

///停止播放
-(void)stop;

///是否在播放中
-(BOOL)isStartPlaying;

///获取播放中的列表
-(NSArray *)getPlayDataArray;

///远程控制播放器
- (void)setPlayRemoteControlReceivedWithEvent:(UIEvent *)event;

///设置网络状况
- (void)setNetworkReachabilityStatus:(ZNetworkReachabilityStatus)status;

@end
