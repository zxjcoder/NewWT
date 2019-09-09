//
//  ZPlayViewController.m
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ModelAudio.h"
#import "ZPlayFunctionView.h"

#import "ZCircleQuestionViewController.h"
#import "ZPracticeContentViewController.h"
#import "ZPracticeAnswerViewController.h"
#import "ZPictureViewerViewController.h"

#import "ZTaskCompleteView.h"
#import "ZPlayListView.h"

#import "ZCurriculumDetailViewController.h"

@interface ZPlayViewController ()
{
    /// 播放进度观察者
    id _playTimeObserver;
    /// 播放状态 YES播放 NO暂停,停止
    BOOL _isPlaying;
    /// 是否移除通知
    BOOL _isRemoveNot;
}
/// 是否同意播放
@property (assign, nonatomic) BOOL isAgreePlay;
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
///实务标题
@property (strong, nonatomic) ZLabel *lbTitlePractice;
///实务图片
@property (strong, nonatomic) ZImageView *imgIcon;
///实务图片
@property (strong, nonatomic) ZLabel *lbIcon;
///主讲人
@property (strong, nonatomic) ZLabel *lbSpeakerName;
///主讲人描述
@property (strong, nonatomic) ZLabel *lbSpeakerDesc;
///主讲人描述滑动区域
@property (strong, nonatomic) UIScrollView *scrollViewSpeakerDesc;
///播放按钮
@property (strong, nonatomic) ZPlayFunctionView *viewFunction;
///功能按钮
@property (strong, nonatomic) ZPlayTabBarView *viewTabbar;
///主讲人描述坐标
@property (assign, nonatomic) CGRect speakerDescFrame;

@end

static const NSString *kPlayStatusContext;

static ZPlayViewController *audioPlayerView;

@implementation ZPlayViewController

+(ZPlayViewController *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayerView = [[ZPlayViewController alloc] init];
        
        audioPlayerView.player = [[AVPlayer alloc] init];
        
        [audioPlayerView innerInit];
        
        [audioPlayerView setAudioSession];
    });
    return audioPlayerView;
}

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightShareButton];
    
    [self innerData];
    
    [self.navigationController.navigationBar setTintColor:WHITECOLOR];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeObserverAndNotification];
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_imgBackground);
    OBJC_RELEASE(_lbIcon);
    OBJC_RELEASE(_lbTitleNav);
    OBJC_RELEASE(_lbSpeakerDesc);
    OBJC_RELEASE(_lbSpeakerName);
    OBJC_RELEASE(_lbTitlePractice);
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
    [super setViewNil];
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
    __unsafe_unretained ZPlayViewController *eventLoop = (__bridge ZPlayViewController *)inClientData;
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
    __unsafe_unretained ZPlayViewController *eventLoop = (__bridge ZPlayViewController *)inClientData;
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
            if (_isPlaying) {
                //控制UI，继续播放
                [self play];
            }
        }
    }
}
#pragma clang diagnostic pop

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
    
    CGFloat viewSpace = APP_FRAME_WIDTH/320;
    CGFloat titleSpace = viewSpace*APP_TOP_HEIGHT;
    CGRect titleFrame = CGRectMake(kSizeSpace, titleSpace, self.view.width-kSizeSpace*2, 20);
    self.lbTitlePractice = [[ZLabel alloc] initWithFrame:titleFrame];
    [self.lbTitlePractice setTextColor:WHITECOLOR];
    [self.lbTitlePractice setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitlePractice setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitlePractice setNumberOfLines:2];
    [self.view addSubview:self.lbTitlePractice];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitlePractice];
    titleFrame.size.height = titleMaxH;
    [self.lbTitlePractice setFrame:titleFrame];
    
    CGFloat iconSize = 140;
    CGFloat iconX = self.view.width/2-iconSize/2;
    CGFloat iconSpace = viewSpace*15;
    CGFloat iconY = self.lbTitlePractice.y+self.lbTitlePractice.height+iconSpace;
    self.imgIcon = [[ZImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconSize, iconSize)];
    [self.imgIcon.layer setMasksToBounds:YES];
    [self.imgIcon setViewRound:10 borderWidth:2 borderColor:WHITECOLOR];
    [self.view addSubview:self.imgIcon];
    
    CGFloat tspeakerNameSpace = self.imgIcon.y+self.imgIcon.height+viewSpace*kSize15;
    CGRect speakerNameFrame = CGRectMake(kSizeSpace, tspeakerNameSpace, self.view.width-kSizeSpace*2, 20);
    self.lbSpeakerName = [[ZLabel alloc] initWithFrame:speakerNameFrame];
    [self.lbSpeakerName setTextColor:WHITECOLOR];
    [self.lbSpeakerName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbSpeakerName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSpeakerName setNumberOfLines:1];
    [self.view addSubview:self.lbSpeakerName];
    
    CGFloat functionY = APP_FRAME_HEIGHT-kZPlayTabBarViewHeight-kZPlayFunctionViewHeight;
    CGFloat tspeakerDescY = self.lbSpeakerName.y+self.lbSpeakerName.height+viewSpace*kSize8;
    CGFloat tspeakerDescHeight = functionY-tspeakerDescY-kSize8;
    self.speakerDescFrame = CGRectMake(0, tspeakerDescY, self.view.width, tspeakerDescHeight);
    
    self.scrollViewSpeakerDesc = [[UIScrollView alloc] initWithFrame:self.speakerDescFrame];
    [self.scrollViewSpeakerDesc setOpaque:NO];
    [self.scrollViewSpeakerDesc setBounces:NO];
    [self.scrollViewSpeakerDesc setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewSpeakerDesc setShowsVerticalScrollIndicator:NO];
    [self.scrollViewSpeakerDesc setScrollsToTop:NO];
    [self.view addSubview:self.scrollViewSpeakerDesc];
    
    self.lbSpeakerDesc = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, 0, self.speakerDescFrame.size.width-kSizeSpace*2, 20)];
    [self.lbSpeakerDesc setTextColor:RGBCOLOR(240, 240, 240)];
    [self.lbSpeakerDesc setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSpeakerDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSpeakerDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbSpeakerDesc setNumberOfLines:0];
    [self.scrollViewSpeakerDesc addSubview:self.lbSpeakerDesc];
    
    ZWEAKSELF
    self.viewFunction = [[ZPlayFunctionView alloc] initWithPoint:CGPointMake(0, functionY)];
    //改变播放进度
    [self.viewFunction setOnSliderValueChange:^(float value, float maxValue) {
        if (maxValue > 0 && value <= maxValue) {
            ///暂停
            if (weakSelf.player) {
                [weakSelf.player pause];
            }
            //转换成CMTime才能给player来控制播放进度
            CMTime dragedCMTime = CMTimeMake(value, 1);
            [weakSelf.playerItem seekToTime:dragedCMTime];
            ///开始播放
            [weakSelf play];
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
        [weakSelf pause];
    }];
    //播放
    [self.viewFunction setOnPlayClick:^{
        [weakSelf setCheckNetworkToPlay];
    }];
    //播放速度
    [self.viewFunction setOnRateChange:^(float rate) {
        [weakSelf playWithRate:rate];
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
        ZPracticeAnswerViewController *itemVC = [[ZPracticeAnswerViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///实务PPT
    [self.viewTabbar setOnPracticePPTClick:^(ModelPractice *model) {
        if (model.arrImage.count > 0) {
            NSMutableArray *imageUrls = [NSMutableArray new];
            for (NSDictionary *dicImage in model.arrImage) {
                NSURL *url = [NSURL URLWithString:[dicImage objectForKey:@"url"]];
                if (url) {
                    [imageUrls addObject:url];
                }
            }
            ZPictureViewerViewController *browser = [[ZPictureViewerViewController alloc] initWithPhotos:[IDMPhoto photosWithURLs:imageUrls]];
            browser.progressTintColor       = MAINCOLOR;
            [weakSelf presentViewController:browser animated:YES completion:nil];
        } else {
            [ZProgressHUD showError:kThePracticeDoesNotSupportThePPT];
        }
    }];
    ///实务文本
    [self.viewTabbar setOnPracticeNoteClick:^(ModelPractice *model) {
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
        [weakSelf btnPraiseClick];
    }];
    ///收藏
    [self.viewTabbar setOnCollectionClick:^(ModelPractice *model) {
        [weakSelf btnCollectionClick];
    }];
    ///课程文本
    [self.viewTabbar setOnCurriculumNoteClick:^(ModelCurriculum *model) {
        ZCurriculumDetailViewController *itemVC = [[ZCurriculumDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///课程PPT
    [self.viewTabbar setOnCurriculumPPTClick:^(ModelCurriculum *model) {
        if (model.course_imges && model.course_imges.count > 0) {
            ZPictureViewerViewController *browser = [[ZPictureViewerViewController alloc] initWithPhotos:[IDMPhoto photosWithURLs:model.course_imges]];
            browser.progressTintColor       = MAINCOLOR;
            [weakSelf presentViewController:browser animated:YES completion:nil];
        } else {
            [ZProgressHUD showError:kTheSubscribeDoesNotSupportThePPT];
        }
    }];
    [self.view addSubview:self.viewTabbar];
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
///左边按钮
-(void)btnLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
///点赞事件
-(void)btnPraiseClick
{
    //添加统计事件
    [StatisticsManager event:kEvent_Practice_Detail_Praise category:kCategory_Practice];
    
    if ([AppSetting getAutoLogin]) {
        if (self.isPraiseing) {
            return;
        }
        [self setIsPraiseing:YES];
        ZWEAKSELF
        if (!_playingPracticeModel.isPraise) {
            //点赞
            __weak ModelPractice *modelP = _playingPracticeModel;
            [DataOper postClickLikeWithAId:_playingPracticeModel.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
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
            [DataOper postClickUnLikeWithAId:_playingPracticeModel.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
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
    //添加统计事件
    [StatisticsManager event:kEvent_Practice_Detail_Collection category:kCategory_Practice];
    
    if ([AppSetting getAutoLogin]) {
        if (self.isCollectioning) {
            return;
        }
        [self setIsCollectioning:YES];
        ZWEAKSELF
        if (!self.playingPracticeModel.isCollection) {
            //收藏
            __weak ModelPractice *modelP = _playingPracticeModel;
            [DataOper getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.playingPracticeModel.ids flag:1 type:@"3" resultBlock:^(NSDictionary *result) {
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
            [DataOper getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.playingPracticeModel.ids type:@"3" resultBlock:^(NSDictionary *result) {
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
///是否在播放中
-(BOOL)isStartPlaying
{
    return _isPlaying;
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
///分享按钮
-(void)btnRightClick
{
    //添加统计事件
    [StatisticsManager event:kEvent_Practice_Detail_Share category:kCategory_Practice];
    
    //TODO:ZWW备注-分享-实务详情
    ZWEAKSELF
    ZShareView *shareView = nil;
    shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                //添加统计事件
                [StatisticsManager event:kEvent_Practice_Detail_Share_WeChat category:kCategory_Practice];
                
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                //添加统计事件
                [StatisticsManager event:kEvent_Practice_Detail_Share_WeChatCircle category:kCategory_Practice];
                
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                //添加统计事件
                [StatisticsManager event:kEvent_Practice_Detail_Share_QQ category:kCategory_Practice];
                
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                //添加统计事件
                [StatisticsManager event:kEvent_Practice_Detail_Share_QZone category:kCategory_Practice];
                
                [weakSelf btnQZoneClick];
                break;
            case ZShareTypeYouDao:
                //添加统计事件
                [StatisticsManager event:kEvent_Practice_Detail_Share_YingXiang category:kCategory_Practice];
                
                [weakSelf btnYouDaoClick];
                break;
            case ZShareTypeYinXiang:
                //添加统计事件
                [StatisticsManager event:kEvent_Practice_Detail_Share_YouDao category:kCategory_Practice];
                
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
    NSString *title = self.playingModel.audioAuthor;
    switch (type) {
        case WTPlatformTypeWeChatTimeline:
            title = self.playingModel.audioTitle;
            break;
        default: break;
    }
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.playingModel.audioTitle;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.playingModel.audioImage];
    NSString *webUrl = kShare_VoiceUrl(self.playingModel.ids);
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypeSubscribe:
            webUrl = kApp_CurriculumContentUrl(self.playingCurriculumModel.subscribeId, self.playingCurriculumModel.ids);
            break;
        default:
            break;
    }
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
/// 各控件设初始值
- (void)initialControls
{
    [self stop];
    
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
    ///设置总时长
    [self setMaxDuratuin:modelA.totalDuration.doubleValue];
    //播放的是同一个
    if ([modelA.objId isEqualToString:self.playingModel.ids] && !_isReadError) {
        if (!_isPlaying) {
            [self play];
        }
    } else {
        // 设置当前播放数据模型
        [self setPlayingModel:modelA];
        [self setPlayingPracticeModel:[self.practiceArray objectAtIndex:_index]];
        [self.playingPracticeModel setRowIndex:_index];
        
        NSString *fileUrl = [modelA.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _isPlaying = NO;
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
    ///设置总时长
    [self setMaxDuratuin:modelA.totalDuration.doubleValue];
    //播放的是同一个
    if ([modelA.objId isEqualToString:self.playingCurriculumModel.ids] && !_isReadError) {
        if (!_isPlaying) {
            [self play];
        }
    } else {
        // 设置当前播放数据模型
        [self setPlayingModel:modelA];
        [self setPlayingCurriculumModel:[self.curriculumArray objectAtIndex:_index]];
        [self.playingCurriculumModel setRowIndex:_index];
        
        NSString *fileUrl = [modelA.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _isPlaying = NO;
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
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.playerAsset];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    if (APP_SYSTEM_VERSION >= 9) {
        [self.playerItem setCanUseNetworkResourcesForLiveStreamingWhilePaused:YES];
    }
#endif
    // 设置播放速度类型
    self.playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmSpectral;
    // 设置播放对象或者切换播放对象
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    if (!_isRemoveNot) {
        // 监听播放状态
        [self monitoringPlayback:self.playerItem];
        // 添加结束播放通知
        [self addObserverForCurrentPlayItem:self.playerItem];
        _isRemoveNot = YES;
    }
    // 检测网络环境-关闭进入界面播放
    //[self setCheckNetworkToPlay];
}
///检测网络状态,决定是否播放
-(void)setCheckNetworkToPlay
{
    switch (self.networkStatus) {
        case ZNetworkReachabilityStatusUnknown:
            [self setIsReadError:YES];
            [ZProgressHUD showError:kCMsgContentUnusual];
            break;
        case ZNetworkReachabilityStatusNotReachable:
            [self setIsReadError:YES];
            [ZProgressHUD showError:kCMsgContentError];
            break;
        case ZNetworkReachabilityStatusReachableViaWWAN:
            if (self.isAgreePlay) {
                [self setStartNewPlay];
            } else {
                ZWEAKSELF
                [ZAlertView showWithTitle:nil message:kCMsgShowTrafficPlayPrompt completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    [weakSelf setIsAgreePlay:NO];
                    switch (selectIndex) {
                        case 0:
                            [weakSelf setIsAgreePlay:YES];
                            [weakSelf setStartNewPlay];
                            break;
                        default: break;
                    }
                } cancelTitle:kCContinuePlay doneTitle:kCCancelPlay];
            }
            break;
        case ZNetworkReachabilityStatusReachableViaWiFi:
            [self setStartNewPlay];
            break;
    }
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
    [self play];
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
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[Utils stringMD5:file],file.pathExtension];
        
        NSString *filePath = [[AppSetting getAudioFilePath] stringByAppendingPathComponent:fileName];
        return filePath;
    }
    return nil;
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
    
    [self.viewFunction setViewInitializeCurrentTime:currentTime];
}

#pragma mark - PrivateMethod

///设置播放数据对象+设置标题
-(void)setViewPlayData
{
    [self.lbTitleNav setText:[NSString stringWithFormat:@"%@%d/%d", kPlayNow, (int)_index+1, (int)_practiceArray.count]];
    
    [self.lbTitlePractice setText:_playingPracticeModel.title];
    
    ZWEAKSELF
    ///设置背景模糊
    [self.imgIcon setImageURLStr:_playingPracticeModel.speech_img completed:^(UIImage *image) {
        GCDMainBlock(^{
            [weakSelf.imgBackground setImage:image];
        });
    }];
    
    [self.lbSpeakerName setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, self.playingPracticeModel.nickname]];
    [self.lbSpeakerDesc setText:self.playingPracticeModel.person_synopsis];
    
    // 更新读取实务的详情数据
    [self.viewFunction setOperEnabled:NO];
    [self.viewTabbar setButtonAllEnabled:NO];
    if (![AppSetting getAutoLogin]) {
        [self.playingPracticeModel setIsPraise:NO];
        [self.playingPracticeModel setIsCollection:NO];
        [self.viewTabbar setViewDataWithModel:self.playingPracticeModel];
    }
    [self.viewTabbar setViewDataWithModel:self.playingPracticeModel];
    [DataOper130 getPracticeDetailWithPracticeId:_playingPracticeModel.ids userId:[AppSetting getUserDetauleId] resultBlock:^(ModelPractice *resultModel) {
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
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (weakSelf.modelArray.count > 1) {
                [weakSelf.viewFunction setOperEnabled:YES];
            }
            [weakSelf.viewTabbar setButtonAllEnabled:YES];
        });
    }];
    
    CGFloat speakerDescNewH = [self.lbSpeakerDesc getLabelHeightWithMinHeight:20];
    CGRect speakerDescFrame = self.lbSpeakerDesc.frame;
    speakerDescFrame.size.height = speakerDescNewH;
    [self.lbSpeakerDesc setFrame:speakerDescFrame];
    [self.scrollViewSpeakerDesc setContentSize:CGSizeMake(self.scrollViewSpeakerDesc.width, speakerDescNewH)];
}
///设置播放数据对象+设置标题
-(void)setViewPlayCurriculumData
{
    [self.lbTitleNav setText:[NSString stringWithFormat:@"%@%d/%d", kPlayNow, (int)_index+1, (int)self.curriculumArray.count]];
    
    [self.lbTitlePractice setText:self.playingCurriculumModel.ctitle];
    if (self.modelArray.count > 1) {
        [self.viewFunction setOperEnabled:YES];
    } else {
        [self.viewFunction setOperEnabled:NO];
    }
    [self.viewTabbar setButtonAllEnabled:YES];
    [self.viewTabbar setViewDataWithModelCurriculum:self.playingCurriculumModel];
    ZWEAKSELF
    ///设置模糊背景
    [self.imgIcon setImageURLStr:self.playingCurriculumModel.illustration completed:^(UIImage *image) {
        GCDMainBlock(^{
            [weakSelf.imgBackground setImage:image];
        });
    }];
    [self.lbSpeakerName setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, self.playingCurriculumModel.team_name]];
    [self.lbSpeakerDesc setText:self.playingCurriculumModel.team_intro];
    
    CGFloat speakerDescNewH = [self.lbSpeakerDesc getLabelHeightWithMinHeight:20];
    CGRect speakerDescFrame = self.lbSpeakerDesc.frame;
    speakerDescFrame.size.height = speakerDescNewH;
    [self.lbSpeakerDesc setFrame:speakerDescFrame];
    [self.scrollViewSpeakerDesc setContentSize:CGSizeMake(self.scrollViewSpeakerDesc.width, speakerDescNewH)];
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
    
    if (self.playingModel.objId && self.playingModel.audioTitle) {
        NSDictionary *dicAttrib = @{kEvent_Practice_List_Item_ID:[NSString stringWithFormat:@"%@", self.playingModel.objId],kEvent_Practice_List_Item_Name:self.playingModel.audioTitle,kEvent_Practice_List_Item_Type:[NSString stringWithFormat:@"%d", (int)self.tabbarType]};
        [StatisticsManager event:kEvent_Practice_List_Item category:kCategory_Practice dictionary:dicAttrib];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayChangeNotification object:self.playingModel];
}
///播放
-(void)playWithRate:(float)rate
{
    if (!self.isStopPlay) {
        _isPlaying = YES;
        _isReadError = NO;
        
        if (self.player) {
            [self.player pause];
            [self.player setRate:0];
            [self.player play];
            [self.player setRate:rate];
        }
    }
}
///播放
-(void)play
{
    _isPlaying = YES;
    _isReadError = NO;
    if (self.player) {
        [self.player play];
    }
    [self setIsStopPlay:NO];
    
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
///停止
-(void)stop
{
    [self pause];
}
///暂停
-(void)pause
{
    [self setIsStopPlay:YES];
    
    [self waiting];
    
    [self setSavePlayToLocal];
}
///缓冲
-(void)waiting
{
    _isPlaying = NO;
    _isReadError = NO;
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
            self.playingCurriculumModel.play_time = self.playingModel.audioPlayTime;
            [sqlite setLocalPlayListSubscribeCurriculumListWithModel:self.playingCurriculumModel userId:[AppSetting getUserDetauleId]];
            break;
    }
    if (self.playingModel.objId && self.playingModel.audioTitle) {
        NSDictionary *dicAttrib = @{kEvent_Practice_List_Item_ID:[NSString stringWithFormat:@"%@", self.playingModel.objId],
                                    kEvent_Practice_List_Item_Name:self.playingModel.audioTitle,
                                    kEvent_Practice_List_Item_Type:[NSString stringWithFormat:@"%d", (int)self.tabbarType],
                                    kEvent_Practice_List_Item_Time:[NSString stringWithFormat:@"%ld", self.playingModel.audioPlayTime],
                                    kEvent_Practice_List_Item_User:[AppSetting getUserDetauleId]};
        [StatisticsManager event:kEvent_Practice_List_Item_PlayTime category:kCategory_Practice dictionary:dicAttrib];
    }
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
        [self setLockViewWith:self.playingModel currentTime:currentTime];
    }
    if (self.viewFunction) {
        [self.viewFunction setViewCurrentTime:currentTime];
    }
    
    self.playingModel.audioPlayTime = currentTime;
}

#pragma mark - KVO Add Notification

// 监听代码
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
    [self pause];
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
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.viewFunction setViewProgress:y];
                        });
                        if (y >= 1) {
                            // 下载文件缓存到本地
                            switch (self.tabbarType) {
                                case ZPlayTabBarViewTypePractice:
                                    //[self resourceLoaderPlayFile:self.lastFileUrl];
                                    break;
                                case ZPlayTabBarViewTypeFound:
                                    //[self resourceLoaderPlayFile:self.lastFileUrl];
                                    break;
                                case ZPlayTabBarViewTypeSubscribe:
                                    break;
                            }
                        }
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
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            {
                //播放
                if (!_isPlaying) {
                    [self play];
                }
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                //暂停
                if (_isPlaying) {
                    [self pause];
                }
                break;
            }
            case UIEventSubtypeRemoteControlStop:
            {
                //停止
                if (_isPlaying) {
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
        [musicInfo setObject:[NSNumber numberWithInteger:self.durationTime] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间
        [musicInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:musicInfo];
    }
}


@end
