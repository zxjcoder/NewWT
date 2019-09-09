//
//  PlayerManager.m
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "PlayerManager.h"

@interface PlayerManager()<XMTrackPlayerDelegate>

@property (nonatomic, weak) id<PlayerManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *dicMusicInfo;

@end

@implementation PlayerManager

static PlayerManager *_playerManagerInstance;
+ (PlayerManager *)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerManagerInstance = [[self alloc] init];
        [[XMSDKPlayer sharedPlayer] setAutoNexTrack:YES];
        [[XMSDKPlayer sharedPlayer] settingEnableBackgroundResumePlay];
    });
    return _playerManagerInstance;
}
-(void)dealloc
{
    self.delegate = nil;
    [[XMSDKPlayer sharedPlayer] setTrackPlayDelegate:nil];
}
///设置代理
-(void)setTrackPlayDelegate:(id<PlayerManagerDelegate>)delegate
{
    [self setDelegate:delegate];
    if (delegate) {
        [[XMSDKPlayer sharedPlayer] setTrackPlayDelegate:self];
    } else {
        [[XMSDKPlayer sharedPlayer] setTrackPlayDelegate:nil];
    }
}
/**
 * 播放声音列表
 */
- (void)playWithTrack:(XMTrack *)track playlist:(NSArray *)playlist
{
    [[XMSDKPlayer sharedPlayer] setPlayMode:XMSDKPlayModeTrack];
    [[XMSDKPlayer sharedPlayer] setTrackPlayMode:XMTrackPlayerModeList];
    [[XMSDKPlayer sharedPlayer] playWithTrack:track playlist:playlist];
}
//播放状态
-(BOOL)isPlayering
{
    XMSDKPlayerState state = [[XMSDKPlayer sharedPlayer] playerState];
    GBLog(@"playerState: %ld", state);
    return state == XMSDKPlayerStatePlaying;
}
///设置倍率播放
-(void)setPlayRate:(float)rate
{
    [[XMSDKPlayer sharedPlayer] setPlayRate:rate];
}
/**
 * 接着播上一次正在播放的专辑
 */
- (void)continuePlayFromAlbum:(NSInteger)albumID track:(NSInteger)trackID
{
    [[XMSDKPlayer sharedPlayer] continuePlayFromAlbum:albumID track:trackID];
}
/**
 * 暂停当前播放
 */
- (void)pauseTrackPlay
{
    [[XMSDKPlayer sharedPlayer] pauseTrackPlay];
}
/**
 * 恢复当前播放
 */
- (void)resumeTrackPlay
{
    [[XMSDKPlayer sharedPlayer] resumeTrackPlay];
}
/**
 * 停止当前播放
 */
- (void)stopTrackPlay
{
    [[XMSDKPlayer sharedPlayer] stopTrackPlay];
}
/**
 * 更新当前播放列表
 */
- (void)replacePlayList:(NSArray *)playlist
{
    [[XMSDKPlayer sharedPlayer] replacePlayList:playlist];
}
/**
 * 播放下一首
 */
- (BOOL)playNextTrack
{
    return [[XMSDKPlayer sharedPlayer] playNextTrack];
}
/**
 * 播放上一首
 */
- (BOOL)playPrevTrack
{
    return [[XMSDKPlayer sharedPlayer] playPrevTrack];
}
/**
 * 返回当前播放列表
 */
- (NSArray *)playList
{
    return [[XMSDKPlayer sharedPlayer] playList];
}
/**
 * 返回下一首
 */
- (XMTrack *)nextTrack
{
    return [[XMSDKPlayer sharedPlayer] nextTrack];
}
/**
 * 返回上一首
 */
- (XMTrack *)prevTrack
{
    return [[XMSDKPlayer sharedPlayer] prevTrack];
}
/**
 * 设置播放器从特定的时间播放
 */
- (void)seekToTime:(CGFloat)percent
{
    [[XMSDKPlayer sharedPlayer] seekToTime:percent];
}
/**
 * 清空缓存
 */
- (void)clearCacheSafely
{
    [[XMSDKPlayer sharedPlayer] clearCacheSafely];
}
/**
 * 返回当前播放的声音
 */
- (XMTrack*)currentTrack
{
    return [[XMSDKPlayer sharedPlayer] currentTrack];
}

/// 推送对象到屏幕上
+ (void)setNowPlayingInfoCenterWithTitle:(NSString *)title artist:(NSString *)artist artwork:(MPMediaItemArtwork *)artwork duration:(NSNumber*)duration currentTime:(NSNumber*)currentTime
{
    if (title == nil || artist == nil || artwork == nil || duration <= 0) {
        return;
    }
    [[PlayerManager sharedPlayer].dicMusicInfo removeAllObjects];
    // 设置Singer
    [[PlayerManager sharedPlayer].dicMusicInfo setObject:artist forKey:MPMediaItemPropertyArtist];
    // 设置歌曲名
    [[PlayerManager sharedPlayer].dicMusicInfo setObject:title forKey:MPMediaItemPropertyTitle];
    // 设置封面
    [[PlayerManager sharedPlayer].dicMusicInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //音乐剩余时长
    [[PlayerManager sharedPlayer].dicMusicInfo setObject:duration forKey:MPMediaItemPropertyPlaybackDuration];
    //音乐当前播放时间
    [[PlayerManager sharedPlayer].dicMusicInfo setObject:currentTime forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:[PlayerManager sharedPlayer].dicMusicInfo];
}
-(NSMutableDictionary *)dicMusicInfo
{
    if (_dicMusicInfo == nil) {
        _dicMusicInfo = [NSMutableDictionary dictionary];
    }
    return _dicMusicInfo;
}

#pragma mark - XMTrackPlayerDelegate

- (void)XMTrackPlayNotifyProcess:(CGFloat)percent currentSecond:(NSUInteger)currentSecond
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayNotifyProcess:currentSecond:)]) {
        [_delegate trackPlayNotifyProcess:percent currentSecond:currentSecond];
    }
    
    GBLog(@"XMTrackPlayNotifyProcess: %lf, currentSecond: %ld", percent, (unsigned long)currentSecond);
}
- (void)XMTrackPlayNotifyCacheProcess:(CGFloat)percent
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayNotifyCacheProcess:)]) {
        [_delegate trackPlayNotifyCacheProcess:percent];
    }
    GBLog(@"XMTrackPlayNotifyCacheProcess: %lf", percent);
}
- (void)XMTrackPlayerWillPlaying
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerWillPlaying)]) {
        [_delegate trackPlayerWillPlaying];
    }
    GBLog(@"XMTrackPlayerWillPlaying: %ld,  currentTrack.listenedTime: %ld,  currentTrack.duration: %ld", (long)[XMSDKPlayer sharedPlayer].playerState, (long)[XMSDKPlayer sharedPlayer].currentTrack.listenedTime, (long)[XMSDKPlayer sharedPlayer].currentTrack.duration);
}
-(void)XMTrackPlayerDidEnd
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidEnd)]) {
        [_delegate trackPlayerDidEnd];
    }
    GBLog(@"XMTrackPlayerDidEnd: %@", [XMSDKPlayer sharedPlayer].currentTrack.trackTitle);
}
-(void)XMTrackPlayerDidPlaylistEnd
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidPlaylistEnd)]) {
        [_delegate trackPlayerDidPlaylistEnd];
    }
    GBLog(@"XMTrackPlayerDidPlaylistEnd: %@", [XMSDKPlayer sharedPlayer].currentTrack.trackTitle);
}
- (void)XMTrackPlayerDidPlaying
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidPlaying)]) {
        [_delegate trackPlayerDidPlaying];
    }
    GBLog(@"XMTrackPlayerDidPlaying: %@", [XMSDKPlayer sharedPlayer].currentTrack.trackTitle);
}
- (void)XMTrackPlayerDidPaused
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidPaused)]) {
        [_delegate trackPlayerDidPaused];
    }
    GBLog(@"XMTrackPlayerDidPaused: %@", [XMSDKPlayer sharedPlayer].currentTrack.trackTitle);
}
- (void)XMTrackPlayerDidStopped
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidStopped)]) {
        [_delegate trackPlayerDidStopped];
    }
    GBLog(@"XMTrackPlayerDidStopped: %@", [XMSDKPlayer sharedPlayer].currentTrack.trackTitle);
}
- (void)XMTrackPlayerDidFailedToPlayTrack:(XMTrack *)track withError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidFailedToPlayTrack:withError:)]) {
        [_delegate trackPlayerDidFailedToPlayTrack:track withError:error];
    }
    GBLog(@"XMTrackPlayerDidFailedToPlayTrack Error:%ld, %@, %@", (long)error.code, error.domain, error.userInfo[NSLocalizedDescriptionKey]);
}
- (void)XMTrackPlayerDidErrorWithType:(NSString *)type withData:(NSDictionary*)data
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackPlayerDidErrorWithType:withData:)]) {
        [_delegate trackPlayerDidErrorWithType:type withData:data];
    }
    GBLog(@"XMTrackPlayerDidErrorWithType: %@, withData: %@", type, data);
}
- (BOOL)XMTrackPlayerShouldContinueNextTrackWhenFailed:(XMTrack *)track
{
    return NO;
}

@end
