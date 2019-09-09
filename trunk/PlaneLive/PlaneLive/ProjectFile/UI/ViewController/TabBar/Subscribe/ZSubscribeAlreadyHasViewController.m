//
//  ZSubscribeAlreadyViewController.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyHasViewController.h"
#import "ZNewSubscribeAlreadyHasMainView.h"
#import "ZWebContentViewController.h"
#import "ZPlayerViewController.h"
#import "DownloadManager.h"
#import "ZTrafficDownloadView.h"

@interface ZSubscribeAlreadyHasViewController ()<DownloadManagerDelegate>

@property (strong, nonatomic) ZNewSubscribeAlreadyHasMainView *viewMain;

@property (strong, nonatomic) NSMutableArray *arrayDownloadTrack;
@property (strong, nonatomic) NSMutableArray *arrayTrack;
@property (strong, nonatomic) NSString *subscribeId;
@property (strong, nonatomic) ModelSubscribe *modelSD;
@property (assign, nonatomic) CGFloat pageNum;
///当前下载的row
@property (assign, nonatomic) NSInteger downloadRow;
@property (assign, nonatomic) BOOL isDownloadAll;

@end

@implementation ZSubscribeAlreadyHasViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightShareButton];
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageChargeCourseDetailKey];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnPlayCourseChange:) name:@"onPlayCourseChange" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageChargeCourseDetailKey dictionary:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onPlayCourseChange" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_subscribeId);
    
    [[DownloadManager sharedManager] setDownloadDelegate:nil];
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [super innerInit];
    
    ZWEAKSELF
    self.viewMain = [[ZNewSubscribeAlreadyHasMainView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.view addSubview:self.viewMain];
    
    [self innerEvent];
    [self innerData];
}
-(void)innerData
{
    self.downloadRow = -1;
    NSArray *arrayC = [sqlite getLocalCurriculumContinuousSowingArrayWithSubscribeId:self.subscribeId userId:kLoginUserId];
    if (arrayC && [arrayC isKindOfClass:[NSArray class]] && arrayC.count > 0) {
        [self.viewMain setViewDataWithCourseArray:arrayC isHeader:YES];
    }
    ModelSubscribeDetail *model = [sqlite getLocalSubscribeDetailWithUserId:kLoginUserId subscribeId:self.subscribeId];
    if (model && model.ids) {
        [self setModelSD:model];
        [self.viewMain setViewDataWithModel:model];
    } else {
        [self.viewMain setViewDataWithModel:(self.modelSD)];
    }
    [self setSubscribeDetailHeader];
    [self setRefreshCourseHeader];
}
-(void)setOnPlayCourseChange:(NSNotification *)sender
{
    NSDictionary *dicObject = (NSDictionary *)sender.object;
    BOOL isPlaying = [(NSNumber *)[dicObject objectForKey:@"isPlaying"] boolValue];
    ModelCurriculum *modelC = (ModelCurriculum *)[dicObject objectForKey:@"modelC"];
    [self.viewMain setIsPlayStatus:isPlaying rowModel:modelC];
}
-(void)innerEvent
{
    ZWEAKSELF
    /// 设置播放状态改变
//    [[ZPlayerViewController sharedSingleton] setOnPlayCourseChange:^(ModelCurriculum *model, BOOL isPlaying) {
//        [weakSelf.viewMain setIsPlayStatus:isPlaying rowModel:model];
//    }];
    /// 下载监听
    [[DownloadManager sharedManager] setDownloadDelegate:self];
    /// 业务模块
    [self.viewMain setOnCourseItemClick:^(NSArray *array, NSInteger index) {
        [weakSelf setShowCourseVC:array row:index];
    }];
    /// 停止播放
    [self.viewMain setOnStopPlayClick:^(ModelCurriculum *model) {
        [[ZPlayerViewController sharedSingleton] setStopPlay];
    }];
    /// 课程详情点击
    [self.viewMain setOnCourseClick:^(ModelCurriculum *model) {
        [weakSelf showCurriculumDetailVC:model];
    }];
    /// 下载按钮点击
    [self.viewMain setOnDownloadClick:^(NSInteger row, ModelCurriculum *model) {
        switch ([[AppDelegate app] statusNetwork]) {
            case 1: {
                [weakSelf setDownloadSingle:row model:model];
                break;
            }
            case 2: {
                ZTrafficDownloadView *downloadView = [[ZTrafficDownloadView alloc] initWithSize:0];
                [downloadView setOnConfirmationClick:^{
                    [weakSelf setDownloadSingle:row model:model];
                }];
                [downloadView show];
                break;
            }
            default:
                [ZProgressHUD showError:@"无网络,请检查网络设置"];
                break;
        }
    }];
    /// 批量下载
    [self.viewMain setOnDownloadAllClick:^(NSArray *arrayCourse) {
        switch ([[AppDelegate app] statusNetwork]) {
            case 1: {
                // 判断是否全部下载完毕
                BOOL isDownloadEndAll = true;
                for (ModelCurriculum *modelC in arrayCourse) {
                    NSInteger trackId = [modelC.ids integerValue];
                    XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:trackId];
                    if (status.state != XMCacheTrackStatusDownloaded) {
                        isDownloadEndAll = false;
                        break;
                    }
                }
                if (!isDownloadEndAll) {
                    [weakSelf setIsDownloadAll:true];
                    [weakSelf setDownloadAllArray];
                    [ZProgressHUD showSuccess:kJoinDownload];
                }
                break;
            }
            case 2: {
                // 处理需要下载总大小
                CGFloat downloadTotal = 0;
                for (ModelCurriculum *modelC in arrayCourse) {
                    NSInteger trackId = [modelC.ids integerValue];
                    XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:trackId];
                    if (status.state != XMCacheTrackStatusDownloaded) {
                        downloadTotal = downloadTotal+modelC.audio_sizeMB;
                    }
                }
                if (downloadTotal > 0) {
                    ZTrafficDownloadView *downloadView = [[ZTrafficDownloadView alloc] initWithSize:(int)downloadTotal];
                    [downloadView setOnConfirmationClick:^{
                        [weakSelf setIsDownloadAll:true];
                        [weakSelf setDownloadAllArray];
                        [ZProgressHUD showSuccess:kJoinDownload];
                    }];
                    [downloadView show];
                }
                break;
            }
            default:
                [ZProgressHUD showError:@"无网络,请检查网络设置"];
                break;
        }
    }];
    /// 刷新课程顶部
    [self.viewMain setOnRefreshCourseHeader:^{
        [weakSelf setRefreshCourseHeader];
        [weakSelf setSubscribeDetailHeader];
    }];
    /// 刷新课程底部
    [self.viewMain setOnRefreshCourseFooter:^{
        [weakSelf setRefreshCourseFooter];
    }];
}
/// 列表播放
-(void)setShowCourseVC:(NSArray *)array row:(NSInteger)row
{
    if (array && array.count > 0 && array.count > row) {
        [sqlite setSysParam:kSQLITEPlayViewLastPlayIndex value:[NSString stringWithFormat:@"%d", (int)row]];
        [sqlite setSysParam:kSQLITEPlayViewLastPlayType value:[NSString stringWithFormat:@"%ld", (long)ZPlayTabBarViewTypeSubscribe]];
        [sqlite setLocalPlayListSubscribeCurriculumWithArray:array userId:kLoginUserId];
        
        ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
        [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeSubscribe)];
        [itemVC setRawdataWithArray:array index:row];
        
        [itemVC setStartPlay];
        
        [self innerPlayInit];
    } else {
        [ZProgressHUD showError:kNotFoundPlayRecord];
    }
}
-(NSMutableArray *)arrayTrack
{
    if (!_arrayTrack) {
        _arrayTrack = [NSMutableArray array];
    }
    return _arrayTrack;
}
-(NSMutableArray *)arrayDownloadTrack
{
    if (!_arrayDownloadTrack) {
        _arrayDownloadTrack = [NSMutableArray array];
    }
    return _arrayDownloadTrack;
}
-(void)setSubscribeDetailHeader
{
    ZWEAKSELF
    [snsV2 getSubscribeRecommendArrayWithSubscribeId:self.subscribeId resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
        [weakSelf setModelSD:model];
        [weakSelf.viewMain setViewDataWithModel:model];
        [sqlite setLocalSubscribeDetailWithModel:model userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD showError:msg];
    }];
}
///显示已订阅Web详情
-(void)showCurriculumDetailVC:(ModelCurriculum *)model
{
    ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
    [itemVC setViewDataWithModel:model isCourse:NO];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
/// 课程列表刷新顶部
-(void)setRefreshCourseHeader
{
    ZWEAKSELF
    [snsV2 getCurriculumArrayWithSubscribeId:self.subscribeId type:1 pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNum = 1;
        [weakSelf.arrayTrack removeAllObjects];
        for (ModelCurriculum *modelC in arrResult) {
            if (modelC.is_series_course == 1) {
                ModelTrack *modelT = [[ModelTrack alloc] initWithModelSeriesCourses:modelC];
                
                XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:modelT.trackId];
                if (status) {
                    modelC.downloadStatus =  status.state;
                    if (status.totalBytes <= 0) {
                        modelC.downloadProgress = 0;
                    } else {
                        modelC.downloadProgress = status.downloadedBytes/status.totalBytes;
                    }
                    modelT.status = status.state;
                }
                [weakSelf.arrayTrack addObject:modelT];
            } else {
                ModelTrack *modelT = [[ModelTrack alloc] initWithModelCurriculum:modelC];
                
                XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:modelT.trackId];
                if (status) {
                    modelC.downloadStatus =  status.state;
                    if (status.totalBytes <= 0) {
                        modelC.downloadProgress = 0;
                    } else {
                        modelC.downloadProgress = status.downloadedBytes/status.totalBytes;
                    }
                    modelT.status = status.state;
                }
                [weakSelf.arrayTrack addObject:modelT];
            }
        }
        [weakSelf.viewMain setViewDataWithCourseArray:arrResult isHeader:YES];
        [sqlite setLocalCurriculumContinuousSowingWithArray:arrResult subscribeId:weakSelf.subscribeId userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithCourseArray:nil isHeader:YES];
    }];
}
/// 课程列表刷新底部
-(void)setRefreshCourseFooter
{
    ZWEAKSELF
    [snsV2 getCurriculumArrayWithSubscribeId:self.subscribeId type:1 pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNum += 1;
        for (ModelCurriculum *modelC in arrResult) {
            if (modelC.is_series_course == 1) {
                ModelTrack *modelT = [[ModelTrack alloc] initWithModelSeriesCourses:modelC];
                
                XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:modelT.trackId];
                if (status) {
                    modelC.downloadStatus =  status.state;
                    if (status.totalBytes <= 0) {
                        modelC.downloadProgress = 0;
                    } else {
                        modelC.downloadProgress = status.downloadedBytes/status.totalBytes;
                    }
                    modelT.status = status.state;
                }
                [weakSelf.arrayTrack addObject:modelT];
            } else {
                ModelTrack *modelT = [[ModelTrack alloc] initWithModelCurriculum:modelC];
                
                XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:modelT.trackId];
                if (status) {
                    modelC.downloadStatus =  status.state;
                    if (status.totalBytes <= 0) {
                        modelC.downloadProgress = 0;
                    } else {
                        modelC.downloadProgress = status.downloadedBytes/status.totalBytes;
                    }
                    modelT.status = status.state;
                }
                [weakSelf.arrayTrack addObject:modelT];
            }
        }
        [weakSelf.viewMain setViewDataWithCourseArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithCourseArray:nil isHeader:NO];
    }];
}
-(void)setViewDataWithSubscribeModel:(ModelSubscribe *)model
{
    if (model.is_series_course == 0) {
        [self setTitle:@"培训课"];
        [StatisticsManager event: kTraining_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
    } else {
        [self setTitle:@"系列课"];
        [StatisticsManager event: kEriesCourse_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
    }
    [self setModelSD:model];
    [self setSubscribeId:model.ids];
}
///分享按钮点击事件
-(void)btnShareClick
{
    if (self.modelSD.is_series_course == 0) {
        [StatisticsManager event:kTraining_Detail_Share];
    } else {
        [StatisticsManager event:kEriesCourse_Detail_Share];
    }
    ZAlertShareView *shareView = [[ZAlertShareView alloc] init];
    ZWEAKSELF
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                if (self.modelSD.is_series_course == 0) {
                    [StatisticsManager event:kTraining_Detail_Share_Wechat];
                } else {
                    [StatisticsManager event:kEriesCourse_Detail_Share_Wechat];
                }
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                if (self.modelSD.is_series_course == 0) {
                    [StatisticsManager event:kTraining_Detail_Share_WechatCircle];
                } else {
                    [StatisticsManager event:kEriesCourse_Detail_Share_WechatCircle];
                }
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [weakSelf btnQZoneClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelSD.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelSD.theme_intro;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelSD.illustration];
    NSString *webUrl = kApp_SubscribeContentUrl(self.modelSD.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
#pragma makr - 下载模块

/// 判断是否已经加入下载队列 true已经加入,false未加入
-(BOOL)isAddDownload:(NSUInteger )trackId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackId == %ld", trackId];
    NSArray *filteredArray = [self.arrayDownloadTrack filteredArrayUsingPredicate:predicate];
    return filteredArray.count>0;
}
/// 下载单个按钮
-(void)setDownloadSingle:(NSInteger)row model:(ModelCurriculum *)model
{
    if (self.arrayTrack.count > row) {
        ModelTrack *modelT = [self.arrayTrack objectAtIndex:row];
        XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:modelT.trackId];
        switch (status.state) {
            case XMCacheTrackStatusDownloading:
                [self setIsDownloadAll:false];
                [[DownloadManager sharedManager] pauseDownloadSingleTrack:modelT];
                break;
            case XMCacheTrackStatusDownloaded:
                break;
            default:
                // 单个按钮点击的时候,判断是否已经点击了批量下载,如果点击了批量下载就只提示一下就行了
                if (!self.isDownloadAll) {
                    // 如果没有点击批量下载,判断当前是否正在下载单个,如果正在下载单个就添加下载到队列
                    if (self.arrayDownloadTrack.count <= 0) {
                        [self.arrayDownloadTrack addObject:modelT];
                        [[DownloadManager sharedManager] downloadSingleTrack:modelT immediately:true];
                    } else {
                        // 如果点击的对象已经在下载队列里面,就提示一下
                        if (![self isAddDownload:modelT.trackId]) {
                            [self.arrayDownloadTrack addObject:modelT];
                        }
                        [ZProgressHUD showSuccess:kJoinDownload];
                    }
                } else {
                    [ZProgressHUD showSuccess:kJoinDownload];
                }
                break;
        }
    }
}
/// 下载集合
-(void)setDownloadAllArray
{
    if (self.isDownloadAll) {
        for (int i = 0; i < self.arrayTrack.count; i++) {
            ModelTrack *modelT = [self.arrayTrack objectAtIndex:i];
            if (modelT.status != XMCacheTrackStatusDownloaded) {
                [[DownloadManager sharedManager] downloadSingleTrack:modelT immediately:true];
                break;
            }
        }
    }
}
/// 下载完成
-(void)setDownloadEndChange
{
    self.downloadRow = -1;
    if (self.isDownloadAll) {
        return;
    }
    if (self.arrayDownloadTrack.count > 0) {
        [self.arrayDownloadTrack removeObjectAtIndex:0];
    }
    if (self.arrayDownloadTrack.count > 0) {
        ModelTrack *modelT = self.arrayDownloadTrack.firstObject;
        [[DownloadManager sharedManager] downloadSingleTrack:modelT immediately:true];
    }
}
/// 处理当前下载对象索引
-(void)setDownloadChangeRow:(NSUInteger)trackId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackId == %ld", trackId];
    NSArray *filteredArray = [self.arrayTrack filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        ModelTrack *modelT = filteredArray.firstObject;
        self.downloadRow = [self.arrayTrack indexOfObject:modelT];
        [sqlite setLocalDownloadListWithModelTrack:modelT];
    } else {
        self.downloadRow = -1;
    }
}
/// 改变下载状态图标
-(void)setDownloadChangeStatus:(XMCacheTrackStatus)status
{
    if (self.downloadRow >= 0 && self.downloadRow < self.arrayTrack.count) {
        [self.viewMain setDownloadStatus:status row:self.downloadRow];
        ModelTrack *modelT = [self.arrayTrack objectAtIndex:self.downloadRow];
        modelT.status = status;
    }
}
/// 更新下载进度
-(void)setDownloadProgress:(double)progress
{
    if (self.downloadRow >= 0 && self.downloadRow < self.arrayTrack.count) {
        [self.viewMain setDownloadProgress:progress row:self.downloadRow];
    }
}

#pragma mark - DownloadManagerDelegate

///下载失败时被调用
- (void)trackDownloadDidFailed:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusFailed)];
    [self setDownloadEndChange];
}
////下载完成时被调用
- (void)trackDownloadDidFinished:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusDownloaded)];
    [self setDownloadEndChange];
    [self setDownloadAllArray];
}
///下载开始时被调用
- (void)trackDownloadDidBegan:(XMTrack *)track
{
    [self setDownloadChangeRow:track.trackId];
    [self setDownloadChangeStatus:(XMCacheTrackStatusDownloading)];
}
///下载取消时被调用
- (void)trackDownloadDidCanceled:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusCancelled)];
    [self setDownloadEndChange];
}
///下载暂停时被调用
- (void)trackDownloadDidPaused:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusPausedByUser)];
    [self setDownloadEndChange];
}
///下载进度更新时被调用
- (void)track:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    [self setDownloadProgress:downloadedPercent];
}
///下载状态更新为ready时被调用
- (void)trackDownloadStatusUpdated:(XMTrack *)track
{
    
}
///从数据库载入数据时被调用
- (void)trackDownloadDidLoadFromDB
{
    
}

@end
