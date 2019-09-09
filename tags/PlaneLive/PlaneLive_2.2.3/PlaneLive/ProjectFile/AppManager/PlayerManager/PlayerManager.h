//
//  PlayerManager.h
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XMSDKPlayer.h"
#import "ModelTrack.h"
#import "XMSDK.h"

@protocol PlayerManagerDelegate <NSObject>

@optional
#pragma mark - process notification
//播放时被调用，频率为1s，告知当前播放进度和播放时间
- (void)trackPlayNotifyProcess:(CGFloat)percent currentSecond:(NSUInteger)currentSecond;
//播放时被调用，告知当前播放器的缓冲进度
- (void)trackPlayNotifyCacheProcess:(CGFloat)percent;

#pragma mark - player state change
//播放列表结束时被调用
- (void)trackPlayerDidPlaylistEnd;
//将要播放时被调用
- (void)trackPlayerWillPlaying;
//已经播放时被调用
- (void)trackPlayerDidPlaying;
//暂停时调用
- (void)trackPlayerDidPaused;
//停止时调用
- (void)trackPlayerDidStopped;
//结束播放时调用
- (void)trackPlayerDidEnd;
//播放失败时调用
- (void)trackPlayerDidFailedToPlayTrack:(XMTrack *)track withError:(NSError *)error;
//播放失败时是否继续播放下一首
- (BOOL)trackPlayerShouldContinueNextTrackWhenFailed:(XMTrack *)track;

//播放数据请求失败时调用，data.description是错误信息
- (void)trackPlayerDidErrorWithType:(NSString *)type withData:(NSDictionary*)data;
//- (void)trackPlayerDidErrorWithType:(NSInteger)type withData:(NSDictionary*)data;

@end

@interface PlayerManager : NSObject

+ (PlayerManager *)sharedPlayer;
///设置代理
-(void)setTrackPlayDelegate:(id<PlayerManagerDelegate>)delegate;
//播放状态
-(BOOL)isPlayering;
///设置倍率播放
-(void)setPlayRate:(float)rate;
/**
 * 播放声音列表
 */
- (void)playWithTrack:(XMTrack *)track playlist:(NSArray *)playlist;
/**
 * 接着播上一次正在播放的专辑
 */
- (void)continuePlayFromAlbum:(NSInteger)albumID track:(NSInteger)trackID;
/**
 * 暂停当前播放
 */
- (void)pauseTrackPlay;
/**
 * 恢复当前播放
 */
- (void)resumeTrackPlay;
/**
 * 停止当前播放
 */
- (void)stopTrackPlay;
/**
 * 更新当前播放列表
 */
- (void)replacePlayList:(NSArray *)playlist;
/**
 * 播放下一首
 */
- (BOOL)playNextTrack;
/**
 * 播放上一首
 */
- (BOOL)playPrevTrack;
/**
 * 返回当前播放列表
 */
- (NSArray *)playList;
/**
 * 返回下一首
 */
- (XMTrack *)nextTrack;
/**
 * 返回上一首
 */
- (XMTrack *)prevTrack;
/**
 * 设置播放器从特定的时间播放
 */
- (void)seekToTime:(CGFloat)percent;
/**
 * 清空缓存
 */
- (void)clearCacheSafely;
/**
 * 返回当前播放的声音
 */
- (XMTrack*)currentTrack;

/// 推送对象到屏幕上
+ (void)setNowPlayingInfoCenterWithTitle:(NSString *)title artist:(NSString *)artist artwork:(MPMediaItemArtwork *)artwork duration:(NSNumber*)duration currentTime:(NSNumber*)currentTime;

@end
