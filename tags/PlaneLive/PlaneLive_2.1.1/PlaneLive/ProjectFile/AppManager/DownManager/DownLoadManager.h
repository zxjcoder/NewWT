//
//  DownLoadManager.h
//  PlaneLive
//
//  Created by Daniel on 07/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelAudio.h"

@class DownLoadManager;

@protocol DownloadManagerDelegate <NSObject>

@optional
//下载完成
-(void)ZDownloadManagerDidFinishDownLoad:(ModelAudio *)model;
//下载中
-(void)ZDownLoadTaskDidDownLoading:(ModelAudio *)model;
//任务开始
-(void)ZDownLoadTaskDidBeginDownLoad:(ModelAudio *)model;
//任务暂停
-(void)ZDownLoadTaskDidSuspendDownLoad:(ModelAudio *)model;
//任务取消
-(void)ZDownLoadTaskDidCancelDownLoad:(ModelAudio *)model;
//下载错误
-(void)ZDownloadManagerDidErrorDownLoad:(ModelAudio *)model didReturnError:(NSError *)error;;
/**
 *  下载进度（会调用多次，返回最新的进度）
 *
 *  @param model    任务对象
 *  @param progress 进度值
 *  ！！！如果需要用progress去刷新界面的UI空间.需要将进度值赋值的代码添加到主线程中。
 */
-(void)ZDownloadManager:(ModelAudio *)model didReceiveProgress:(float)progress;

@end

typedef NS_ENUM(NSInteger, DownLoadManagerState)
{
    DownLoadManagerStateNormal = 0,
    DownLoadManagerStateStart = 1,
    DownLoadManagerStateSuspend = 2,
    DownLoadManagerStateCancel = 3,
    DownLoadManagerStateEnd = 4
};

///下载管理器
@interface DownLoadManager : NSObject

///初始化
+ (DownLoadManager *)sharedHelper;

/// 下载代理
@property (nonatomic, assign) id<DownloadManagerDelegate> delegate;
/// 下载代理
@property (nonatomic, assign) id<DownloadManagerDelegate> playerDelegate;

/**
 *  下载任务的状态(默认是0)
 *  0 ---- 等待中的任务（首次添加还没有开始下载的任务）
 *  1 ---- 正在下载的任务
 *  2 ---- 暂停的任务
 *  3 ---- 取消下载的任务
 *  4 ---- 已经完成的任务
 */
@property (nonatomic,readonly) DownLoadManagerState state;

//下载文件的名称
@property (nonatomic,readonly) NSString *taskName;
//下载文件的路径
@property (nonatomic,readonly) NSString *fileUrl;
//下载对象
@property (nonatomic,readonly) ModelAudio *downloadModel;

//本地缓存路径地址
@property (nonatomic,readonly) NSString *filePath;
//本地缓存文件名称
@property (nonatomic,readonly) NSString *fileName;

//当前的下载进度
@property (nonatomic,assign,readonly) float CurProgress;

//文件总大小
@property (nonatomic,readonly) NSInteger totalLength;
//已经下载的大小
@property (nonatomic,readonly) NSInteger downLoadLength;

//设置下载对象
-(void)setDownloadWithModel:(ModelAudio *)model;

//开始下载
-(void)start;
//暂停下载
-(void)suspend;
//取消下载
-(void)cancel;
//移除下载
-(void)remove;

/// 关闭进程调用
- (void)dismiss;

@end
