//
//  DownLoadManager.m
//  PlaneLive
//
//  Created by Daniel on 07/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DownLoadManager.h"
#import "Utils.h"
#import "SQLiteOper.h"
#import "ZProgressHUD.h"

//文件的存放路径
#define kDownloadFilePath [self getLocalStartPath]
//已经下载文件的长度
#define kDownLoadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:kDownloadFilePath error:nil][NSFileSize] integerValue]
//存储下载文件的总长度
#define kDownLoadTotalLength [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.planelive"]

//NSURLSessionDownloadDelegate
@interface DownLoadManager()<NSURLSessionDataDelegate>

//上次下载对象
@property (strong, nonatomic) ModelAudio *lastModel;
//下载路径
@property (nonatomic,strong)NSString *downLoadURL;
//保存文件路径
@property (nonatomic,strong)NSString *downLoadFilePath;
//保存文件名称
@property (nonatomic,strong)NSString *downLoadFileName;
//创建session
@property (nonatomic,strong)NSURLSession *session;
//下载任务
@property (nonatomic,strong)NSURLSessionDataTask *task;
//创建流
@property (nonatomic,strong)NSOutputStream *stream;
//文件总长度
@property (nonatomic,assign)NSInteger wx_totalLength;

//task的状态
@property (nonatomic,assign)DownLoadManagerState wx_state;
//taskName
@property (nonatomic,strong)NSString *wx_taskName;
//当前进度
@property (nonatomic,assign)float wx_CurProgress;

@end

@implementation DownLoadManager

static DownLoadManager *_sharedDownloadHelper;

+ (DownLoadManager *) sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDownloadHelper = [[DownLoadManager alloc] init];
    });
    return _sharedDownloadHelper;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.downLoadURL = nil;
    self.downLoadFilePath = nil;
    self.wx_taskName = nil;
}
//设置下载地址
-(void)setDownloadWithModel:(ModelAudio *)model
{
    if (self.downLoadURL) {
        if (![model.audioPath isEqualToString:self.downLoadURL]) {
            [self dismiss];
            
            [self setDownloadConfigure:model];
            
            [self start];
        } else {
            if(self.wx_state == DownLoadManagerStateStart) {
                if(_delegate && [_delegate respondsToSelector:@selector(ZDownLoadTaskDidDownLoading:)]) {
                    [_delegate ZDownLoadTaskDidDownLoading:self.lastModel];
                }
                if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownLoadTaskDidDownLoading:)]) {
                    [_playerDelegate ZDownLoadTaskDidDownLoading:self.lastModel];
                }
            } else {
                [self setDownloadConfigure:model];
                
                [self start];
            }
        }
    } else {
        [self setDownloadConfigure:model];
        
        [self start];
    }
}
-(void)setDownloadConfigure:(ModelAudio *)model
{
    [self setLastModel:model];
    
    [self setWx_taskName:model.audioPath.lastPathComponent];
    
    [self setDownLoadURL:model.audioPath];
    
    [self setDownLoadFilePath:[self getLocalStartPath]];
    
    [self setDownLoadFileName:[self getLocalFileName]];
}
-(void)start
{
    [self setSaveStart];
    
    if(self.wx_state == DownLoadManagerStateStart) return;
    self.wx_state = DownLoadManagerStateStart;
    [self.task resume];
    if(_delegate && [_delegate respondsToSelector:@selector(ZDownLoadTaskDidBeginDownLoad:)]) {
        [_delegate ZDownLoadTaskDidBeginDownLoad:self.lastModel];
    }
    if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownLoadTaskDidBeginDownLoad:)]) {
        [_playerDelegate ZDownLoadTaskDidBeginDownLoad:self.lastModel];
    }
}
-(void)suspend
{
    [self setSaveError];
    
    if(self.wx_state == DownLoadManagerStateSuspend || self.wx_state == DownLoadManagerStateNormal) return;
    self.wx_state = DownLoadManagerStateSuspend;
    [self.task suspend];
    if(_delegate && [_delegate respondsToSelector:@selector(ZDownLoadTaskDidSuspendDownLoad:)]) {
        [_delegate ZDownLoadTaskDidSuspendDownLoad:self.lastModel];
    }
    if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownLoadTaskDidSuspendDownLoad:)]) {
        [_playerDelegate ZDownLoadTaskDidSuspendDownLoad:self.lastModel];
    }
}
-(void)cancel
{
    [self setSaveError];
    
    self.wx_state = DownLoadManagerStateCancel;
    [self.task cancel];
    if(_delegate && [_delegate respondsToSelector:@selector(ZDownLoadTaskDidCancelDownLoad:)]) {
        [_delegate ZDownLoadTaskDidCancelDownLoad:self.lastModel];
    }
    if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownLoadTaskDidCancelDownLoad:)]) {
        [_playerDelegate ZDownLoadTaskDidCancelDownLoad:self.lastModel];
    }
}
-(void)remove
{
    self.wx_state = DownLoadManagerStateCancel;
    [self.task cancel];
    
    BOOL delSuccess = [sqlite delLocalDownloadAudioWithModel:self.lastModel userId:[AppSetting getUserId]];
    if (delSuccess) {
        NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.lastModel.audioPath]] stringByAppendingPathExtension:kPathExtension];
        [Utils deleteDirectory:filePath];
        
        if (self.stream) {
            [self.stream close];
            self.stream = nil;
        }
        //清除任务
        self.task = nil;
        [self.session invalidateAndCancel];
        self.session = nil;
        
        OBJC_RELEASE(_downLoadURL);
        OBJC_RELEASE(_downLoadFileName);
        OBJC_RELEASE(_downLoadFilePath);
        OBJC_RELEASE(_wx_taskName);
    }
}
-(NSInteger)totalLength
{
    return [kDownLoadTotalLength integerValue];
}
-(NSInteger)downLoadLength
{
    return kDownLoadLength;
}
///本地下载完成存储地址
-(NSString *)getLocalEndPath
{
    NSString *strUrl = self.lastModel.audioPath;
    NSString *localPath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:strUrl]] stringByAppendingPathExtension:kPathExtension];
    return localPath;
}
///本地下载过程中存储地址
-(NSString *)getLocalStartPath
{
    NSString *strUrl = self.lastModel.audioPath;
    NSString *localPath = [[[AppSetting getTempFilePath] stringByAppendingPathComponent:[Utils stringMD5:strUrl]] stringByAppendingPathExtension:kPathExtension];
    return localPath;
}
///本地下载文件名称
-(NSString *)getLocalFileName
{
    NSString *strUrl = [[Utils stringMD5:self.lastModel.audioPath] stringByAppendingPathExtension:kPathExtension];
    return strUrl;
}
-(void)setSaveEnd
{
    if (self.lastModel) {
        [self.lastModel setAddress:ZDownloadStatusEnd];
        [self setSaveLocal];
    }
}
-(void)setSaveStart
{
    if (self.lastModel) {
        [self.lastModel setAddress:ZDownloadStatusStart];
        [self setSaveLocal];
    }
}
-(void)setSaveError
{
    if (self.lastModel) {
        [self.lastModel setAddress:ZDownloadStatusNomral];
        [self setSaveLocal];
    }
}
-(void)setSaveLocal
{
    GCDMainBlock(^{
        [self.lastModel setCachePath:self.downLoadFilePath];
        [sqlite addLocalDownloadAudioWithModel:self.lastModel userId:[AppSetting getUserDetauleId]];
    });
}
-(ModelAudio *)downloadModel
{
    return self.lastModel;
}
//获得task的状态
-(DownLoadManagerState)state
{
    return self.wx_state;
}
//获得taskNmae
-(NSString *)taskName
{
    return self.wx_taskName;
}
-(NSString *)fileUrl
{
    return self.downLoadURL;
}
//获得本读路径
-(NSString *)filePath
{
    return self.downLoadFilePath;
}
//获得文件的唯一标示名称
-(NSString *)fileName
{
    return self.downLoadFileName;
}
//获得当前进度
-(float)CurProgress
{
    //获得文件总长度
    float totalLength = [[NSMutableDictionary dictionaryWithContentsOfFile:kDownLoadTotalLength][self.filePath] floatValue];
    if(totalLength == 0) return 0;
    _wx_CurProgress = kDownLoadLength / totalLength;
    return _wx_CurProgress;
}
-(void)dismiss
{
    if (self.wx_state == DownLoadManagerStateStart) {
        [self cancel];
        
        [self clearStream];
        
        [self clearController];
    }
}
-(void)clearStream
{
    if (self.stream) {
        [self.stream close];
        self.stream = nil;
    }
    //清除任务
    self.task = nil;
    [self.session invalidateAndCancel];
    self.session = nil;
}
-(void)clearController
{
    OBJC_RELEASE(_downLoadURL);
    OBJC_RELEASE(_downLoadFileName);
    OBJC_RELEASE(_downLoadFilePath);
    OBJC_RELEASE(_wx_taskName);
}
-(void)moveDownloadFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kDownloadFilePath]) {
        [[NSFileManager defaultManager] moveItemAtPath:kDownloadFilePath toPath:[self getLocalEndPath] error:nil];
    }
}
#pragma mark - DownloadObject
//创建session
-(NSURLSession *)session
{
    if(!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
//创建任务
-(NSURLSessionDataTask *)task
{
    if(!_task) {
        //获得总长度
        NSInteger totalLength = [[NSMutableDictionary dictionaryWithContentsOfFile:kDownLoadTotalLength][self.fileName] integerValue];
        //如果下载完毕，直接退出
        if(totalLength && kDownLoadLength == totalLength) {
            self.wx_state = DownLoadManagerStateEnd;
            
            [self setSaveEnd];
            
            if(_delegate && [_delegate respondsToSelector:@selector(ZDownloadManagerDidFinishDownLoad:)]) {
                [_delegate ZDownloadManagerDidFinishDownLoad:self.lastModel];
            }
            if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownloadManagerDidFinishDownLoad:)]) {
                [_playerDelegate ZDownloadManagerDidFinishDownLoad:self.lastModel];
            }
            [self moveDownloadFile];
            
            [self clearController];
            return nil;
        }
        //创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downLoadURL]];
        // 设置请求头 Range : bytes=xxx-xxx（bytes=%zd-:表示每次从这个位置开始写入）
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", kDownLoadLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        //创建task
        _task = [self.session dataTaskWithRequest:request];
    }
    return _task;
}
//流
-(NSOutputStream *)stream
{
    if(!_stream) {
        _stream = [[NSOutputStream alloc] initToFileAtPath:[self getLocalStartPath] append:YES];
    }
    return _stream;
}

#pragma mark - NSURLSessionDataDelegate
/**
 *  当接收到服务器的响应 它默认会取消该请求，需要我们回调任务类型
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param response          响应头信息
 *  @param completionHandler 回调 传给系统
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //打开流
    [self.stream open];
    //获得文件总长度
    self.wx_totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + kDownLoadLength;
    //存储文件总长度
    NSMutableDictionary *dicTotal = [NSMutableDictionary dictionaryWithContentsOfFile:kDownLoadTotalLength];
    if(!dicTotal) dicTotal = [NSMutableDictionary dictionary];
    dicTotal[[self getLocalFileName]] = @(self.wx_totalLength);
    //写入文件
    [dicTotal writeToFile:kDownLoadTotalLength atomically:YES];
    //GBLog(@"NSMutableDictionary: %@, didReceiveResponse wx_totalLength: %ld", dicTotal, (long)self.wx_totalLength);
    /*
     NSURLSessionResponseCancel = 0,取消请求 默认
     NSURLSessionResponseAllow = 1, 接收数据
     NSURLSessionResponseBecomeDownload = 2, 变成下载任务
     NSURLSessionResponseBecomeStream        变成流
     */
    //允许接收
    completionHandler(NSURLSessionResponseAllow);
}
/**
 *  接收到服务器返回的数据 就会调用该方法，可以调用多次
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param data              本次下载的数据
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //写入数据
    [self.stream write:[data bytes] maxLength:data.length];
    //下载进度
    float progress = 1.0 * kDownLoadLength / self.wx_totalLength;
    
    if(_delegate && [_delegate respondsToSelector:@selector(ZDownloadManager:didReceiveProgress:)]) {
        [_delegate ZDownloadManager:self.lastModel didReceiveProgress:progress];
    }
    if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownloadManager:didReceiveProgress:)]) {
        [_playerDelegate ZDownloadManager:self.lastModel didReceiveProgress:progress];
    }
    //GBLog(@"task.state: %ld, didReceiveData: %lf", (long)dataTask.state, progress);
}
/**
 *  请求结束或者是失败的时候调用
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param error             错误信息
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)dataTask didCompleteWithError:(NSError *)error
{
    //GBLog(@"task.state: %ld, didCompleteWithError: %@", (long)dataTask.state, error);
    //关闭流
    [self.stream close];
    self.stream = nil;
    //清除任务
    self.task = nil;
    if (!error) {
        switch (dataTask.state) {
            case NSURLSessionTaskStateCompleted:
                self.wx_state = DownLoadManagerStateEnd;
                
                [self setSaveEnd];
                
                if(_delegate && [_delegate respondsToSelector:@selector(ZDownloadManagerDidFinishDownLoad:)]) {
                    [_delegate ZDownloadManagerDidFinishDownLoad:self.lastModel];
                }
                if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownloadManagerDidFinishDownLoad:)]) {
                    [_playerDelegate ZDownloadManagerDidFinishDownLoad:self.lastModel];
                }
                [self moveDownloadFile];
                
                [self clearController];
                break;
            case NSURLSessionTaskStateCanceling:
                [self setSaveError];
                //修改进度值
                if(_delegate && [_delegate respondsToSelector:@selector(ZDownloadManager:didReceiveProgress:)]) {
                    [_delegate ZDownloadManager:self.lastModel didReceiveProgress:0];
                }
                if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownloadManager:didReceiveProgress:)]) {
                    [_playerDelegate ZDownloadManager:self.lastModel didReceiveProgress:0];
                }
                [self clearController];
                break;
            case NSURLSessionTaskStateSuspended:
                [self setSaveError];
                
                [self clearController];
                break;
            default:
                break;
        }
    } else {
        [self setSaveError];
        
        self.wx_state = DownLoadManagerStateNormal;
        if(_delegate && [_delegate respondsToSelector:@selector(ZDownloadManagerDidErrorDownLoad:didReturnError:)]) {
            [_delegate ZDownloadManagerDidErrorDownLoad:self.lastModel didReturnError:error];
        }
        if(_playerDelegate && [_playerDelegate respondsToSelector:@selector(ZDownloadManagerDidErrorDownLoad:didReturnError:)]) {
            [_playerDelegate ZDownloadManagerDidErrorDownLoad:self.lastModel didReturnError:error];
        }
        [self clearController];
    }
}

@end
