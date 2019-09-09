//
//  ZPlayerViewController.m
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ModelAudio.h"
#import "ZPlayFunctionView.h"

#import "ZCircleQuestionViewController.h"
#import "ZPracticeContentViewController.h"
#import "ZPracticeAnswerViewController.h"
#import "ZPhotoBrowser.h"

#import "ZPlayListView.h"
#import "ZPlayObjectInfoView.h"

#import "ZCurriculumDetailViewController.h"

#import "DownLoadManager.h"

@interface ZPlayerViewController ()<DownloadManagerDelegate>
{
    /// 播放进度观察者
    id _playTimeObserver;
    /// 是否移除通知
    BOOL _isRemoveNot;
}
/// 是否同意下载
@property (assign, nonatomic) BOOL isAgreeDownload;
/// 网络状况
@property (assign, nonatomic) ZNetworkReachabilityStatus networkStatus;
/// 总时长
@property (assign, nonatomic) NSInteger durationTime;
/// 播放是否错误
@property (assign, nonatomic) BOOL isReadError;
/// 上一次请求的URL地址;
@property (strong, nonatomic) NSString *lastFileUrl;
/// 播放标记
@property (assign, nonatomic) NSInteger index;
/// 音乐数组
@property (strong, nonatomic) NSArray *modelArray;
/// 实务数组
@property (strong, nonatomic) NSArray *practiceArray;
/// 订阅数组
@property (strong, nonatomic) NSArray *curriculumArray;
/// 功能按钮显示
@property (assign, nonatomic) ZPlayTabBarViewType tabbarType;
/// 正在播放的model->语音对象
@property (strong, nonatomic) ModelAudio *playingModel;
/// 正在播放的model->实务对象
@property (strong, nonatomic) ModelPractice *playingPracticeModel;
/// 正在播放的model->订阅对象
@property (strong, nonatomic) ModelCurriculum *playingCurriculumModel;
///点收藏中
@property (assign, nonatomic) BOOL isCollectioning;
///点赞中
@property (assign, nonatomic) BOOL isPraiseing;
///是否在读文本
@property (assign, nonatomic) BOOL isTexting;
///是否手动停止播放
@property (assign, nonatomic) BOOL isStopPlay;
///是否在播放
@property (assign, nonatomic) BOOL isPlaying;

/// 播放器
@property (nonatomic, strong) AVPlayer *player;
/// 获取播放对象
@property (nonatomic, strong) AVPlayerItem *playerItem;
/// 获取播放对象
@property (nonatomic, strong) AVURLAsset *playerAsset;
///背景图片
@property (strong, nonatomic) UIImageView *imgBackground;
///导航标题
@property (strong, nonatomic) ZLabel *lbTitleNav;
///内容区域
@property (strong, nonatomic) ZPlayObjectInfoView *viewObjectInfo;
///播放按钮区域
@property (strong, nonatomic) ZPlayFunctionView *viewFunction;
///功能按钮区域
@property (strong, nonatomic) ZPlayTabBarView *viewTabbar;
///背景播放设置对象
@property (strong, nonatomic) NSMutableDictionary *dicMusicInfo;

@end

static const NSString *kPlayStatusContext;

static ZPlayerViewController *audioPlayerView;

@implementation ZPlayerViewController

+(ZPlayerViewController *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayerView = [[ZPlayerViewController alloc] init];
        
        audioPlayerView.player = [[AVPlayer alloc] init];
        
        [audioPlayerView innerInit];
        
        [audioPlayerView setAudioSession];
    });
    return audioPlayerView;
}

#pragma mark - PrivateMethod

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

//后台播放相关,且将蓝牙重新连接
-(void)setAudioSession
{
    //AudioSessionInitialize用于控制打断
    //这种方式后台，可以连续播放非网络请求歌曲，遇到网络请求歌曲就废,需要后台申请task
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    if (APP_SYSTEM_VERSION >= 10) {
        BOOL success = [session setCategory:AVAudioSessionCategoryPlayback mode:AVAudioSessionModeMoviePlayback options:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
        if (!success) {
            return;
        }
    } else {
        BOOL success = [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
        if (!success) {
            return;
        }
    }
    ///监听打断状态
    AudioSessionInitialize(NULL, NULL, interruptionNovelListener, (__bridge void *)self);
    
    UInt32 audioCategory = kAudioSessionCategory_MediaPlayback;
    ///设置输出设备通道
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
    ///监听输出设备变化
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audio_route_change_listener, (__bridge void *)self);
    ///设置是否占用通道
    AudioSessionSetActive(TRUE);
}
///监听输出设备变化
static void audio_route_change_listener(void *inClientData,
                                        AudioSessionPropertyID inID,
                                        UInt32 inDataSize,
                                        const void *inData)
{
    if (inID != kAudioSessionProperty_AudioRouteChange) {
        return;
    }
    __unsafe_unretained ZPlayerViewController *eventLoop = (__bridge ZPlayerViewController *)inClientData;
    [eventLoop _handleAudioRouteChangeWithDictionary:(__bridge NSDictionary *)inData];
}
///监听输出设备变化回调处理方法
- (void)_handleAudioRouteChangeWithDictionary:(NSDictionary *)routeChangeDictionary
{
    NSUInteger reason = [[routeChangeDictionary objectForKey:(__bridge NSString *)kAudioSession_RouteChangeKey_Reason] unsignedIntegerValue];
    if (reason != kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
        return;
    }
    
    NSDictionary *previousRouteDescription = [routeChangeDictionary objectForKey:(__bridge NSString *)kAudioSession_AudioRouteChangeKey_PreviousRouteDescription];
    NSArray *previousOutputRoutes = [previousRouteDescription objectForKey:(__bridge NSString *)kAudioSession_AudioRouteKey_Outputs];
    if ([previousOutputRoutes count] == 0) {
        return;
    }
    
    NSString *previousOutputRouteType = [[previousOutputRoutes objectAtIndex:0] objectForKey:(__bridge NSString *)kAudioSession_AudioRouteKey_Type];
    if (previousOutputRouteType == nil ||
        (![previousOutputRouteType isEqualToString:(__bridge NSString *)kAudioSessionOutputRoute_Headphones] &&
         ![previousOutputRouteType isEqualToString:(__bridge NSString *)kAudioSessionOutputRoute_BluetoothA2DP])) {
            return;
        }
}
///设置打断监听的方法
static void interruptionNovelListener(void *inClientData, UInt32 inInterruptionState)
{
    __unsafe_unretained ZPlayerViewController *eventLoop = (__bridge ZPlayerViewController *)inClientData;
    [eventLoop handleAudioSessionInterruptionWithState:inInterruptionState];
}
///处理打断的行为
- (void)handleAudioSessionInterruptionWithState:(UInt32)interruptionState
{
    if (interruptionState == kAudioSessionBeginInterruption) {
        //控制UI，暂停播放
        [self setPausePlay];
    } else if (interruptionState == kAudioSessionEndInterruption) {
        AudioSessionInterruptionType interruptionType = kAudioSessionInterruptionType_ShouldNotResume;
        UInt32 interruptionTypeSize = sizeof(interruptionType);
        OSStatus status;
        status = AudioSessionGetProperty(kAudioSessionProperty_InterruptionType,
                                         &interruptionTypeSize,
                                         &interruptionType);
        if (status == noErr)
        {
            if ([self isStartPlaying]) {
                //控制UI，继续播放
                [self setStartPlay];
            }
        }
    }
}
#pragma clang diagnostic pop

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarAlpha:0];
    
    [[DownLoadManager sharedHelper] setPlayerDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
    
    if (self.tabbarType != ZPlayTabBarViewTypeSubscribe) {
        [self setRightShareButtonOnlyWithWhite];
    }
    
    [self.navigationController.navigationBar setTintColor:WHITECOLOR];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GCDMainBlock(^{
        [self checkDownload];
    });
}

-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [[DownLoadManager sharedHelper] cancel];
    [[DownLoadManager sharedHelper] setPlayerDelegate:nil];
    [self removeObserverAndNotification];
    
    OBJC_RELEASE(_imgBackground);
    OBJC_RELEASE(_lbTitleNav);
    OBJC_RELEASE(_viewObjectInfo);
    OBJC_RELEASE(_imgBackground);
    OBJC_RELEASE(_lastFileUrl);
    OBJC_RELEASE(_viewTabbar);
    OBJC_RELEASE(_viewFunction);
    OBJC_RELEASE(_playerItem);
    OBJC_RELEASE(_player);
    OBJC_RELEASE(_playerAsset);
    OBJC_RELEASE(_playingModel);
    OBJC_RELEASE(_playingPracticeModel);
    OBJC_RELEASE(_playingCurriculumModel);
    OBJC_RELEASE(_dicMusicInfo);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.imgBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.imgBackground setImage:[SkinManager getImageWithName:@"play_background_default"]];
    [self.imgBackground setCenter:self.view.center];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBackground.bounds;
    effectView.center = self.imgBackground.center;
    [effectView setTag:1001];
    UIImageView *imgViewBG = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"play_transparent_back"]];
    [imgViewBG setTag:1002];
    [imgViewBG setFrame:effectView.bounds];
    
    [self.imgBackground addSubview:effectView];
    [self.imgBackground addSubview:imgViewBG];
    [self.imgBackground bringSubviewToFront:effectView];
    [self.imgBackground bringSubviewToFront:imgViewBG];
    [self.view addSubview:self.imgBackground];
    OBJC_RELEASE(blurEffect);
    OBJC_RELEASE(effectView);
    OBJC_RELEASE(imgViewBG);
    
    ZWEAKSELF
    CGFloat functionY = APP_FRAME_HEIGHT-kZPlayTabBarViewHeight-kZPlayFunctionViewHeight;
    CGFloat infoY = APP_TOP_HEIGHT;
    CGFloat infoH = functionY-infoY-20;
    self.viewObjectInfo = [[ZPlayObjectInfoView alloc] initWithFrame:CGRectMake(0, infoY, APP_FRAME_WIDTH, infoH)];
    [self.viewObjectInfo setOnBackgroundChange:^(UIImage *image) {
        [weakSelf.imgBackground setImage:image];
    }];
    [self.view addSubview:self.viewObjectInfo];
    
    self.viewFunction = [[ZPlayFunctionView alloc] initWithPoint:CGPointMake(0, functionY)];
    //改变播放进度
    [self.viewFunction setOnSliderValueChange:^(float value, float maxValue) {
        if (maxValue > 0 && value <= maxValue) {
            [weakSelf setChangeSliderValue:value];
        }
    }];
    //上一首
    [self.viewFunction setOnPreClick:^{
        [weakSelf btnPreClick];
    }];
    //下一首
    [self.viewFunction setOnNextClick:^{
        [weakSelf btnNextClick];
    }];
    //停止
    [self.viewFunction setOnStopClick:^{
        [weakSelf setPausePlay];
    }];
    //播放
    [self.viewFunction setOnPlayClick:^{
        [weakSelf setCheckNetworkToPlay];
    }];
    //播放速度
    [self.viewFunction setOnRateChange:^(float rate) {
        [weakSelf playWithRate:rate];
    }];
    //下载按钮 1未开始下载,2下载中,2暂停下载,4下载完成
    [self.viewFunction setOnDownloadClick:^(ZDownloadStatus type) {
        [weakSelf setDownloadClick:type];
    }];
    [self.view addSubview:self.viewFunction];
    
    [self.view sendSubviewToBack:self.imgBackground];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:WHITECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    
    [super innerInit];
}
///初始化数据
-(void)innerData
{
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice:
            [self setViewPlayData];
            break;
        case ZPlayTabBarViewTypeFound:
            [self setViewPlayData];
            break;
        case ZPlayTabBarViewTypeSubscribe:
            [self setViewPlayCurriculumData];
            break;
    }
}
///是否在播放中
-(BOOL)isStartPlaying
{
    if (APP_SYSTEM_VERSION >= 10) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
#endif
    }
    return self.isPlaying;//self.player.status==AVPlayerStatusReadyToPlay;
}
///获取播放中的列表
-(NSArray *)getPlayDataArray
{
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypeSubscribe:
            return self.curriculumArray;
        case ZPlayTabBarViewTypeFound:
            return self.practiceArray;
        case ZPlayTabBarViewTypePractice:
            return self.practiceArray;
    }
    return nil;
}
///设置网络状况
- (void)setNetworkReachabilityStatus:(ZNetworkReachabilityStatus)status
{
    [self setNetworkStatus:status];
}
///获取网络状况
- (ZNetworkReachabilityStatus)getNetworkReachabilityStatus
{
    return self.networkStatus;
}
/// 各控件设初始值
- (void)initialControls
{
    [self setPausePlay];
    
    if (self.viewFunction) {
        [self.viewFunction setStopPlay];
    }
}

/**
 *  播放器数据传入-实务
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)setViewPlayArray:(NSArray *)array index:(NSInteger)index
{
    _index = index;
    self.playingCurriculumModel = nil;
    self.curriculumArray = nil;
    
    [self setIsStopPlay:YES];
    [[AppDelegate app] setIsPlay:YES];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelPractice *modelP in array) {
        [arr addObject:[[ModelAudio alloc] initWithModel:modelP]];
    }
    [self setModelArray:arr];
    [self setPracticeArray:array];
    
    [self updateAudioPlayer];
}
/**
 *  播放器数据传入-订阅
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)setViewPlayWithCurriculumArray:(NSArray *)array index:(NSInteger)index
{
    _index = index;
    self.playingPracticeModel = nil;
    self.practiceArray = nil;
    self.curriculumArray = nil;
    
    [self setIsStopPlay:YES];
    [[AppDelegate app] setIsPlay:YES];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelCurriculum *modelP in array) {
        [arr addObject:[[ModelAudio alloc] initWithModelCurriculum:modelP]];
    }
    [self setModelArray:arr];
    [self setCurriculumArray:array];
    
    [self updateCurriculumAudioPlayer];
}
/// 改变播放文件对象
- (void)updateAudioPlayer
{
    ModelAudio *modelA = [self.modelArray objectAtIndex:_index];
    ModelAudio *modelLocalA = [sqlite getLocalAudioModelWithId:modelA.ids];
    if (modelLocalA) {
        [modelA setAudioPlayTime:modelLocalA.audioPlayTime];
    }
    // 设置当前播放数据模型
    [self setPlayingModel:modelA];
    ///设置总时长
    [self setMaxDuratuin:modelA.totalDuration.doubleValue];
    //播放的是同一个
    if ([modelA.objId isEqualToString:self.playingPracticeModel.ids] && !_isReadError) {
        if (self.isStartPlaying) {
            [self setStartPlay];
        }
    } else {
        [self setPlayingPracticeModel:[self.practiceArray objectAtIndex:_index]];
        [self.playingPracticeModel setRowIndex:_index];
        
        NSString *fileUrl = [modelA.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (fileUrl != nil && [fileUrl isUrl]) {
            // 设置播放对象
            [self setPlayWithFileUrl:fileUrl];
        } else {
            [self setPausePlay];
            _isReadError = YES;
            [ZProgressHUD showError:kFailedToReadAudioFile];
        }
    }
    [sqlite setLocalAudioWithModel:modelA];
}
/// 改变播放文件对象
- (void)updateCurriculumAudioPlayer
{
    ModelAudio *modelA = [self.modelArray objectAtIndex:_index];
    ModelAudio *modelLocalA = [sqlite getLocalAudioModelWithId:modelA.ids];
    if (modelLocalA) {
        [modelA setAudioPlayTime:modelLocalA.audioPlayTime];
    }
    // 设置当前播放数据模型
    [self setPlayingModel:modelA];
    ///设置总时长
    [self setMaxDuratuin:modelA.totalDuration.doubleValue];
    //播放的是同一个
    if ([modelA.objId isEqualToString:self.playingCurriculumModel.ids] && !_isReadError) {
        if (self.isStartPlaying) {
            [self setStartPlay];
        }
    } else {
        [self setPlayingCurriculumModel:[self.curriculumArray objectAtIndex:_index]];
        [self.playingCurriculumModel setRowIndex:_index];
        
        NSString *fileUrl = [modelA.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (fileUrl != nil && [fileUrl isUrl]) {
            // 设置播放对象
            [self setPlayWithFileUrl:fileUrl];
        } else {
            [self setPausePlay];
            _isReadError = YES;
            [ZProgressHUD showError:kFailedToReadAudioFile];
        }
    }
    [sqlite setLocalAudioWithModel:modelA];
}
/// 设置播放对象
-(void)setPlayWithFileUrl:(NSString *)file
{
    [self setLastFileUrl:file];
    /// 本地缓存地址
    NSString *filePath = [self getFileLocalPathWithFileUrl:file];
    /// 创建播放对象地址
    NSURL *sourceMovieUrl = nil;
    /// 判断本地文件是否存在
    if (filePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        sourceMovieUrl = [NSURL fileURLWithPath:filePath];
    } else {
        sourceMovieUrl = [NSURL URLWithString:file];
    }
    if (_isRemoveNot) {
        // 如果已经存在 移除通知、KVO，各控件设初始值
        [self removeObserverAndNotification];
        [self initialControls];
        _isRemoveNot = NO;
    }
    // 创建播放对象
    NSDictionary *dicParam = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    self.playerAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:dicParam];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.playerAsset automaticallyLoadedAssetKeys:@[@"tracks",@"duration"]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (APP_SYSTEM_VERSION >= 9) {
        self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
    }
#endif
    // 设置播放速度类型
    self.playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmLowQualityZeroLatency;
    // 设置播放对象或者切换播放对象
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (APP_SYSTEM_VERSION >= 10) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
#endif
    if (!_isRemoveNot) {
        // 监听播放状态
        [self monitoringPlayback:self.playerItem];
        // 添加结束播放通知
        [self addObserverForCurrentPlayItem:self.playerItem];
        _isRemoveNot = YES;
    }
    // 检测网络环境-关闭进入界面播放
    //[self setCheckNetworkToPlay];
    ///检测是否有下载列队
    [self checkDownload];
}
///检测网络状态,决定是否播放
-(void)setCheckNetworkToPlay
{
    [self setStartNewPlay];
}
///开始一个新的播放
-(void)setStartNewPlay
{
    // 设置上次播放开始位置
    [self setLastPlayCurrentTime:self.playingModel.audioPlayTime];
    // 先暂停
    if (self.player) {
        [self.player pause];
    }
    // 在开始
    [self setStartPlay];
}
/// 获取音频文件本地缓存路径
-(NSString *)getFileLocalPathWithFileUrl:(NSString *)file
{
    if (file && ![file isKindOfClass:[NSNull class]]) {
        NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:file]] stringByAppendingPathExtension:kPathExtension];
        return filePath;
    }
    return nil;
}
///初始化工具栏
-(void)setInnerPlayTabbarWithType:(ZPlayTabBarViewType)type
{
    if (self.tabbarType == type) {
        return;
    }
    [self setTabbarType:type];
    ZWEAKSELF
    if (self.viewTabbar) {
        [self.viewTabbar removeFromSuperview];
        OBJC_RELEASE(_viewTabbar);
    }
    self.viewTabbar = [[ZPlayTabBarView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT-kZPlayTabBarViewHeight) type: type];
    ///提问
    [self.viewTabbar setOnQuestionClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Comment];
        if ([AppSetting getAutoLogin]) {
            ZCircleQuestionViewController *itemVC = [[ZCircleQuestionViewController alloc] init];
            [itemVC setPreVC:weakSelf];
            [itemVC setPracticeId:model.ids];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:itemVC animated:YES];
        } else {
            [weakSelf showLoginVC];
        }
    }];
    ///问答
    [self.viewTabbar setOnAnswerClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Answer];
        ZPracticeAnswerViewController *itemVC = [[ZPracticeAnswerViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///实务PPT
    [self.viewTabbar setOnPracticePPTClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_PPT];
        if (model.arrImage.count > 0) {
            NSMutableArray *imageUrls = [NSMutableArray new];
            for (NSDictionary *dicImage in model.arrImage) {
                NSURL *url = [NSURL URLWithString:[dicImage objectForKey:@"url"]];
                if (url) {
                    [imageUrls addObject:url];
                }
            }
            ZPhotoBrowser *browser = [[ZPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithURLs:imageUrls]];
            browser.progressTintColor       = MAINCOLOR;
            [weakSelf presentViewController:browser animated:YES completion:nil];
        } else {
            [ZProgressHUD showError:kThePracticeDoesNotSupportThePPT];
        }
    }];
    ///实务文本
    [self.viewTabbar setOnPracticeNoteClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Text];
        ZPracticeContentViewController *itemVC = [[ZPracticeContentViewController alloc] init];
        [itemVC setTitle:model.title];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///实务播放列表
    [self.viewTabbar setOnPlayPracticeClick:^{
        [weakSelf showPlayListView];
    }];
    ///课程播放列表
    [self.viewTabbar setOnPlayCurriculumClick:^{
        [weakSelf showPlayListView];
    }];
    ///赞
    [self.viewTabbar setOnPauseClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Praise];
        [weakSelf btnPraiseClick];
    }];
    ///收藏
    [self.viewTabbar setOnCollectionClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Collection];
        [weakSelf btnCollectionClick];
    }];
    ///课程文本
    [self.viewTabbar setOnCurriculumNoteClick:^(ModelCurriculum *model) {
        [StatisticsManager event:kSubscription_Detail_Text];
        ZCurriculumDetailViewController *itemVC = [[ZCurriculumDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///课程PPT
    [self.viewTabbar setOnCurriculumPPTClick:^(ModelCurriculum *model) {
        [StatisticsManager event:kSubscription_Detail_PPT];
        if (model.course_imges && model.course_imges.count > 0) {
            ZPhotoBrowser *browser = [[ZPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithURLs:model.course_imges]];
            browser.progressTintColor       = MAINCOLOR;
            browser.displayActionButton     = NO;
            [weakSelf presentViewController:browser animated:YES completion:nil];
        } else {
            [ZProgressHUD showError:kTheSubscribeDoesNotSupportThePPT];
        }
    }];
    [self.view addSubview:self.viewTabbar];
}
///获取播放中的对象
-(ModelAudio *)getPlayingModelAudio
{
    return self.playingModel;
}
///显示列表视图
-(void)showPlayListView
{
    ZWEAKSELF
    ZPlayListView *playListView = [[ZPlayListView alloc] initWithPlayListArray:self.modelArray index:_index];
    [playListView setOnPlayItemClick:^(ModelAudio *model, NSInteger rowIndex) {
        if (![model.ids isEqualToString:weakSelf.playingModel.ids]) {
            [weakSelf setIndex:rowIndex];
            
            [weakSelf initStartPlay];
        }
    }];
    [playListView show];
}
///改变播放位置
-(void)setChangeSliderValue:(float)value
{
    if (self.playerItem) {
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(value, 1);
        [self.playerItem seekToTime:dragedCMTime];
        
        [self.playingModel setAudioPlayTime:value];
        
        [self setSavePlayToLocal];
        GCDMainBlock(^{
            [self setStartPlay];
        });
    }
}
///左边按钮
-(void)btnLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
///点赞事件
-(void)btnPraiseClick
{
    if ([AppSetting getAutoLogin]) {
        if (self.isPraiseing) {
            return;
        }
        [self setIsPraiseing:YES];
        ZWEAKSELF
        if (!_playingPracticeModel.isPraise) {
            //点赞
            __weak ModelPractice *modelP = _playingPracticeModel;
            [snsV1 postClickLikeWithAId:_playingPracticeModel.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    if ([modelP.ids isEqualToString:weakSelf.playingPracticeModel.ids]) {
                        
                        [weakSelf.playingPracticeModel setIsPraise:YES];
                        weakSelf.playingPracticeModel.applauds += 1;
                        
                        [weakSelf.viewTabbar setViewDataWithModel:weakSelf.playingPracticeModel];
                        
                        [sqlite setLocalPracticeDetailWithModel:weakSelf.playingPracticeModel userId:[AppSetting getUserDetauleId]];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            __weak ModelPractice *modelP = _playingPracticeModel;
            [snsV1 postClickUnLikeWithAId:_playingPracticeModel.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    if ([modelP.ids isEqualToString:weakSelf.playingPracticeModel.ids]) {
                        [weakSelf.playingPracticeModel setIsPraise:NO];
                        if (weakSelf.playingPracticeModel.applauds > 0) {
                            weakSelf.playingPracticeModel.applauds -= 1;
                        }
                        
                        [weakSelf.viewTabbar setViewDataWithModel:weakSelf.playingPracticeModel];
                        
                        [sqlite setLocalPracticeDetailWithModel:weakSelf.playingPracticeModel userId:[AppSetting getUserDetauleId]];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///收藏事件
-(void)btnCollectionClick
{
    if ([AppSetting getAutoLogin]) {
        if (self.isCollectioning) {
            return;
        }
        [self setIsCollectioning:YES];
        ZWEAKSELF
        if (!self.playingPracticeModel.isCollection) {
            //收藏
            __weak ModelPractice *modelP = _playingPracticeModel;
            [snsV1 getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.playingPracticeModel.ids flag:1 type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsCollectioning:NO];
                    if ([modelP.ids isEqualToString:weakSelf.playingPracticeModel.ids]) {
                        [weakSelf.playingPracticeModel setIsCollection:YES];
                        weakSelf.playingPracticeModel.ccount += 1;
                        
                        [weakSelf.viewTabbar setViewDataWithModel:weakSelf.playingPracticeModel];
                        
                        [sqlite setLocalPracticeDetailWithModel:weakSelf.playingPracticeModel userId:[AppSetting getUserDetauleId]];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsCollectioning:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            __weak ModelPractice *modelP = _playingPracticeModel;
            [snsV1 getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.playingPracticeModel.ids type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsCollectioning:NO];
                    if ([modelP.ids isEqualToString:weakSelf.playingPracticeModel.ids]) {
                        [weakSelf.playingPracticeModel setIsCollection:NO];
                        if (weakSelf.playingPracticeModel.ccount > 0) {
                            weakSelf.playingPracticeModel.ccount -= 1;
                        }
                        [weakSelf.viewTabbar setViewDataWithModel:weakSelf.playingPracticeModel];
                        
                        [sqlite setLocalPracticeDetailWithModel:weakSelf.playingPracticeModel userId:[AppSetting getUserDetauleId]];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsCollectioning:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///分享按钮
-(void)btnShareClick
{
    ZWEAKSELF
    ZShareView *shareView = nil;
    shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [weakSelf btnQZoneClick];
                break;
            case ZShareTypeYouDao:
                [weakSelf btnYouDaoClick];
                break;
            case ZShareTypeYinXiang:
                [weakSelf btnYinXiangClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    switch (type) {
        case WTPlatformTypeWeChatSession:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                    [StatisticsManager event:kSubscription_AcademicProbation_Share_Wechat];
                    break;
                default:
                    [StatisticsManager event:kPractice_Detail_Share_Wechat];
                    break;
            }
            break;
        case WTPlatformTypeWeChatTimeline:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                    [StatisticsManager event:kSubscription_AcademicProbation_Share_WechatCircle];
                    break;
                default:
                    [StatisticsManager event:kPractice_Detail_Share_WechatCircle];
                    break;
            }
            break;
        case WTPlatformTypeQQFriend:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                    [StatisticsManager event:kSubscription_AcademicProbation_Share_QQ];
                    break;
                default:
                    [StatisticsManager event:kPractice_Detail_Share_QQ];
                    break;
            }
            break;
        case WTPlatformTypeQzone:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                    [StatisticsManager event:kSubscription_AcademicProbation_Share_QZone];
                    break;
                default:
                    [StatisticsManager event:kPractice_Detail_Share_QZone];
                    break;
            }
        default: break;
    }
    NSString *title = self.playingModel.audioTitle;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    
    NSString *imageUrl = [Utils getMinPicture:self.playingModel.audioImage];
    NSString *webUrl = kShare_VoiceUrl(self.playingModel.ids);
    
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypeSubscribe:
            webUrl = kApp_CurriculumContentUrl(self.playingCurriculumModel.subscribeId, self.playingCurriculumModel.ids);
            break;
        default:
            break;
    }
    NSString *content = self.playingModel.audioAuthor;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
/// 设置最大滑动值
- (void)setMaxDuratuin:(NSTimeInterval)duration
{
    [self setDurationTime:duration];
    
    [self.viewFunction setMaxDuratuin:duration];
    
    // 设置上次播放开始位置
    [self setLastPlayCurrentTime:self.playingModel.audioPlayTime];
}
/// 设置上次播放时间点
- (void)setLastPlayCurrentTime:(NSTimeInterval)currentTime
{
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime, 1);
    [self.playerItem seekToTime:dragedCMTime];
    
    [self.viewFunction setViewCurrentTime:currentTime];
}

#pragma mark - PrivateMethod

///设置播放数据对象+设置标题
-(void)setViewPlayData
{
    [self.lbTitleNav setText:[NSString stringWithFormat:@"%@%d/%d", kPlayNow, (int)_index+1, (int)_practiceArray.count]];
    
    [self.viewObjectInfo setViewDataWithPracitce:self.playingPracticeModel];
    
    // 更新读取实务的详情数据
    [self.viewFunction setOperEnabled:NO];
    [self.viewTabbar setButtonAllEnabled:NO];
    if (![AppSetting getAutoLogin]) {
        [self.playingPracticeModel setIsPraise:NO];
        [self.playingPracticeModel setIsCollection:NO];
        [self.viewTabbar setViewDataWithModel:self.playingPracticeModel];
    }
    ZWEAKSELF
    [self.viewTabbar setViewDataWithModel:self.playingPracticeModel];
    [snsV1 getPracticeDetailWithPracticeId:_playingPracticeModel.ids userId:[AppSetting getUserDetauleId] resultBlock:^(ModelPractice *resultModel) {
        GCDMainBlock(^{
            if ([resultModel.ids isEqualToString:weakSelf.playingPracticeModel.ids]) {
                
                [weakSelf setPlayingPracticeModel:resultModel];
                
                [weakSelf.viewTabbar setViewDataWithModel:resultModel];
                
                switch (weakSelf.tabbarType) {
                    case ZPlayTabBarViewTypePractice:
                        resultModel.rowIndex = weakSelf.index;
                        resultModel.play_time = weakSelf.playingPracticeModel.play_time;
                        [sqlite setLocalPlayListPracticeListWithModel:resultModel userId:[AppSetting getUserDetauleId]];
                        break;
                    case ZPlayTabBarViewTypeFound:
                        resultModel.rowIndex = weakSelf.index;
                        resultModel.play_time = weakSelf.playingPracticeModel.play_time;
                        [sqlite setLocalPlayListPracticeFoundWithModel:resultModel userId:[AppSetting getUserDetauleId]];
                        break;
                    default: break;
                }
            }
            if (weakSelf.modelArray.count > 1) {
                [weakSelf.viewFunction setOperEnabled:YES];
            }
            [weakSelf.viewTabbar setButtonAllEnabled:YES];
            
            [sqlite setLocalPlayrecordPracticeWithModel:resultModel];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (weakSelf.modelArray.count > 1) {
                [weakSelf.viewFunction setOperEnabled:YES];
            }
            [weakSelf.viewTabbar setButtonAllEnabled:YES];
        });
    }];
}
///设置播放数据对象+设置标题
-(void)setViewPlayCurriculumData
{
    [self.lbTitleNav setText:[NSString stringWithFormat:@"%@%d/%d", kPlayNow, (int)_index+1, (int)self.curriculumArray.count]];
    
    if (self.modelArray.count > 1) {
        [self.viewFunction setOperEnabled:YES];
    } else {
        [self.viewFunction setOperEnabled:NO];
    }
    [self.viewTabbar setButtonAllEnabled:YES];
    [self.viewTabbar setViewDataWithModelCurriculum:self.playingCurriculumModel];
    
    [self.viewObjectInfo setViewDataWithSubscribe:self.playingCurriculumModel];
}
/// 下一曲事件
- (void)nextIndexAdd
{
    _index++;
    if (_index == _modelArray.count) {
        _index = 0;
    }
}
/// 上一曲事件
- (void)previousIndexSub
{
    _index--;
    if (_index < 0) {
        _index = _modelArray.count -1;
    }
}
///上一首
- (void)btnPreClick
{
    [self previousIndexSub];
    
    [self initStartPlay];
}
///下一首
- (void)btnNextClick
{
    [self nextIndexAdd];
    
    [self initStartPlay];
}
/// 重新开始播放
- (void)initStartPlay
{
    [self initialControls];
    
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice:
            [self updateAudioPlayer];
            
            [self setViewPlayData];
            break;
        case ZPlayTabBarViewTypeFound:
            [self updateAudioPlayer];
            
            [self setViewPlayData];
            break;
        case ZPlayTabBarViewTypeSubscribe:
            [self updateCurriculumAudioPlayer];
            
            [self setViewPlayCurriculumData];
            break;
    }
    [self setCheckNetworkToPlay];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:self.playingModel];
}
//检测当前对象是否已经下载
-(void)checkDownload
{
    if (self.playingModel) {
        [self.viewFunction setDownloadProgress:0];
        
        NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.playingModel.audioPath]] stringByAppendingPathExtension:kPathExtension];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self.viewFunction setDownloadButtonImageNoSuspend:ZDownloadStatusEnd];
            return;
        }
        [self.viewFunction setDownloadButtonImageNoSuspend:ZDownloadStatusNomral];
    }
}
//下载按钮
-(void)setDownloadClick:(ZDownloadStatus)type
{
    if (![AppSetting getAutoLogin]) {
        [self showLoginVC];
        return;
    }
    if (type == ZDownloadStatusEnd) {
        return;
    }
    NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.playingModel.audioPath]] stringByAppendingPathExtension:kPathExtension];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self.viewFunction setDownloadButtonImageNoSuspend:(ZDownloadStatusEnd)];
        return;
    }
    switch (self.networkStatus) {
        case ZNetworkReachabilityStatusUnknown:
            [ZProgressHUD showError:kCMsgContentUnusual];
            break;
        case ZNetworkReachabilityStatusNotReachable:
            [ZProgressHUD showError:kCMsgContentError];
            break;
        case ZNetworkReachabilityStatusReachableViaWWAN:
            if (self.isAgreeDownload) {
                [self setCheckDownload:type];
            } else {
                ZWEAKSELF
                [ZAlertView showWithTitle:nil message:kCMsgShowDownloadPlayPrompt completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    [weakSelf setIsAgreeDownload:NO];
                    switch (selectIndex) {
                        case 0:
                        {
                            [weakSelf setIsAgreeDownload:YES];
                            
                            [weakSelf setCheckDownload:type];
                            break;
                        }
                        default: break;
                    }
                } cancelTitle:kDownload doneTitle:kCancel];
            }
            break;
        case ZNetworkReachabilityStatusReachableViaWiFi:
            [self setCheckDownload:type];
            break;
        default: break;
    }
}
-(void)setCheckDownload:(ZDownloadStatus)type
{
    switch (type) {
        case ZDownloadStatusNomral:
            [self setStartDownload];
            break;
        case ZDownloadStatusStart:
            [self setSuspendDownload];
            break;
        default: break;
    }
}
///开始下载
-(void)setStartDownload
{
    [[DownLoadManager sharedHelper] setDownloadWithModel:self.playingModel];
}
///暂停下载
-(void)setSuspendDownload
{
    [[DownLoadManager sharedHelper] suspend];
    [self.viewFunction setDownloadButtonImageNoSuspend:(ZDownloadStatusNomral)];
}
///播放
-(void)playWithRate:(float)rate
{
    if (!self.isStopPlay) {
        _isReadError = NO;
        
        if (self.player) {
            [self.player pause];
            [self.player setRate:0];
            [self.player play];
            [self.player setRate:rate];
        }
    }
}
///开始播放
-(void)setStartPlay
{
    _isReadError = NO;
    if (self.player) {
        [self.player play];
    }
    [self setIsStopPlay:NO];
    [self setIsPlaying:YES];
    
    ///处理播放倍率
    int rate = [AppSetting getRate];
    [self.player setRate:0];
    switch (rate) {
        case 1:
            if (self.player) {
                [self.player setRate:1.0];
            }
            break;
        case 2:
            if (self.player) {
                [self.player setRate:1.25];
            }
            break;
        case 3:
            if (self.player) {
                [self.player setRate:1.5];
            }
            break;
        default:
            break;
    }
    
    if (self.viewFunction) {
        [self.viewFunction setStartPlay];
    }
}
///暂停
-(void)setPausePlay
{
    [self setIsStopPlay:YES];
    [self setIsPlaying:NO];
    
    [self waiting];
    
    [self setSavePlayToLocal];
}
///缓冲
-(void)waiting
{
    _isReadError = NO;
    [self setIsPlaying:NO];
    if (self.player) {
        [self.player pause];
    }
    if (self.viewFunction) {
        [self.viewFunction setPausePlay];
    }
}
///保存对象到本地
-(void)setSavePlayToLocal
{
    if (self.playingModel) {
        [sqlite setLocalAudioWithModel:self.playingModel];
    }
    NSString *eventKey = kSubscription_List_PlayTime;
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice:
            self.playingPracticeModel.play_time = self.playingModel.audioPlayTime;
            [sqlite setLocalPlayListPracticeListWithModel:self.playingPracticeModel userId:[AppSetting getUserDetauleId]];
            break;
        case ZPlayTabBarViewTypeFound:
            self.playingPracticeModel.play_time = self.playingModel.audioPlayTime;
            [sqlite setLocalPlayListPracticeFoundWithModel:self.playingPracticeModel userId:[AppSetting getUserDetauleId]];
            break;
        case ZPlayTabBarViewTypeSubscribe:
            eventKey = kPractice_List_PlayTime;
            self.playingCurriculumModel.play_time = self.playingModel.audioPlayTime;
            [sqlite setLocalPlayListSubscribeCurriculumListWithModel:self.playingCurriculumModel userId:[AppSetting getUserDetauleId]];
            break;
    }
    if (self.playingModel && self.playingModel.ids) {
        [StatisticsManager event:eventKey value:self.playingModel.audioPlayTime dictionary:@{kObjectId:self.playingModel.ids==nil?kEmpty:self.playingModel.ids,kObjectTitle:self.playingModel.audioTitle==nil?kEmpty:self.playingModel.audioTitle,kObjectUser:[AppSetting getUserDetauleId]}];
    }
}
-(void)setSaveLocalPlay
{
    [self.playingModel setProgress:1];
    [self.playingModel setAddress:ZDownloadStatusEnd];
    [sqlite addLocalDownloadAudioWithModel:self.playingModel userId:[AppSetting getUserDetauleId]];
}
///提问发布成功
-(void)setPublishPracticeQuestion:(ModelPracticeQuestion *)modelPQ
{
    
}

#pragma mark - PlayTimeObserver

/// 注册播放监听回调
- (void)monitoringPlayback:(AVPlayerItem *)item
{
    ZWEAKSELF
    //监听播放进度，这里设置每秒执行30次
    _playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 计算当前在第几秒
        NSTimeInterval currentPlayTime = (NSTimeInterval)item.currentTime.value/item.currentTime.timescale;
        
        [weakSelf updateVideoSlider:currentPlayTime];
    }];
}
/// 改变进度位置
- (void)updateVideoSlider:(NSTimeInterval)currentTime
{
    if ([[AppDelegate app] appEnterBackground]) {
        [self setLockViewWithCurrentTime:currentTime];
    }
    if (self.viewFunction) {
        [self.viewFunction setViewCurrentTime:currentTime];
    }
    
    self.playingModel.audioPlayTime = currentTime;
    
    //[self setPlayTimeToFile];
}
/// 写入播放时间到文件
-(void)setPlayTimeToFile
{
    if (self.playingModel && self.playingModel.ids && self.playingModel.objId) {
        NSString *timeFile = [self getPlayTimePath];
        NSString *playTime = [NSString stringWithFormat:@"%f", self.playingModel.audioPlayTime];
        NSString *playType = [NSString stringWithFormat:@"%d", self.playingModel.audioPlayType];
        NSDictionary *dicPlay = [NSDictionary dictionaryWithObjectsAndKeys:
                                 playTime,@"playtime",
                                 self.playingModel.ids,@"ids",
                                 self.playingModel.objId,@"objid",
                                 playType,@"playtype", nil];
        GCDGlobalBlock(^{
            [dicPlay writeToFile:timeFile atomically:YES];
        });
    }
}
/// 最后一次播放记录文件地址
-(NSString*)getPlayTimePath
{
    NSString *timeFile = [[[AppSetting getTempFilePath] stringByAppendingPathComponent:@"PlayTime"] stringByAppendingPathExtension:@"plist"];
    return timeFile;
}
#pragma mark - KVO Add Notification

/// 监听代码
- (void)addObserverForCurrentPlayItem:(AVPlayerItem*)currentPlayerItem
{
    [currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&kPlayStatusContext];
    [currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:&kPlayStatusContext];
    [currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:&kPlayStatusContext];
    [currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:&kPlayStatusContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlayFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:currentPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlayFailed:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:currentPlayerItem];
    ///监听耳机切换事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChanged:)
                                                 name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - KVO Remove Notification

/// 移除监听
-(void)removeObserverForCurrentPlayItem:(AVPlayerItem*)currentPlayerItem
{
    if (currentPlayerItem) {
        [currentPlayerItem removeObserver:self forKeyPath:@"status" context:&kPlayStatusContext];
        [currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:&kPlayStatusContext];
        [currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:&kPlayStatusContext];
        [currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:&kPlayStatusContext];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}
/// 删除注册的通知
- (void)removeObserverAndNotification
{
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
    [self removeObserverForCurrentPlayItem:self.playerItem];
    [self removeTimeObserver];
    self.playerAsset = nil;
    self.playerItem = nil;
}
/// 暂停播放回调通知
- (void)removeTimeObserver
{
    if (self.player) {
        [self.player removeTimeObserver:_playTimeObserver];
    }
    _playTimeObserver = nil;
}

#pragma mark - KVO Oper Notification

/// 耳机状态改变
-(void)audioRouteChanged:(NSNotification *)sender
{
    NSDictionary *interuptionDict = sender.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            //耳机插入
            [self setStartPlay];
            break;
        }
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            //耳机取消
            [self setPausePlay];
            break;
        }
        default:break;
    }
}
/// 收到播放完成的通知
-(void)onPlayFinished:(NSNotification *)sender
{
    if (self.viewFunction) {
        [self.viewFunction setStopPlay];
    }
    if (self.playerItem) {
        [self.playerItem seekToTime:kCMTimeZero];
    }
    [self.playingModel setAudioPlayTime:0];
    if (self.modelArray.count <= 1) {
        [self initStartPlay];
    } else {
        [self btnNextClick];
    }
}
/// 播放出问题的通知
-(void)onPlayFailed:(NSNotification *)sender
{
    [self setPausePlay];
    _isReadError = YES;
    [ZProgressHUD showError:kFailedToReadAudioFile];
}

#pragma mark - KVO Player Status

/// 注册播放状态通知
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kPlayStatusContext) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            switch (item.status) {
                case AVPlayerStatusReadyToPlay:
                {
                    _isReadError = NO;
                    /// TODO:ZWW备注-播放时间使用服务器的就屏蔽此方法
                    //[self setMaxDuratuin:CMTimeGetSeconds(item.duration)];
                    break;
                }
                case AVPlayerStatusFailed:
                {
                    [self initialControls];
                    _isReadError = YES;
                    if (self.viewFunction) {
                        [self.viewFunction setStopPlay];
                    }
                    break;
                }
                case AVPlayerItemStatusUnknown:
                {
                    [self initialControls];
                    _isReadError = YES;
                    if (self.viewFunction) {
                        [self.viewFunction setStopPlay];
                    }
                    break;
                }
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (self.playerItem) {
                    //kvo触发的另外一个属性
                    NSArray *array = [self.playerItem loadedTimeRanges];
                    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
                        //获取范围i
                        CMTimeRange range = [array.firstObject CMTimeRangeValue];
                        //从哪儿开始的
                        CGFloat start = CMTimeGetSeconds(range.start);
                        //缓存了多少
                        CGFloat duration = CMTimeGetSeconds(range.duration);
                        //一共缓存了多少
                        CGFloat allCache = start+duration;
                        //设置缓存的百分比
                        CMTime allTime = [self.playerItem duration];
                        //转换
                        CGFloat time = CMTimeGetSeconds(allTime);
                        CGFloat y = allCache/time;
                        GCDMainBlock(^{
                            [self.viewFunction setViewProgress:y];
                        });
                    }
                }
            });
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            //缓冲开始
            _isReadError = NO;
            //等待
            [self waiting];
        }  else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            //缓冲结束
            _isReadError = NO;
            if (!self.isStopPlay) {
                [self setStartPlay];
            }
        }
    }
}
#pragma mark - UIEventTypeRemoteControl
/// 远程控制播放器
- (void)setPlayRemoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay://播放
                [self setStartPlay];
                break;
            case UIEventSubtypeRemoteControlPause://暂停
                [self setPausePlay];
                break;
            case UIEventSubtypeRemoteControlStop://停止
                [self setPausePlay];
                break;
            case UIEventSubtypeRemoteControlNextTrack://下一首
                [self btnNextClick];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack://上一首
                [self btnPreClick];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward://开始向前拖拽
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward://结束向前拖拽
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward://开始向后拖拽
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward://结束向后拖拽
                break;
            default: break;
        }
    }
}

#pragma mark - AppBackgroundPlayingInfo

/// 设置当前播放语音的效果
- (void)setLockViewWithCurrentTime:(CGFloat)currentTime
{
    if (self.playingModel == nil) {
        return;
    }
    if(NSClassFromString(@"MPNowPlayingInfoCenter")) {
        [self.dicMusicInfo removeAllObjects];
        // 设置Singer
        [self.dicMusicInfo setObject:self.playingModel.audioAuthor forKey:MPMediaItemPropertyArtist];
        // 设置歌曲名
        [self.dicMusicInfo setObject:self.playingModel.audioTitle forKey:MPMediaItemPropertyTitle];
        // 设置封面
        UIImage *img = nil;
        NSString *imgPath = [[[AppSetting getPictureFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.playingModel.audioImage]] stringByAppendingPathExtension:kPathExtension];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
            img = [UIImage imageWithContentsOfFile:imgPath];
        }
        if (img == nil) {
            img = [SkinManager getImageWithName:@"Icon"];
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:img];
        [self.dicMusicInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
        //音乐剩余时长
        [self.dicMusicInfo setObject:[NSNumber numberWithInteger:self.durationTime] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间
        [self.dicMusicInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.dicMusicInfo];
        OBJC_RELEASE(artwork);
        OBJC_RELEASE(imgPath);
        OBJC_RELEASE(img);
    }
}
-(NSMutableDictionary *)dicMusicInfo
{
    if (_dicMusicInfo == nil) {
        _dicMusicInfo = [NSMutableDictionary dictionary];
    }
    return _dicMusicInfo;
}

#pragma mark - DownloadManagerDelegate

-(void)ZDownLoadTaskDidDownLoading:(ModelAudio *)model
{
    if ([self.playingModel.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [ZProgressHUD showSuccess:kDownloadCourse];
        });
    }
}
-(void)ZDownloadManagerDidErrorDownLoad:(ModelAudio *)model didReturnError:(NSError *)error
{
    if ([self.playingModel.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [self.viewFunction setDownloadButtonImageNoSuspend:ZDownloadStatusNomral];
        });
    }
}
-(void)ZDownloadManagerDidFinishDownLoad:(ModelAudio *)model
{
    if ([self.playingModel.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [self.viewFunction setDownloadButtonImageNoSuspend:ZDownloadStatusEnd];
        });
    }
}
-(void)ZDownloadManager:(ModelAudio *)model didReceiveProgress:(float)progress
{
    if ([self.playingModel.ids isEqualToString:model.ids]) {
        [self.viewFunction setDownloadProgress:progress];
    } else {
        [self.viewFunction setDownloadProgress:0];
    }
}

@end
