//
//  DownloadManager.m
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager()<SDKDownloadMgrDelegate>
{
    BOOL _isSetDelegate;
}
@property (nonatomic, weak) id <DownloadManagerDelegate> delegate;

@end

@implementation DownloadManager

static DownloadManager *_downlaodManagerInstance;
//／初始化方法
+(DownloadManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downlaodManagerInstance = [[self alloc] init];
    });
    return _downlaodManagerInstance;
}
///设置代理
-(void)setDownloadDelegate:(id <DownloadManagerDelegate>)delegate
{
    [self setDelegate:delegate];
    if (!_isSetDelegate) {
        _isSetDelegate = true;
        [[XMSDKDownloadManager sharedSDKDownloadManager] setSdkDownloadMgrDelegate:self];
    }
}
-(void)dealloc
{
    self.delegate = nil;
    [[XMSDKDownloadManager sharedSDKDownloadManager] setSdkDownloadMgrDelegate:nil];
}
#pragma mark 全局配置接口

/**
 *  设置下载音频文件的保存目录
 *  默认路径：~/Documents/iDoc/Download/...
 *  请确保自定义设置的saveDir有效，否则仍会保存到默认路径
 *  @param saveDir NSString
 */
- (void)settingDownloadAudioSaveDir:(NSString *)saveDir
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] settingDownloadAudioSaveDir:saveDir];
}

/**
 *  获取下载音频文件的保存目录
 *
 *  @return saveDir
 */
- (NSString *)getDownloadAudioSaveDir
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getDownloadAudioSaveDir];
}

/**
 *  获取下载文件已占用的磁盘空间，单位字节
 *
 *  @return bytes
 */
- (unsigned long long)getDownloadOccupationInBytes
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getDownloadOccupationInBytes];
}

#pragma mark 下载接口

/**
 *  下载单条音频
 *
 *  @param track
 *  @param ifImmediate 是否立即下载，若否，只注册不下载
 *
 *  @return 返回值含义 (0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载)
 */
- (int)downloadSingleTrack:(XMTrack *)track immediately:(BOOL)ifImmediate
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] downloadSingleTrack:track immediately:ifImmediate];
}

/**
 *  批量下载音频
 *
 *  @param tracks 单次批量下载数量不超过50
 *  @param ifImmediate 是否立即下载，若否，只注册不下载
 *
 */
- (void)downloadTracks:(NSMutableArray *)tracks immediately:(BOOL)ifImmediate
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] downloadTracks:tracks immediately:ifImmediate];
}

#pragma mark 暂停下载接口

/**
 *  暂停单条音频下载
 *
 */
- (void)pauseDownloadSingleTrack:(XMTrack *)track
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] pauseDownloadSingleTrack:track];
}

/**
 *   批量暂停音频下载
 *
 */
- (void)pauseDownloadTracks:(NSMutableArray *)tracks
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] pauseDownloadTracks:tracks];
}

/**
 *   暂停某专辑中全部音频下载
 *
 */
- (void)pauseDownloadTracksInAlbum:(NSInteger)albumId
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] pauseDownloadTracksInAlbum:albumId];
}

/**
 *  暂停全部音频下载
 *
 */
- (void)pauseAllDownloads
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] pauseAllDownloads];
}

#pragma mark 恢复下载接口

/**
 *  恢复被暂停的单条音频下载任务
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeDownloadSingleTrack:(XMTrack *)track
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] resumeDownloadSingleTrack:track];
}

/**
 *  批量恢复被暂停的音频下载任务
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeDownloadTracks:(NSMutableArray *)tracks
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] resumeDownloadTracks:tracks];
}

/**
 *  恢复被暂停的某专辑中的全部音频下载
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeDownloadTracksInAlbum:(NSInteger)albumId
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] resumeDownloadTracksInAlbum:albumId];
}

/**
 *  恢复被暂停的全部音频下载任务
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeAllDownloads
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] resumeAllDownloads];
}

#pragma mark 取消下载接口
//取消下载：只对准备下载和正在下载状态的音频有效

/**
 *  取消单条音频下载，已下载部分也会被删除
 *
 */
- (void)cancelDownloadSingleTrack:(XMTrack *)track
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] cancelDownloadSingleTrack:track];
}

/**
 *  批量取消音频下载，已下载部分也会被删除
 *
 */
- (void)cancelDownloadTracks:(NSMutableArray *)tracks
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] cancelDownloadTracks:tracks];
}

/**
 *  取消某专辑中全部音频下载，已下载部分也会被删除
 *
 */
- (void)cancelDownloadTracksInAlbum:(NSInteger)albumId
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] cancelDownloadTracksInAlbum:albumId];
}

/**
 *  取消全部音频下载，已下载部分也会被删除
 *
 */
- (void)cancelAllDownloads
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] cancelAllDownloads];
}

#pragma mark 清除接口

/**
 *  清除单个音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearDownloadAudio:(XMTrack *)track
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] clearDownloadAudio:track];
}

/**
 *  批量清除音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearDownloadTracks:(NSMutableArray *)tracks
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] clearDownloadTracks:tracks];
}

/**
 *  指定清除某专辑中的音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearDownloadAlbum:(NSInteger)albumId
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] clearDownloadAlbum:albumId];
}

/**
 *  清除全部音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearAllDownloads
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] clearAllDownloads];
}

#pragma mark 获取下载状态／音频／专辑信息接口

/**
 *  获取单个音频下载状态
 *  @param trackId
 *
 */
- (XMTrackDownloadStatus *)getSingleTrackDownloadStatus:(NSInteger)trackId
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getSingleTrackDownloadStatus:trackId];
}

/**
 *  批量获取音频下载状态
 *  @param trackId的数组
 *  @return 字典 key:trackId NSNumber, value:XMTrackDownloadStatus
 */
- (NSMutableDictionary *)getBatchTrackDownloadStatus:(NSMutableArray *)trackIds
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getBatchTrackDownloadStatus:trackIds];
}

/**
 *  获取某专辑中全部音频的下载状态
 *  @param albumId
 *  @return 字典 key:trackId NSNumber, value:XMTrackDownloadStatus
 */
- (NSMutableDictionary *)getTrackInAlbumDownloadStatus:(NSInteger)albumId
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getTrackInAlbumDownloadStatus:albumId];
}

/**
 *  获取全部音频下载状态
 *  @return 字典 key:trackId NSNumber, value:XMTrackDownloadStatus
 */
- (NSMutableDictionary *)getAllDownloadStatus
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getAllDownloadStatus];
}

/**
 *  获取已下载音频
 *  @return XMCacheTrack array
 */
- (NSMutableArray *)getDownloadedTracks
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getDownloadedTracks];
}

/**
 *  获取已下载的专辑
 *  @return XMSubordinatedAlbum array
 */
- (NSMutableArray *)getDownloadedAlbums
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getDownloadedAlbums];
}

/**
 *  获取某专辑中已下载的音频
 *  @return XMCacheTrack array
 */
- (NSMutableArray *)getDownloadedTrackInAlbum:(NSInteger)albumId
{
    return [[XMSDKDownloadManager sharedSDKDownloadManager] getDownloadedTrackInAlbum:albumId];
}

#pragma mark - SDKDownloadMgrDelegate

///下载失败时被调用
- (void)XMTrackDownloadDidFailed:(XMTrack *)track
{
    NSString *trackId = [NSString stringWithFormat:@"%ld", (long)track.trackId];
    NSString *albumId = [NSString stringWithFormat:@"%ld", (long)track.subordinatedAlbum.albumId];
    NSString *status = [NSString stringWithFormat:@"%d", (int)XMCacheTrackStatusFailed];
    [sqlite setLocalDownloadStatus:status trackId:trackId dataType:albumId];
    
    GBLog(@"XMTrackDownloadDidFailed: trackTitle: %@,  status: %@", track.trackTitle, status);
    
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadDidFailed:)]) {
        [_delegate trackDownloadDidFailed:track];
    }
}
////下载完成时被调用
- (void)XMTrackDownloadDidFinished:(XMTrack *)track
{
    NSString *trackId = [NSString stringWithFormat:@"%ld", (long)track.trackId];
    NSString *albumId = [NSString stringWithFormat:@"%ld", (long)track.subordinatedAlbum.albumId];
    NSString *status = [NSString stringWithFormat:@"%d", (int)XMCacheTrackStatusDownloaded];
    [sqlite setLocalDownloadStatus:status trackId:trackId dataType:albumId];
    
    GBLog(@"XMTrackDownloadDidFinished: trackTitle: %@,  status: %@", track.trackTitle, status);
    
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadDidFinished:)]) {
        [_delegate trackDownloadDidFinished:track];
    }
}
///下载开始时被调用
- (void)XMTrackDownloadDidBegan:(XMTrack *)track
{
    NSString *trackId = [NSString stringWithFormat:@"%ld", (long)track.trackId];
    NSString *albumId = [NSString stringWithFormat:@"%ld", (long)track.subordinatedAlbum.albumId];
    NSString *status = [NSString stringWithFormat:@"%d", (int)XMCacheTrackStatusDownloading];
    [sqlite setLocalDownloadStatus:status trackId:trackId dataType:albumId];
    
    GBLog(@"XMTrackDownloadDidBegan: trackTitle: %@,  status: %@", track.trackTitle, status);
    
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadDidBegan:)]) {
        [_delegate trackDownloadDidBegan:track];
    }
}
///下载取消时被调用
- (void)XMTrackDownloadDidCanceled:(XMTrack *)track
{
    NSString *trackId = [NSString stringWithFormat:@"%ld", (long)track.trackId];
    NSString *albumId = [NSString stringWithFormat:@"%ld", (long)track.subordinatedAlbum.albumId];
    NSString *status = [NSString stringWithFormat:@"%d", (int)XMCacheTrackStatusCancelled];
    [sqlite setLocalDownloadStatus:status trackId:trackId dataType:albumId];
    
    GBLog(@"XMTrackDownloadDidCanceled: trackTitle: %@,  status: %@", track.trackTitle, status);
    
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadDidCanceled:)]) {
        [_delegate trackDownloadDidCanceled:track];
    }
}
///下载暂停时被调用
- (void)XMTrackDownloadDidPaused:(XMTrack *)track
{
    NSString *trackId = [NSString stringWithFormat:@"%ld", (long)track.trackId];
    NSString *albumId = [NSString stringWithFormat:@"%ld", (long)track.subordinatedAlbum.albumId];
    NSString *status = [NSString stringWithFormat:@"%d", (int)XMCacheTrackStatusPausedByUser];
    [sqlite setLocalDownloadStatus:status trackId:trackId dataType:albumId];
    
    GBLog(@"XMTrackDownloadDidPaused: trackTitle: %@,  status: %@", track.trackTitle, status);
    
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadDidPaused:)]) {
        [_delegate trackDownloadDidPaused:track];
    }
}
///下载进度更新时被调用
- (void)XMTrack:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    if (_delegate && [_delegate respondsToSelector:@selector(track:updateDownloadedPercent:)]) {
        [_delegate track:track updateDownloadedPercent:downloadedPercent];
    }
    GBLog(@"XMTrack-UpdateDownloadedPercent: trackTitle: %@,  updateDownloadedPercent: %.2lf", track.trackTitle, downloadedPercent);
}
///下载状态更新为ready时被调用
- (void)XMTrackDownloadStatusUpdated:(XMTrack *)track
{
    NSString *trackId = [NSString stringWithFormat:@"%ld", (long)track.trackId];
    NSString *albumId = [NSString stringWithFormat:@"%ld", (long)track.subordinatedAlbum.albumId];
    NSString *status = [NSString stringWithFormat:@"%d", (int)XMCacheTrackStatusReady];
    [sqlite setLocalDownloadStatus:status trackId:trackId dataType:albumId];
    
    GBLog(@"XMTrackDownloadStatusUpdated: trackTitle: %@,  status: %@", track.trackTitle, status);
    
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadStatusUpdated:)]) {
        [_delegate trackDownloadStatusUpdated:track];
    }
}
///从数据库载入数据时被调用
- (void)XMTrackDownloadDidLoadFromDB
{
    if (_delegate && [_delegate respondsToSelector:@selector(trackDownloadDidLoadFromDB)]) {
        [_delegate trackDownloadDidLoadFromDB];
    }
    GBLog(@"XMTrackDownloadDidLoadFromDB");
}

@end
