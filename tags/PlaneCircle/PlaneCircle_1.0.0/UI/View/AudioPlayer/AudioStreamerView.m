//
//  AudioStreamerView.m
//  PlaneCircle
//
//  Created by Daniel on 7/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AudioStreamerView.h"
#import "AppDelegate.h"
#import "ZSlider.h"

@interface AudioStreamerView()
{
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
///播放对象
@property (strong, nonatomic) AVAudioFile *audio;
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
///是否显示进度条
@property (assign, nonatomic) BOOL isShowProgress;

@end


static const NSString *AudioStreamerItemStatusContext;

static AudioStreamerView *audioStreamerView;

@implementation AudioStreamerView

+(AudioStreamerView *)shareAudioStreamerView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioStreamerView = [[AudioStreamerView alloc] init];
        
        [audioStreamerView setAudioSession];
    });
    return audioStreamerView;
}

//后台播放相关,且将蓝牙重新连接
-(void)setAudioSession
{
    
}

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

-(void)innerInitView
{
    [self setHidden:YES];
    [self setAlpha:0.0f];
    
    _playerMode = AudioPlayerModeOrderPlay;
    
    [self setBackgroundColor:CLEARCOLOR];
    
    [self innerInit];
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
    
    self.lbProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, proW, 20)];
    [self.lbProgress setTextColor:WHITECOLOR];
    [self.lbProgress setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbProgress setText:@"00:00:00"];
    [self.lbProgress setTextAlignment:(NSTextAlignmentCenter)];
    [self.imgProgress addSubview:self.lbProgress];
    
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
    self.lbTime = [[UILabel alloc] initWithFrame:CGRectMake(self.imgTime.x+timeS+3, self.viewContent.height/2-lbH/2, 70, lbH)];
    [self.lbTime setText:@"00:00:00"];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbTime];
    
    CGFloat btnS = self.viewContent.height-5;
    CGFloat btnY = 2.5;
    self.btnPre = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPre setImage:[SkinManager getImageWithName:@"p_shape_b"] forState:(UIControlStateNormal)];
    [self.btnPre setFrame:CGRectMake(self.viewContent.width/2-btnS-30, btnY, btnS, btnS)];
    [self.btnPre setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPre];
    
    self.btnPlay = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateNormal)];
    [self.btnPlay setFrame:CGRectMake(self.viewContent.width/2-btnS/2, btnY, btnS, btnS)];
    [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPlay];
    
    self.btnNext = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNext setImage:[SkinManager getImageWithName:@"p_shape_g"] forState:(UIControlStateNormal)];
    [self.btnNext setFrame:CGRectMake(self.viewContent.width/2+30, btnY, btnS, btnS)];
    [self.btnNext setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnNext];
    
    CGFloat btnW = 43;
    CGFloat btnH = 28;
    CGFloat btnCX = self.viewContent.width-btnW-8;
    CGFloat btnCY = self.viewContent.height/2-btnH/2;
    self.btnComment = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnComment setFrame:CGRectMake(btnCX, btnCY, btnW, btnH)];
    [self.btnComment setTitle:@"评论" forState:(UIControlStateNormal)];
    [self.btnComment setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnComment setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnComment titleLabel] setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.btnComment addTarget:self action:@selector(btnCommentClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnComment];
    
    [self sendSubviewToBack:self.viewContent];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeObserverAndNotification];
    
    OBJC_RELEASE(_playingModel);
    OBJC_RELEASE(_playingPracticeModel);
    
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbProgress);
    OBJC_RELEASE(_btnPre);
    OBJC_RELEASE(_btnNext);
    OBJC_RELEASE(_btnPlay);
    OBJC_RELEASE(_btnComment);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_slider);
    OBJC_RELEASE(_imgTime);
    OBJC_RELEASE(_imgProgress);
    
    OBJC_RELEASE(_lastFileUrl);
}
/// 评论按钮
-(void)btnCommentClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayCommentNotification object:nil];
}
/// 禁止上一个下一个
-(void)setOperButtonEnabled:(BOOL)isEnabled
{
    [self.btnPre setEnabled:isEnabled];
    [self.btnNext setEnabled:isEnabled];
    if (isEnabled) {
        //可以用
        [self.btnPre setImage:[SkinManager getImageWithName:@"p_shape_b"] forState:(UIControlStateNormal)];
        [self.btnNext setImage:[SkinManager getImageWithName:@"p_shape_g"] forState:(UIControlStateNormal)];
    } else {
        //不能用
        [self.btnPre setImage:[SkinManager getImageWithName:@"p_shape_b_dis"] forState:(UIControlStateNormal)];
        [self.btnNext setImage:[SkinManager getImageWithName:@"p_shape_g_dis"] forState:(UIControlStateNormal)];
    }
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
    [self.btnPre setHidden:array.count <= 1];
    [self.btnNext setHidden:array.count <= 1];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelPractice *modelP in array) {
        [arr addObject:[[ModelAudio alloc] initWithModel:modelP]];
    }
    _practiceArray = array;
    _modelArray = [NSArray arrayWithArray:arr];
    
    [self updateAudioPlayer];
}
/// 改变播放文件对象
- (void)updateAudioPlayer
{
    ModelAudio *modelA = [_modelArray objectAtIndex:_index];
    //播放的是同一个
    if ([modelA.ids isEqualToString:_playingModel.ids] && !_isReadError) {
        if (!isPlaying) {
            [self play];
        }
    } else {
        _playingModel = modelA;
        _playingPracticeModel = [_practiceArray objectAtIndex:_index];
        [_playingPracticeModel setRowIndex:_index];
        // TODO:ZWW备注-测试播放器
//        NSString *fileUrl = @"http://m2.music.126.net/feplW2VPVs9Y8lE_I08BQQ==/1386484166585821.mp3";
        NSString *fileUrl = [modelA.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([NSThread isMainThread]) {
            [self setPlayWithFileUrl:fileUrl];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setPlayWithFileUrl:fileUrl];
            });
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
    _lastFileUrl = file;
    ///TODO:ZWW备注-创建播放流对象
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

#pragma mark - Slider
/// 各控件设初始值
- (void)initialControls
{
    [self pause];
    
    [self.lbTime setText:@"00:00:00"];
    [self.lbProgress setText:@"00:00:00"];
    [self.slider setValue:0.0f animated:YES];
}
/// 改变进度位置
- (void)updateVideoSlider:(NSTimeInterval)currentTime
{
    [self setLockViewWith:_playingModel currentTime:currentTime];
    
    //拖动过程中不需要设置
    if (fabs(self.slider.value-currentTime) <= 1) {
        self.slider.value = currentTime;
    }
    if (!self.isShowProgress) {
        self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
    }
    
    [_playingModel setAudioPlayTime:currentTime];
    [_playingPracticeModel setPlay_time:currentTime];
    
    [sqlite setLocalAudioWithModel:_playingModel];
    [sqlite setLocalPlayPracticeWithModel:_playingPracticeModel];
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
    //TODO:ZWW备注-设置拖动到指定位置
    //转换成CMTime才能给player来控制播放进度
//    CMTime dragedCMTime = CMTimeMake(value, 1);
//    [playerItem seekToTime:dragedCMTime];
}
/// 设置最大滑动值
- (void)setMaxDuratuin:(NSTimeInterval)duration
{
    _totalTime = duration;
    
    self.slider.maximumValue = duration;
    self.lbTime.text = [Utils getHHMMSSFromSSTime:duration];
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
        NSString *imgName = [NSString stringWithFormat:@"%@.jpeg",[Utils stringMD5:model.audioImage]];
        NSString *imgPath = [[AppSetting getSDWebImageCacheFilePath] stringByAppendingPathComponent:imgName];
        if (imgPath && [[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
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

#pragma mark - PublicMethod

/**
 *  显示
 */
-(void)show
{
    GCDMainBlock(^{
        [self setHidden:NO];
        [self setAlpha:0.0f];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self setAlpha:1.0f];
        }];
    });
}

/**
 *  隐藏
 */
-(void)dismiss
{
    GCDMainBlock(^{
        [self setHidden:NO];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    });
}

/**
 *  开始播放
 */
- (void)play
{
    GCDMainBlock(^{
        isPlaying = YES;
        isWaiting = NO;
        _isReadError = NO;
//        [self.player play];
        [[AppDelegate app] setIsPaying:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:nil];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_shape_stop"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_shape_stop"] forState:(UIControlStateHighlighted)];
    });
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
//        [self.player pause];
        [[AppDelegate app] setIsPaying:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:nil];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateHighlighted)];
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
    });
}
/**
 *  播放/暂停按钮点击事件执行的方法
 */
- (void)playerStatus
{
    if (_isReadError) {
        [self updateAudioPlayer];
    } else {
        if (!isWaiting) {
            if (isPlaying) {
                [self pause];
            }else{
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
        [self initialControls];
        if (_playerMode != AudioPlayerModeSinglePlay) {
            [self previousIndexSub];
        }
        [self updateAudioPlayer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayNextNotification object:nil];
    }
}

/**
 *  下一首
 */
- (void)btnNextClick
{
    if (self.btnNext.enabled) {
        [self initialControls];
        if (_playerMode != AudioPlayerModeSinglePlay) {
            [self nextIndexAdd];
        }
        [self updateAudioPlayer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayPreNotification object:nil];
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

#pragma mark - KVO NSNotificationCenter

// 监听代码
- (void)addObserverForCurrentPlayItem
{
    ///监听耳机切换事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChanged:)
                                                 name:AVAudioSessionRouteChangeNotification object:nil];
}
/// 删除注册的通知
- (void)removeObserverAndNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}
/// 耳机状态改变
-(void)audioRouteChanged:(NSNotification *)sender
{
    NSDictionary *interuptionDict = sender.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    GBLog(@"--------AVAudioSessionRouteChangeReason state: %d \n 1耳机已经插入,2耳机已经拔出,3状态改变", (int)routeChangeReason);
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            //耳机插入
            [self play];
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
/// 远程控制播放器
- (void)setPlayRemoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeRemoteControl) {
        GBLog(@"--------setPlayRemoteControlReceivedWithEvent subtype: %ld \n 101播放,102暂停,103播放暂停切换,104下一首,105上一首,106开始向前拖拽,107结束向前拖拽,108开始向后拖拽,109结束向后拖拽", (long)event.subtype);
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            {
                //播放
                if (!isPlaying) {
                    [self play];
                }
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                //暂停
                if (isPlaying) {
                    [self pause];
                }
                break;
            }
            case UIEventSubtypeRemoteControlStop:
            {
                //停止
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

@end
