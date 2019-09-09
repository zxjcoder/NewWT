//
//  AudioPlayerView.m
//  PlaneCircle
//
//  Created by Daniel on 7/4/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AudioPlayerView.h"
#import "Utils.h"
#import "ZSlider.h"
#import "ClassCategory.h"
#import "AppSetting.h"
#import "SQLiteOper.h"
#import "AppDelegate.h"
#import "ZFont.h"

@interface AudioPlayerView()
{
    /// 获取播放对象
    AVPlayerItem *playerItem;
    /// 获取播放对象
    AVURLAsset *playerAsset;
    /// 播放进度观察者
    id _playTimeObserver;
    /// 音乐数组
    NSArray *_modelArray;
    /// 实务数组
    NSArray *_practiceArray;
    /// 播放标记
    NSInteger _index;
    /// 播放状态 YES播放 NO暂停,停止
    BOOL isPlaying;
    /// 缓冲播放
    BOOL isWaiting;
    /// 是否移除通知
    BOOL isRemoveNot;
    /// 播放是否错误
    BOOL _isReadError;
    /// 正在缓冲
    BOOL _isWaiting;
    /// 是否点击停止播放
    BOOL _isStopPlay;
    /// 是否显示
    BOOL _isShow;
    /// 是否显示动画中
    BOOL _isShowAnimate;
    /// 播放模式
    AudioPlayerMode _playerMode;
    /// 正在播放的model->语音对象
    ModelAudio *_playingModel;
    /// 正在播放的model->实务对象
    ModelPractice *_playingPracticeModel;
    /// 总时间
    NSTimeInterval _totalTime;
    /// 上一次请求的URL地址;
    NSString *_lastFileUrl;
}

///播放器
@property (nonatomic, strong) AVPlayer *player;
///播放器显示层
//@property (nonatomic, strong) AVPlayerLayer *playerLayer;
///滑动
@property (strong, nonatomic) UISlider *slider;
///内容区域
@property (strong, nonatomic) UIView *viewContent;
///总时长
@property (strong, nonatomic) UIImageView *imgTime;
///总时长
@property (strong, nonatomic) UILabel *lbTime;
///进度时间
@property (strong, nonatomic) UIImageView *imgProgress;
///进度时间
@property (strong, nonatomic) UILabel *lbProgress;
///上一条
@property (strong, nonatomic) UIButton *btnPre;
///下一条
@property (strong, nonatomic) UIButton *btnNext;
///暂停或停止或播放中
@property (strong, nonatomic) UIButton *btnPlay;
///评论
@property (strong, nonatomic) UIButton *btnComment;
///提问
@property (strong, nonatomic) UIButton *btnQuestion;
///是否显示进度条
@property (assign, nonatomic) BOOL isShowProgress;

@end

static const NSString *AudioPlayerItemStatusContext;

static AudioPlayerView *audioPlayerView;

@implementation AudioPlayerView

+(AudioPlayerView *)shareAudioPlayerView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayerView = [[AudioPlayerView alloc] init];
        
        audioPlayerView.player = [[AVPlayer alloc] init];
//        audioPlayerView.playerLayer = [AVPlayerLayer playerLayerWithPlayer:audioPlayerView.player];
        
        [audioPlayerView setAudioSession];
    });
    return audioPlayerView;
}

#pragma mark - PrivateMethod

//后台播放相关,且将蓝牙重新连接
-(void)setAudioSession
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    //AudioSessionInitialize用于控制打断
    //这种方式后台，可以连续播放非网络请求歌曲，遇到网络请求歌曲就废,需要后台申请task
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL success = [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) {
        return;
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
    
#pragma clang diagnostic pop
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
    __unsafe_unretained AudioPlayerView *eventLoop = (__bridge AudioPlayerView *)inClientData;
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
    __unsafe_unretained AudioPlayerView *eventLoop = (__bridge AudioPlayerView *)inClientData;
    [eventLoop handleAudioSessionInterruptionWithState:inInterruptionState];
}
///处理打断的行为
- (void)handleAudioSessionInterruptionWithState:(UInt32)interruptionState
{
    if (interruptionState == kAudioSessionBeginInterruption) {
        //控制UI，暂停播放
        [self pause];
    } else if (interruptionState == kAudioSessionEndInterruption) {
        AudioSessionInterruptionType interruptionType = kAudioSessionInterruptionType_ShouldNotResume;
        UInt32 interruptionTypeSize = sizeof(interruptionType);
        OSStatus status;
        status = AudioSessionGetProperty(kAudioSessionProperty_InterruptionType,
                                         &interruptionTypeSize,
                                         &interruptionType);
        if (status == noErr)
        {
            _isStopPlay = [[sqlite getSysParamWithKey:kSQLITE_LAST_STOPPLAYSTATE] boolValue];
            if (!_isStopPlay) {
                //控制UI，继续播放
                [self play];
            }
        }
    }
}

#pragma mark - SuperMethod

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, APP_FRAME_HEIGHT-APP_PLAY_HEIGHT, APP_FRAME_WIDTH, APP_PLAY_HEIGHT)];
    if (self) {
        [self innerInitView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitView];
    }
    return self;
}

#pragma mark - PrivateMethod

-(void)innerInitView
{
    [self setHidden:YES];
    [self setAlpha:0.0f];
    
    _playerMode = AudioPlayerModeOrderPlay;
    _isStopPlay = [[sqlite getSysParamWithKey:kSQLITE_LAST_STOPPLAYSTATE] boolValue];
 
    [self setBackgroundColor:CLEARCOLOR];
    
    [self innerInit];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

-(void)innerInit
{
    CGFloat proW = 130/2;
    CGFloat proH = 66/2;
    self.imgProgress = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_progress_time_bg"]];
    [self.imgProgress setHidden:YES];
    [self.imgProgress setAlpha:0.0f];
    [self.imgProgress setFrame:CGRectMake(self.width/2-proW/2, -30, proW, proH)];
    [self addSubview:self.imgProgress];
    
    self.lbTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, proW, 20)];
    [self.lbTime setTextColor:WHITECOLOR];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setText:@"00:00:00"];
    [self.lbTime setTextAlignment:(NSTextAlignmentCenter)];
    [self.imgProgress addSubview:self.lbTime];
    
    self.slider = [[ZSlider alloc] initWithFrame:CGRectMake(0, 0, self.width, 15)];
    [self.slider setContinuous:YES];
    [self.slider setMinimumValue:0.0000f];
    [self.slider setMaximumValue:0.0000f];
    [self.slider setMinimumTrackTintColor:MAINCOLOR];
    [self.slider setMaximumTrackTintColor:RGBCOLOR(246, 246, 246)];
    [self.slider setThumbTintColor:MAINCOLOR];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"p_progess_btn"] forState:(UIControlStateNormal)];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"p_progess_btn"] forState:(UIControlStateHighlighted)];
    [self.slider setMinimumTrackImage:[SkinManager getImageWithName:@"p_progess_s"] forState:(UIControlStateNormal)];
    [self.slider setMinimumTrackImage:[SkinManager getImageWithName:@"p_progess_s"] forState:(UIControlStateHighlighted)];
    [self.slider setMaximumTrackImage:[SkinManager getImageWithName:@"p_progess_d"] forState:(UIControlStateNormal)];
    [self.slider setMaximumTrackImage:[SkinManager getImageWithName:@"p_progess_d"] forState:(UIControlStateHighlighted)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchUpOutside)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchCancel)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.slider];
    
    CGFloat contentY = 6;
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, contentY, self.width, self.height-contentY)];
    [self.viewContent setBackgroundColor:RGBCOLOR(254,241,231)];
    [self addSubview:self.viewContent];
    
    CGFloat timeS = 12;
    self.imgTime = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.viewContent.height/2-timeS/2, timeS, timeS)];
    [self.imgTime setImage:[SkinManager getImageWithName:@"p_timeicon_black"]];
    [self.viewContent addSubview:self.imgTime];
    
    CGFloat lbH = 20;
    CGFloat lbPY = self.viewContent.height/2-lbH/2+1;
    CGFloat lbPX = self.imgTime.x+timeS+3;
    CGFloat lbPW = 70;
    self.lbProgress = [[UILabel alloc] initWithFrame:CGRectMake(lbPX, lbPY, lbPW, lbH)];
    [self.lbProgress setText:@"00:00:00"];
    [self.lbProgress setTextColor:DESCCOLOR];
    [self.lbProgress setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbProgress setNumberOfLines:1];
    [self.lbProgress setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbProgress];
    
    CGFloat btnS = self.viewContent.height-5;
    CGFloat btnY = 2.5;
    self.btnPre = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPre setImage:[SkinManager getImageWithName:@"p_shape_b"] forState:(UIControlStateNormal)];
    [self.btnPre setImage:[SkinManager getImageWithName:@"p_shape_b"] forState:(UIControlStateHighlighted)];
    [self.btnPre setFrame:CGRectMake(self.viewContent.width/2-btnS-30, btnY, btnS, btnS)];
    [self.btnPre setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPre];
    
    self.btnPlay = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateHighlighted)];
    [self.btnPlay setFrame:CGRectMake(self.viewContent.width/2-btnS/2, btnY, btnS, btnS)];
    [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPlay];
    
    self.btnNext = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNext setImage:[SkinManager getImageWithName:@"p_shape_g"] forState:(UIControlStateNormal)];
    [self.btnNext setImage:[SkinManager getImageWithName:@"p_shape_g"] forState:(UIControlStateHighlighted)];
    [self.btnNext setFrame:CGRectMake(self.viewContent.width/2+30, btnY, btnS, btnS)];
    [self.btnNext setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnNext];
    
    CGFloat btnW = 43;
    CGFloat btnH = 28;
    CGFloat btnCX = self.viewContent.width-btnW-8;
    CGFloat btnCY = self.viewContent.height/2-btnH/2;
//    self.btnComment = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.btnComment setFrame:CGRectMake(btnCX, btnCY, btnW, btnH)];
//    [self.btnComment setTitle:@"评论" forState:(UIControlStateNormal)];
//    [self.btnComment setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
//    [self.btnComment setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
//    [[self.btnComment titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
//    [self.btnComment addTarget:self action:@selector(btnCommentClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.viewContent addSubview:self.btnComment];
    
    self.btnQuestion = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnQuestion setFrame:CGRectMake(btnCX, btnCY, btnW, btnH)];
    [self.btnQuestion setTitle:@"提问" forState:(UIControlStateNormal)];
    [self.btnQuestion setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnQuestion setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnQuestion titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnQuestion addTarget:self action:@selector(btnQuestionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnQuestion];

    
    [self sendSubviewToBack:self.viewContent];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeObserverAndNotification];
    
    OBJC_RELEASE(_player);
    
    OBJC_RELEASE(_playingModel);
    OBJC_RELEASE(_playingPracticeModel);
    
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbProgress);
    OBJC_RELEASE(_btnPre);
    OBJC_RELEASE(_btnNext);
    OBJC_RELEASE(_btnPlay);
    OBJC_RELEASE(_btnComment);
    OBJC_RELEASE(_btnQuestion);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_slider);
    OBJC_RELEASE(_imgTime);
    OBJC_RELEASE(_imgProgress);
    
    OBJC_RELEASE(_lastFileUrl);
}

#pragma mark - PrivateMethod

/// 各控件设初始值
- (void)initialControls
{
    [self pause];
    
    [self.lbTime setText:@"00:00:00"];
    [self.lbProgress setText:@"00:00:00"];
    [self.slider setValue:0.0f];
}
/**
 *  播放器数据传入
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)setPlayArray:(NSArray *)array index:(NSInteger)index
{
    _index = index;
    
    [[ZDragButton shareDragButton] setPlayArray:array rowIndex:index];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelPractice *modelP in array) {
        [arr addObject:[[ModelAudio alloc] initWithModel:modelP]];
    }
    _practiceArray = array;
    _modelArray = [NSArray arrayWithArray:arr];
    
    [self setOperButtonEnabled:array.count > 1];
    
    [self.btnComment setHidden:NO];
    [self.btnQuestion setHidden:NO];
    
    [self updateAudioPlayer];
}
/// 改变播放文件对象
- (void)updateAudioPlayer
{
    ModelAudio *modelA = [_modelArray objectAtIndex:_index];
    //播放的是同一个
    if ([modelA.ids isEqualToString:_playingModel.ids] && !_isReadError) {
        _isStopPlay = [[sqlite getSysParamWithKey:kSQLITE_LAST_STOPPLAYSTATE] boolValue];
        if (!isPlaying && !_isStopPlay) {
            [self play];
        }
    } else {
        // 设置当前播放数据模型
        _playingModel = modelA;
        _playingPracticeModel = [_practiceArray objectAtIndex:_index];
        [_playingPracticeModel setRowIndex:_index];
        // TODO:ZWW备注-测试播放器
        //NSString *fileUrl = @"http://m2.music.126.net/feplW2VPVs9Y8lE_I08BQQ==/1386484166585821.mp3";
        NSString *fileUrl = [modelA.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        isPlaying = NO;
        // 设置是否暂停播放
        _isStopPlay = NO;
        [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"NO"];
        if (fileUrl != nil && [fileUrl isUrl]) {
            // 设置播放对象
            if ([NSThread isMainThread]) {
                [self setPlayWithFileUrl:fileUrl];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setPlayWithFileUrl:fileUrl];
                });
            }
        } else {
            [self pause];
            _isReadError = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayErrorNotification object:nil];
        }
    }
    isRemoveNot = YES;
}
/// 设置播放对象
-(void)setPlayWithFileUrl:(NSString *)file
{
    if (isRemoveNot) {
        // 如果已经存在 移除通知、KVO，各控件设初始值
        [self removeObserverAndNotification];
        [self initialControls];
        isRemoveNot = NO;
    }
    _lastFileUrl = file==nil?kEmpty:file;
    ///本地缓存地址
    NSString *filePath = [self getFileLocalPathWithFileUrl:file];
    /// 创建播放对象地址
    NSURL *sourceMovieUrl = nil;
    BOOL _isLocal = NO;
    /// 判断本地文件是否存在
    if (filePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _isLocal = YES;
        sourceMovieUrl = [NSURL fileURLWithPath:filePath];
    } else {
        sourceMovieUrl = [NSURL URLWithString:file];
    }
    // 创建播放对象
    NSDictionary *dicParam = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    playerAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:dicParam];
    playerItem = [AVPlayerItem playerItemWithAsset:playerAsset];
    if (APP_SYSTEM_VERSION >= 9) {
        [playerItem setCanUseNetworkResourcesForLiveStreamingWhilePaused:YES];
    }
    // 设置播放对象或者切换播放对象
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    // 监听播放状态
    [self monitoringPlayback:playerItem];
    // 添加结束播放通知
    [self addObserverForCurrentPlayItem:playerItem];
    if (_isLocal) {
        // 播放
        [self play];
    } else {
        // 缓冲播放
        [self waiting];
    }
}
/// 开始处理文件缓存
- (void)resourceLoaderPlayFile:(NSString *)file
{
    NSString *filePath = [self getFileLocalPathWithFileUrl:file];
    ///判断本地文件是否存在
    if (filePath && ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 下载文件缓存到本地
        [DataOper downloadFileDataWithFileUrl:file localPath:filePath completionBlock:^(NSData *fileData) {
            
        } progressBlock:^(NSProgress *uploadProgress) {
            
        } errorBlock:^(NSError *error) {
            
        }];
    }
}
/// 获取音频文件本地缓存路径
-(NSString *)getFileLocalPathWithFileUrl:(NSString *)file
{
    if (file && ![file isKindOfClass:[NSNull class]]) {
        NSArray *arr = [file componentsSeparatedByString:@"."];
        NSString *fileName = nil;
        if (arr.count > 0) {
            fileName = [NSString stringWithFormat:@"%@.%@",[Utils stringMD5:file],arr.lastObject];
        } else {
            fileName = [NSString stringWithFormat:@"%@.mp3",[Utils stringMD5:file]];
        }
        NSString *filePath = [[AppSetting getAudioFilePath] stringByAppendingPathComponent:fileName];
        return filePath;
    }
    return nil;
}

#pragma mark - PublicEvent

/// 禁止上一个下一个
-(void)setOperButtonEnabled:(BOOL)isEnabled
{
    if (_modelArray.count <= 1 && isEnabled) {
        isEnabled = NO;
    }
    [self.btnPre setHidden:!isEnabled];
    [self.btnNext setHidden:!isEnabled];
    
    [self.btnComment setHidden:!isEnabled];
    [self.btnQuestion setHidden:!isEnabled];
    
    [self.btnPre setEnabled:isEnabled];
    [self.btnNext setEnabled:isEnabled];
}

#pragma mark - PrivateEvent

/// 评论按钮
-(void)btnCommentClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayCommentNotification object:nil];
}
-(void)btnQuestionClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayQuestionNotification object:nil];
}
/// 停止拖动
-(void)sliderRemoveFocus:(UISlider *)sender
{
    if (self.isShowProgress) {
        
        self.isShowProgress = NO;
        
        [self setChangeSliderValue:sender.value];
        
        [self.imgProgress setAlpha:1.0f];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.imgProgress setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.imgProgress setHidden:YES];
        }];
    }
}
/// 改变值
-(void)sliderValueChanged:(UISlider *)sender
{
    if (!self.isShowProgress) {
        
        self.isShowProgress = YES;
        
        [self.imgProgress setHidden:NO];
        
        [self.imgProgress setAlpha:0.0f];
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.imgProgress setAlpha:1.0f];
        }];
    }
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:sender.value];
}
/// 设置拖动时间节点
- (void)setChangeSliderValue:(NSTimeInterval)value
{
    ///缓冲
    [self waiting];
    ///暂停
    [self.player pause];
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(value, 1);
    [playerItem seekToTime:dragedCMTime];
    ///开始播放
    [self play];
}
/// 设置最大滑动值
- (void)setMaxDuratuin:(NSTimeInterval)duration
{
    if (duration == NAN) {
        _totalTime = 0.0000f;
        [self.slider setMaximumValue:0.0000f];
    } else {
        _totalTime = duration;
        [self.slider setMaximumValue:duration];
        [self.lbTime setText:[Utils getHHMMSSFromSSTime:duration]];
    }
}

#pragma mark - PublicMethod

/**
 *  显示
 */
-(void)show
{
    [[ZDragButton shareDragButton] dismiss];
    
    [self showOnly];
}
-(void)showOnly
{
    if (_isShow) {
        return;
    }
    _isShow = YES;
    [self setHidden:NO];
    [self setAlpha:1.0f];
}
/**
 *  隐藏
 */
-(void)dismiss
{
    if (isPlaying) {
        [[ZDragButton shareDragButton] show];
    } else {
        [[ZDragButton shareDragButton] dismiss];
    }
    
    [self dismissOnly];
}
///隐藏
-(void)dismissOnly
{
    if (!_isShow) {
        return;
    }
    _isShow = NO;
    [self setAlpha:0.0f];
    [self setHidden:YES];
}
///设置友盟播放时长统计
-(void)setUMengPlayTime
{
    //获取视频播放长度
    CMTime currentCMTime = playerItem.currentTime;
    NSTimeInterval currentNSTime = CMTimeGetSeconds(currentCMTime);
    NSDictionary *dicAttrib = @{kEvent_Practice_List_Item_ID:_playingPracticeModel.ids,
                                kEvent_Practice_List_Item_Name:_playingPracticeModel.title};
    [MobClick event:kEvent_Practice_List_Item_PlayTime attributes:dicAttrib durations:currentNSTime*1000];
}
/**
 *  开始播放
 */
- (void)play
{
    GCDMainBlock(^{
        [self.player play];
        [self setPlayState];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [sqlite setLocalAudioWithModel:_playingModel];
        [sqlite setLocalPlayPracticeWithModel:_playingPracticeModel];
    });
}
///设置播放状态
- (void)setPlayState
{
    isPlaying = YES;
    isWaiting = NO;
    _isReadError = NO;
    [[AppDelegate app] setIsPaying:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:nil];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"p_shape_stop"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"p_shape_stop"] forState:(UIControlStateHighlighted)];
    
    if ([[AudioPlayerView shareAudioPlayerView] isHidden]) {
        [[ZDragButton shareDragButton] show];
    } else {
        [[ZDragButton shareDragButton] dismiss];
    }
}

/**
 *  是否播放中
 */
-(BOOL)isPlay
{
    return isPlaying;
}
/**
 *  暂停播放
 */
- (void)pause
{
    GCDMainBlock(^{
        isPlaying = NO;
        isWaiting = NO;
        _isReadError = NO;
        [self.player pause];
        [[AppDelegate app] setIsPaying:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:nil];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateHighlighted)];
    });
    
    [self setUMengPlayTime];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [sqlite setLocalAudioWithModel:_playingModel];
        [sqlite setLocalPlayPracticeWithModel:_playingPracticeModel];
    });
}
///缓冲中
- (void)waiting
{
    GCDMainBlock(^{
        isPlaying = NO;
        isWaiting = YES;
        _isReadError = NO;
        [[AppDelegate app] setIsPaying:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:nil];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_waiting"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_waiting"] forState:(UIControlStateHighlighted)];
    });
}
///设置状态改变
-(void)setStateChange
{
    [self playerStatus];
}
/**
 *  播放/暂停按钮点击事件执行的方法
 */
- (void)playerStatus
{
    if (_isReadError) {
        _isStopPlay = NO;
        [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"NO"];
        [self updateAudioPlayer];
    } else {
        if (!isWaiting) {
            if (isPlaying) {
                _isStopPlay = YES;
                [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"YES"];
                [self pause];
            } else {
                _isStopPlay = NO;
                [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"NO"];
                [self play];
            }
        }
    }
}
/// 播放,暂停
-(void)btnPlayClick
{
    [self playerStatus];
}
/**
 *  上一首
 */
- (void)btnPreClick
{
    if (self.btnPre.enabled) {
        
        self.btnNext.enabled = NO;
        self.btnPre.enabled = NO;
        
        [self initialControls];
        
        [self previousIndexSub];
        
        [self updateAudioPlayer];
        
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        [dicParam setObject:_playingPracticeModel forKey:@"model"];
        [dicParam setObject:[NSNumber numberWithInteger:_index] forKey:@"row"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayNextNotification object:dicParam];
    }
}

/**
 *  下一首
 */
- (void)btnNextClick
{
    if (self.btnNext.enabled) {
        
        self.btnNext.enabled = NO;
        self.btnPre.enabled = NO;
        
        [self initialControls];
        
        [self nextIndexAdd];
        
        [self updateAudioPlayer];
        
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        [dicParam setObject:_playingPracticeModel forKey:@"model"];
        [dicParam setObject:[NSNumber numberWithInteger:_index] forKey:@"row"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayPreNotification object:dicParam];
    }
}

#pragma mark - PrivateMethod

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

#pragma mark - PlayTimeObserver

/// 注册播放监听回调
- (void)monitoringPlayback:(AVPlayerItem *)item
{
    __weak typeof(self) ws = self;
    //监听播放进度，这里设置每秒执行30次
    _playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 计算当前在第几秒
        NSTimeInterval currentPlayTime = (NSTimeInterval)item.currentTime.value/item.currentTime.timescale;
        
        [ws updateVideoSlider:currentPlayTime];
    }];
}
/// 改变进度位置
- (void)updateVideoSlider:(NSTimeInterval)currentTime
{
    if ([[AppDelegate app] appEnterBackground]) {
        [self setLockViewWith:_playingModel currentTime:currentTime];
    }
    //拖动过程中不需要设置
    if (fabs(self.slider.value-currentTime) <= 1) {
        [self.slider setValue:currentTime];
    }
    if (!self.isShowProgress) {
        self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
    }
    
    [_playingModel setAudioPlayTime:currentTime];
    [_playingPracticeModel setPlay_time:currentTime];
}

#pragma mark - KVO Add Notification

// 监听代码
- (void)addObserverForCurrentPlayItem:(AVPlayerItem*)currentPlayerItem
{
    [currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&AudioPlayerItemStatusContext];
    [currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:&AudioPlayerItemStatusContext];
    [currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:&AudioPlayerItemStatusContext];
    [currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:&AudioPlayerItemStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlayBuffering:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:currentPlayerItem];
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
    [currentPlayerItem removeObserver:self forKeyPath:@"status" context:&AudioPlayerItemStatusContext];
    [currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:&AudioPlayerItemStatusContext];
    [currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:&AudioPlayerItemStatusContext];
    [currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:&AudioPlayerItemStatusContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}
/// 删除注册的通知
- (void)removeObserverAndNotification
{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self removeObserverForCurrentPlayItem:playerItem];
    [self.player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    playerAsset = nil;
    playerItem = nil;
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
            _isStopPlay = [[sqlite getSysParamWithKey:kSQLITE_LAST_STOPPLAYSTATE] boolValue];
            if (!_isStopPlay) {
                //耳机插入
                [self play];
            }
            break;
        }
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            //耳机取消
            [self pause];
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange:
        {
            break;
        }
        default:break;
    }
}
/// 播放回调函数
- (void)onPlayBuffering:(NSNotification *)sender
{
    
}
/// 收到播放完成的通知
-(void)onPlayFinished:(NSNotification *)sender
{
    GCDMainBlock(^{
        [self setUMengPlayTime];
        
        //TODO:ZWW备注->设置循环播放
        [self.slider setValue:0.0f];
        [self.lbProgress setText:@"00:00:00"];
        [playerItem seekToTime:kCMTimeZero];
        
        [self play];
    });
}
/// 播放出问题的通知
-(void)onPlayFailed:(NSNotification *)sender
{
    [self pause];
    _isReadError = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayErrorNotification object:nil];
}
#pragma mark - KVO Player Status
/// 注册播放状态通知
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &AudioPlayerItemStatusContext) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            GBLog(@"--------playStatus keyPath: %@  \n status: %ld  \n 0未知错误,1准备播放或正在播放,2播放出错", keyPath,item.status);
            switch (item.status) {
                case AVPlayerStatusReadyToPlay:
                {
                    _isReadError = NO;
                    CMTime duration = item.duration;//获取视频总长度
                    [self setMaxDuratuin:CMTimeGetSeconds(duration)];
                    
                    if (!_isStopPlay) {
                        [self play];
                    }
                    break;
                }
                case AVPlayerStatusFailed:
                {
                    [self initialControls];
                    _isReadError = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayErrorNotification object:nil];
                    break;
                }
                case AVPlayerItemStatusUnknown:
                {
                    [self initialControls];
                    _isReadError = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayErrorNotification object:nil];
                    break;
                }
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //kvo触发的另外一个属性
                NSArray *array = [playerItem loadedTimeRanges];
                //获取范围i
                CMTimeRange range = [array.firstObject CMTimeRangeValue];
                //从哪儿开始的
                CGFloat start = CMTimeGetSeconds(range.start);
                //缓存了多少
                CGFloat duration = CMTimeGetSeconds(range.duration);
                //一共缓存了多少
                CGFloat allCache = start+duration;
                
                //设置缓存的百分比
                CMTime allTime = [playerItem duration];
                //转换
                CGFloat time = CMTimeGetSeconds(allTime);
                CGFloat y = allCache/time;
                GBLog(@"--------loadedTimeRanges  缓冲百分比: %.2f",y);
                if (y >= 1) {
                    // 下载文件缓存到本地
                    [self resourceLoaderPlayFile:_lastFileUrl];
                }
            });
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            GBLog(@"--------playbackBufferEmpty");
            //缓冲开始
            _isReadError = NO;
            
            [self waiting];
            
        }  else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            GBLog(@"--------playbackLikelyToKeepUp");
            //缓冲结束
            _isReadError = NO;
            
            _isStopPlay = [[sqlite getSysParamWithKey:kSQLITE_LAST_STOPPLAYSTATE] boolValue];
            if (!_isStopPlay) {
                [self play];
            }
        }
    }
}
#pragma mark - UIEventTypeRemoteControl
/// 远程控制播放器
- (void)setPlayRemoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeRemoteControl) {
        GBLog(@"--------setPlayRemoteControlReceivedWithEvent subtype: %ld \n 101播放,102暂停,103播放暂停切换,104下一首,105上一首,106开始向前拖拽,107结束向前拖拽,108开始向后拖拽,109结束向后拖拽", event.subtype);
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            {
                //播放
                _isStopPlay = NO;
                [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"NO"];
                if (!isPlaying) {
                    [self play];
                }
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                //暂停
                _isStopPlay = YES;
                [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"YES"];
                if (isPlaying) {
                    [self pause];
                }
                break;
            }
            case UIEventSubtypeRemoteControlStop:
            {
                //停止
                _isStopPlay = YES;
                [sqlite setSysParam:kSQLITE_LAST_STOPPLAYSTATE value:@"YES"];
                if (isPlaying) {
                    [self pause];
                }
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                //下一首
                [self btnNextClick];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                //上一首
                [self btnPreClick];
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            {
                //开始向前拖拽
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingForward:
            {
                //结束向前拖拽
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            {
                //开始向后拖拽
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            {
                //结束向后拖拽
                break;
            }
            default: break;
        }
    }
}

#pragma mark - AppBackgroundPlayingInfo

/// 设置当前播放语音的效果
- (void)setLockViewWith:(ModelAudio*)model currentTime:(CGFloat)currentTime
{
    if(NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *musicInfo = [NSMutableDictionary dictionary];
        // 设置Singer
        [musicInfo setObject:model.audioAuthor forKey:MPMediaItemPropertyArtist];
        // 设置歌曲名
        [musicInfo setObject:model.audioTitle forKey:MPMediaItemPropertyTitle];
        // 设置封面
        UIImage *img = nil;
        NSString *imgPath = [[[AppSetting getPictureFilePath] stringByAppendingPathComponent:[Utils stringMD5:model.audioImage]] stringByAppendingPathExtension:[model.audioImage pathExtension]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
            img = [UIImage imageWithContentsOfFile:imgPath];
        }
        if (!img) {
            img = [SkinManager getImageWithName:@"Icon"];
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:img];
        [musicInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
        //音乐剩余时长
        [musicInfo setObject:[NSNumber numberWithDouble:_totalTime] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间
        [musicInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:musicInfo];
    }
}
    
@end
