//
//  ZPlayerViewController.m
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayerViewController.h"
#import "PlayerTimeManager.h"
#import "DownloadManager.h"
#import "ZPlayFunctionView.h"
#import "ZPlayListView.h"
#import "ZPlayObjectInfoView.h"
#import "ZPlayBottomView.h"
#import "ZPlayButtonView.h"
#import "ZPlayRewardView.h"
#import "ZPlayToolView.h"
#import "ZWebContentViewController.h"
#import "ZPracticeAnswerViewController.h"
#import "ZCurriculumMessageViewController.h"
#import "ZAccountBalanceViewController.h"

@interface ZPlayerViewController ()<DownloadManagerDelegate, PlayerManagerDelegate>
{
    ///是否收藏中
    __block BOOL isCollectioning;
    ///是否点赞中
    __block BOOL isPraiseing;
    ///内容区域
    ZPlayObjectInfoView *viewObjectInfo;
    ///播放按钮区域
    ZPlayFunctionView *viewFunction;
    ///功能按钮区域
    ZPlayBottomView *viewTabbar;
    ///功能按钮区域
    __block ZPlayButtonView *viewButton;
}
///当前板块类型
@property (assign, nonatomic) ZPlayTabBarViewType tabbarType;
@property (assign, nonatomic) BOOL isShowNowPlaying;

@end

@implementation ZPlayerViewController

static ZPlayerViewController *audioPlayerViewController;
+(ZPlayerViewController *)sharedSingleton
{
    static dispatch_once_t onceTokenPlayer;
    dispatch_once(&onceTokenPlayer, ^{
        audioPlayerViewController = [[ZPlayerViewController alloc] init];
        [audioPlayerViewController innerInit];
    });
    return audioPlayerViewController;
}

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO:ZWW备注设置页面不允许全屏返回
    //[self setFd_interactivePopDisabled:YES];
    [self setIsDismissPlay:YES];
    //设置播放器
    [[PlayerManager sharedPlayer] setTrackPlayDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化数据
    [self innerData];
    //设置下载
    [[DownloadManager sharedManager] setDownloadDelegate:self];
    //检查下载状态
    [self setCheckDownload];
    //设置是否可以分享
    if (self.tabbarType != ZPlayTabBarViewTypeSubscribe) {
        [self setRightShareButtonOnlyWithPlay];
    }
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPagePlayKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[DownloadManager sharedManager] setDownloadDelegate:nil];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPagePlayKey dictionary:nil];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [[PlayerTimeManager shared] save];
    [[PlayerManager sharedPlayer] setTrackPlayDelegate:nil];
    OBJC_RELEASE(viewButton);
    OBJC_RELEASE(viewObjectInfo);
    OBJC_RELEASE(viewTabbar);
    OBJC_RELEASE(viewFunction);
    OBJC_RELEASE(_modelTrack);
    OBJC_RELEASE(_modelPractice);
    OBJC_RELEASE(_modelCurriculum);
    OBJC_RELEASE(_onTrackPlayFailed);
    OBJC_RELEASE(_onTrackWillPlaying);
    OBJC_RELEASE(_onTrackPlayNotifyProcess);
    OBJC_RELEASE(_onTrackPlayNotifyCacheProcess);
    OBJC_RELEASE(_arrayTrack);
    OBJC_RELEASE(_arrayRawdata);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    CGFloat functionY = APP_FRAME_HEIGHT-kZPlayBottomViewHeight-kZPlayFunctionViewHeight;
    CGFloat infoY = APP_TOP_HEIGHT;
    CGFloat infoH = functionY-infoY-kZPlayButtonViewHeight;
    viewObjectInfo = [[ZPlayObjectInfoView alloc] initWithFrame:CGRectMake(0, infoY, APP_FRAME_WIDTH, infoH)];
    [viewObjectInfo setOnPPTClick:^{
        switch (weakSelf.tabbarType) {
            case ZPlayTabBarViewTypeSubscribe:
            {
                if (weakSelf.modelCurriculum && weakSelf.modelCurriculum.course_imges && weakSelf.modelCurriculum.course_imges.count > 0) {
                    [weakSelf showPhotoBrowserWithArray:weakSelf.modelCurriculum.course_imges index:0];
                } else {
                    [ZProgressHUD showError:kTheSubscribeDoesNotSupportThePPT];
                }
                break;
            }
            default:
            {
                [StatisticsManager event:kPractice_Detail_PPT];
                if (weakSelf.modelPractice.arrImage && weakSelf.modelPractice.arrImage.count > 0) {
                    NSMutableArray *imageUrls = [NSMutableArray new];
                    for (NSString *url in weakSelf.modelPractice.arrImage) {
                        if (url) {
                            [imageUrls addObject:[NSURL URLWithString:url]];
                        }
                    }
                    [weakSelf showPhotoBrowserWithArray:imageUrls index:0];
                } else {
                    [ZProgressHUD showError:kThePracticeDoesNotSupportThePPT];
                }
                break;
            }
        }
    }];
    //课件点击
    [viewObjectInfo setOnTextClick:^{
        switch (weakSelf.tabbarType) {
            case ZPlayTabBarViewTypeSubscribe:
            {
                [StatisticsManager event:kCourseware];
                ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
                [itemVC setViewDataWithModel:weakSelf.modelCurriculum isCourse:YES];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default:
            {
                [StatisticsManager event:kPractice_Detail_Courseware];
                ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
                [itemVC setViewDataWithModel:weakSelf.modelPractice isCourse:YES];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
        }
    }];
    [self.view addSubview:viewObjectInfo];
    
    viewFunction = [[ZPlayFunctionView alloc] initWithPoint:CGPointMake(0, functionY)];
    //改变播放进度
    [viewFunction setOnSliderValueChange:^(CGFloat value) {
        [weakSelf setPlaySliderValue:value];
    }];
    //上一首
    [viewFunction setOnPreClick:^{
        [weakSelf playPrevTrack];
    }];
    //下一首
    [viewFunction setOnNextClick:^{
        [weakSelf playNextTrack];
    }];
    //停止
    [viewFunction setOnStopClick:^{
        [weakSelf setPausePlay];
    }];
    //播放
    [viewFunction setOnPlayClick:^{
        [weakSelf setStartPlay];
    }];
    //播放速度
    [viewFunction setOnRateChange:^(float rate) {
        [weakSelf playWithRate:rate];
    }];
    //播放列表
    [viewFunction setOnListClick:^{
        [weakSelf showPlayListView];
    }];
    [self.view addSubview:viewFunction];
    
    [super innerInit];
}
///初始化数据
-(void)innerData
{
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice: [self setViewPlayPracticeData]; break;
        case ZPlayTabBarViewTypeSubscribe: [self setViewPlayCurriculumData]; break;
    }
}
///是否在播放中
-(BOOL)isPlaying
{
    return [[PlayerManager sharedPlayer] isPlayering];
}
///设置数据源
-(void)setRawdataWithArray:(NSArray *)array index:(NSInteger)index
{
    [self reloadRawDataWithArray:array index:index];
    [self setReadyPlay];
}
/// 加载原始数据
-(void)reloadRawDataWithArray:(NSArray *)array index:(NSInteger)index
{
    [[AppDelegate app] setIsPlay:YES];
    [self setArrayRawdata:nil];
    [self setArrayRawdata:array];
    [self setPlayIndex:index];
    [self setDefaultViewStatus];
    id object = [array objectAtIndex:index];
    if ([object isKindOfClass:[ModelPractice class]]) {
        [self setModelPractice:object];
        //TODO:ZWW备注-统计
        if (self.modelPractice.unlock == 0) {
            [StatisticsManager event:kPractice_Detail];
        } else {
            [StatisticsManager event:kPractice_Detail];
        }
        ModelTrack *modelTrack = [[ModelTrack alloc] initWithModelPractice:object];
        [self setModelTrack:modelTrack];
    } else if ([object isKindOfClass:[ModelCurriculum class]]) {
        [self setModelCurriculum:object];
        //TODO:ZWW备注-统计
        if (self.modelCurriculum.is_series_course == 0) {
            if (self.modelCurriculum.free_read == 0) {
                [StatisticsManager event:kTraining_Detail];
            } else {
                [StatisticsManager event:kTraining_Detail];
            }
        } else {
            if (self.modelCurriculum.free_read == 0) {
                [StatisticsManager event:kEriesCourse_Detail];
            } else {
                [StatisticsManager event:kEriesCourse_Detail];
            }
        }
        if (self.modelCurriculum.is_series_course == 1) {
            ModelTrack *modelTrack = [[ModelTrack alloc] initWithModelSeriesCourses:self.modelCurriculum];
            [self setModelTrack:modelTrack];
        } else {
            ModelTrack *modelTrack = [[ModelTrack alloc] initWithModelCurriculum:self.modelCurriculum];
            [self setModelTrack:modelTrack];
        }
    }
    //TODO:ZWW-备注采用服务器时间
    [self setMaxDuratuin:self.modelTrack.duration];
    NSMutableArray *arrayTrack = [NSMutableArray arrayWithCapacity:array.count];
    for (id obj in array) {
        if ([obj isKindOfClass:[ModelPractice class]]) {
            if (self.modelTrack.trackId == [[[(ModelPractice*)obj ids] stringByAppendingString:kMultipleZeros] integerValue]) {
                [arrayTrack addObject:self.modelTrack];
            } else {
                ModelTrack *modelTrack = [[ModelTrack alloc] initWithModelPractice:obj];
                [arrayTrack addObject:modelTrack];
            }
        } else if ([obj isKindOfClass:[ModelCurriculum class]]) {
            if (self.modelTrack.trackId == [[(ModelCurriculum*)obj ids] integerValue]) {
                [arrayTrack addObject:self.modelTrack];
            } else {
                ModelCurriculum *modelC = (ModelCurriculum*)obj;
                if (modelC.is_series_course == 1) {
                    ModelTrack *modelTrack = [[ModelTrack alloc] initWithModelSeriesCourses:obj];
                    [arrayTrack addObject:modelTrack];
                } else {
                    ModelTrack *modelTrack = [[ModelTrack alloc] initWithModelCurriculum:obj];
                    [arrayTrack addObject:modelTrack];
                }
            }
        }
    }
    [self setArrayTrack:nil];
    [self setArrayTrack:arrayTrack];
    [self setCheckDownload];
}
///设置默认数据对象
-(void)setDefaultModel
{
    [StatisticsManager event:kPractice_Detail_Playlists];
    
    [viewObjectInfo setContentDefaultOffX];
    id object = [self.arrayRawdata objectAtIndex:self.playIndex];
    [self setModelTrack:[self.arrayTrack objectAtIndex:self.playIndex]];
    [self setDefaultViewStatus];
    if ([object isKindOfClass:[ModelPractice class]]) {
        [self setModelPractice:object];
        [self setViewPlayPracticeData];
    } else if ([object isKindOfClass:[ModelCurriculum class]]) {
        [self setModelCurriculum:object];
        [self setViewPlayCurriculumData];
    }
    //TODO:ZWW-备注采用服务器时间
    [self setMaxDuratuin:self.modelTrack.duration];
    [self setIsShowNowPlaying:NO];
}
///添加诸葛IO统计
-(void)addStatistics
{
    NSString *dataType = kPractice;
    NSString *teamname = kEmpty;
    NSString *teaminfo = kEmpty;
    NSString *payprice = kEmpty;
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice:
            dataType = kPractice;
            teamname = self.modelPractice.nickname;
            teaminfo = self.modelPractice.person_title;
            payprice = self.modelPractice.price;
            [StatisticsManager event:kPractice_Detail];
            break;
        default:
            if (self.modelCurriculum.is_series_course == 0) {
                dataType = kSubscribe;
                [StatisticsManager event:kTraining_Detail];
            } else {
                dataType = kSeriesCourse;
                [StatisticsManager event:kEriesCourse_Detail];
            }
            teamname = self.modelCurriculum.team_name;
            teaminfo = self.modelCurriculum.team_intro;
            payprice = self.modelCurriculum.price;
            break;
    }
    // TODO: ZWW - 开始播放统计
    [StatisticsManager eventIOTrackWithKey:kZhugeIOOnlineLecturesKey title:self.modelTrack.trackTitle type:dataType name:teamname team:teaminfo paytype:nil price:payprice];
}
///设置默认状态
-(void)setDefaultViewStatus
{
    [viewFunction setPausePlay];
    [viewFunction setViewCurrentTime:0 percent:0];
    [viewFunction setViewProgress:0];
    [self setMaxDuratuin:0];
}
///初始化工具栏
-(void)setInnerPlayTabbarWithType:(ZPlayTabBarViewType)type
{
    if (self.tabbarType == type) {
        return;
    }
    [self setTabbarType:type];
    ZWEAKSELF
    if (viewTabbar) {
        [viewTabbar removeFromSuperview];
        OBJC_RELEASE(viewTabbar);
    }
    if (viewButton) {
        [viewButton removeFromSuperview];
        OBJC_RELEASE(viewButton);
    }
    viewButton = [[ZPlayButtonView alloc] initWithPoint:CGPointMake(0, viewFunction.y-kZPlayButtonViewHeight) type:type];
    //下载按钮
    [viewButton setOnDownloadClick:^(ZDownloadStatus downloadType) {
        
        switch (type) {
            case ZPlayTabBarViewTypePractice:
                [StatisticsManager event:kPractice_Detail_Download dictionary:@{kObjectId: weakSelf.modelPractice.ids == nil ? kEmpty : weakSelf.modelPractice.ids, kObjectTitle: weakSelf.modelPractice.title ? kEmpty : weakSelf.modelPractice.title, kObjectUser: kUserDefaultId, kObjectType: @"Practice"}];
                break;
            default:
            {
                if (self.modelCurriculum.is_series_course == 0) {
                    [StatisticsManager event:kTraining_Detail_Download dictionary:@{kObjectId: weakSelf.modelCurriculum.ids == nil ? kEmpty : weakSelf.modelCurriculum.ids, kObjectTitle: weakSelf.modelCurriculum.title ? kEmpty : weakSelf.modelCurriculum.title, kObjectUser: kUserDefaultId, kObjectType: @"Training"}];
                } else {
                    [StatisticsManager event:kEriesCourse_Detail_Download dictionary:@{kObjectId: weakSelf.modelCurriculum.ids == nil ? kEmpty : weakSelf.modelCurriculum.ids, kObjectTitle: weakSelf.modelCurriculum.title ? kEmpty : weakSelf.modelCurriculum.title, kObjectUser: kUserDefaultId, kObjectType: @"EriesCourse"}];
                }
                break;
            }
        }
        
        [weakSelf setDownloadClick];
    }];
    ///实务点赞
    [viewButton setOnPracticePraiseClick:^(ModelPractice *model) {
        
        [StatisticsManager event:kPractice_Detail_Praise dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId, kObjectType: @"Practice"}];
        
        [weakSelf btnPracticePraiseClick];
    }];
    ///订阅点赞
    [viewButton setOnCurriculumPraiseClick:^(ModelCurriculum *model) {
        if (self.modelCurriculum.is_series_course == 0) {
            [StatisticsManager event:kTraining_Detail_Praise dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId, kObjectType: @"Training"}];
        } else {
            [StatisticsManager event:kEriesCourse_Detail_Praise dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId, kObjectType: @"EriesCourse"}];
        }
        [weakSelf btnCurriculumPraiseClick];
    }];
    ///实务收藏
    [viewButton setOnPracticeCollectionClick:^(ModelPractice *model) {
        
        [StatisticsManager event:kPractice_Detail_Collection dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId, kObjectType: @"Practice"}];
        
        [weakSelf btnPracticeCollectionClick];
    }];
    ///订阅收藏
    [viewButton setOnCurriculumCollectionClick:^(ModelCurriculum *model) {
        if (self.modelCurriculum.is_series_course == 0) {
            [StatisticsManager event:kTraining_Detail_Collection dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId, kObjectType: @"Training"}];
        } else {
            [StatisticsManager event:kEriesCourse_Detail_Collection dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId, kObjectType: @"EriesCourse"}];
        }
        [weakSelf btnCurriculumCollectionClick];
    }];
    [self.view addSubview:viewButton];
    
    viewTabbar = [[ZPlayBottomView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT-kZPlayBottomViewHeight) type:type];
    ///讲师答疑
    [viewTabbar setOnAnswerClick:^(ModelPractice *model) {
        
        [StatisticsManager event:kPractice_Detail_AnsweringQuestion dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title ? kEmpty : model.title, kObjectUser: kUserDefaultId}];
        
        ZPracticeAnswerViewController *itemVC = [[ZPracticeAnswerViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///留言列表
    [viewTabbar setOnMessageListClick:^(ModelCurriculum *model) {
        
        ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
        [itemVC setViewWithMessageLoad];
        [itemVC setViewDataWithModel:model isCourse:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///写留言
    [viewTabbar setOnMessageWriteClick:^(ModelCurriculum *model) {
        
        if (model.is_series_course == 0) {
            [StatisticsManager event:kTraining_Detail_Message dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title == nil ? kEmpty : model.title, kObjectUser: kUserDefaultId}];
        } else {
            [StatisticsManager event:kEriesCourse_Detail_Message dictionary:@{kObjectId: model.ids == nil ? kEmpty : model.ids, kObjectTitle: model.title == nil ? kEmpty : model.title, kObjectUser: kUserDefaultId}];
        }
        ZCurriculumMessageViewController *itemVC = [[ZCurriculumMessageViewController alloc] init];
        [itemVC setPreVC:weakSelf];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///实务打赏
    [viewTabbar setOnPracticeRewardClick:^(ModelPractice *model) {
        
        [weakSelf btnPracticeRewardClick:model];
    }];
    ///订阅打赏
    [viewTabbar setOnCurriculumRewardClick:^(ModelCurriculum *model) {
        
        [weakSelf btnCurriculumRewardClick:model];
    }];
    [self.view addSubview:viewTabbar];
}
///显示列表视图
-(void)showPlayListView
{
    ZWEAKSELF
    ZPlayListView *playListView = [[ZPlayListView alloc] initWithPlayListArray:self.arrayTrack index:self.playIndex];
    [playListView setOnPlayItemClick:^(ModelTrack *model, NSInteger rowIndex) {
        if (![model.ids isEqualToString:weakSelf.modelTrack.ids]) {
            [weakSelf setPlayIndex:rowIndex];
            [weakSelf setDefaultModel];
            [weakSelf setStartPlay];
        }
    }];
    [playListView show];
}
///订阅打赏
-(void)btnCurriculumRewardClick:(ModelCurriculum *)model
{
    ZPlayRewardView *rewardView = [[ZPlayRewardView alloc] initWithPlayTitle:model.speaker_name organization:model.team_name];
    ZWEAKSELF
    [rewardView setOnRewardPriceClick:^(NSString *price) {
        [weakSelf setRewardSendBuy:price type:(ZPlayTabBarViewTypeSubscribe)];
    }];
    [rewardView show];
}
///实务打赏
-(void)btnPracticeRewardClick:(ModelPractice *)model
{
    ZPlayRewardView *rewardView = [[ZPlayRewardView alloc] initWithPlayTitle:model.nickname organization:model.person_title];
    ZWEAKSELF
    [rewardView setOnRewardPriceClick:^(NSString *price) {
        [weakSelf setRewardSendBuy:price type:(ZPlayTabBarViewTypePractice)];
    }];
    [rewardView show];
}
///发起打赏
-(void)setRewardSendBuy:(NSString *)price type:(ZPlayTabBarViewType)type
{
    switch (type) {
        case ZPlayTabBarViewTypePractice:
            [StatisticsManager event:kPractice_Detail_Deward dictionary:@{kObjectId: self.modelPractice.ids == nil ? kEmpty : self.modelPractice.ids, kObjectTitle: self.modelPractice.title == nil ? kEmpty : self.modelPractice.title, kObjectUser: kUserDefaultId, kObjectPrice: price}];
            break;
        default:
        {
            if (self.modelCurriculum.is_series_course == 0) {
                [StatisticsManager event:kTraining_Detail_Deward dictionary:@{kObjectId: self.modelCurriculum.ids == nil ? kEmpty : self.modelCurriculum.ids, kObjectTitle: self.modelCurriculum.title == nil ? kEmpty : self.modelCurriculum.title, kObjectUser: kUserDefaultId, kObjectPrice: price}];
            } else {
                [StatisticsManager event:kEriesCourse_Detail_Deward dictionary:@{kObjectId: self.modelCurriculum.ids == nil ? kEmpty : self.modelCurriculum.ids, kObjectTitle: self.modelCurriculum.title == nil ? kEmpty : self.modelCurriculum.title, kObjectUser: kUserDefaultId, kObjectPrice: price}];
            }
            break;
        }
    }
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZWEAKSELF
        ZPlayToolView *viewPlayTool = nil;
        NSInteger playtype = WTPayTypeRewardPractice;
        NSString *objid = self.modelPractice.ids;
        NSString *title = self.modelPractice.title;
        switch (type) {
            case ZPlayTabBarViewTypeSubscribe:
            {
                playtype = WTPayTypeRewardSubscribe;
                objid = self.modelCurriculum.ids;
                title = self.modelCurriculum.ctitle;
                viewPlayTool = [[ZPlayToolView alloc] initWithPracticeRewardTitle:[NSString stringWithFormat:kCMsgPaymentelement, price] speakerName:[NSString stringWithFormat:kCMsgAppreciationOfTheRight, self.modelCurriculum.speaker_name]];
                break;
            }
            default:
            {
                playtype = WTPayTypeRewardPractice;
                viewPlayTool = [[ZPlayToolView alloc] initWithSubscribeRewardTitle:[NSString stringWithFormat:kCMsgPaymentelement, price] speakerName:[NSString stringWithFormat:kCMsgAppreciationOfTheRight, self.modelPractice.nickname]];
                break;
            }
        }
        [viewPlayTool setOnBalanceClick:^{
            if ([AppSetting getUserLogin].balance < [price floatValue]) {
                [ZAlertView showWithTitle:kPrompt message:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    switch (selectIndex) {
                        case 1: [weakSelf setShowAccountBalanceVC]; break;
                        default:break;
                    }
                } cancelTitle:kCancel doneTitle:kToRecharge];
                return;
            }
            [ZProgressHUD showMessage:kCMsgPaying];
            ///下订单
            [snsV2 getGenerateOrderWithMoney:price type:playtype objid:objid title:title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                    [ZProgressHUD dismiss];
                    [ZAlertView showWithMessage:kCMsgRewardSuccess];
                } errorBlock:^(NSString *msg) {
                    [ZProgressHUD dismiss];
                    
                    [ZAlertView showWithMessage:msg];
                }];
            } errorBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [ZAlertView showWithMessage:msg];
            } balanceBlock:^(NSString *msg) {
                [ZProgressHUD dismiss];
                [ZAlertView showWithTitle:kPrompt message:kYourBalanceIsInsufficientPleaseRechargeAfterTheSubscription completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                    switch (selectIndex) {
                        case 1: [weakSelf setShowAccountBalanceVC]; break;
                        default:break;
                    }
                } cancelTitle:kCancel doneTitle:kToRecharge];
            }];
        }];
        [viewPlayTool show];
    } else {
        [self showLoginVC];
    }
}
///显示充值页面
-(void)setShowAccountBalanceVC
{
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///课程内容点赞
-(void)btnCurriculumPraiseClick
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        if (isPraiseing) {
            return;
        }
        isPraiseing = YES;
        ZWEAKSELF
        __weak typeof(ModelCurriculum) *modelC = self.modelCurriculum;
        if (!self.modelCurriculum.isPraise) {
            //点赞
            [snsV1 postClickLikeWithAId:self.modelCurriculum.ids userId:kLoginUserId type:@"5" resultBlock:^(NSDictionary *result) {
                isPraiseing = NO;
                if ([modelC.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
                    
                    [weakSelf.modelCurriculum setIsPraise:YES];
                    weakSelf.modelCurriculum.applauds += 1;
                    
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                        [viewTabbar setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                    });
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isPraiseing = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            [snsV1 postClickUnLikeWithAId:self.modelCurriculum.ids userId:kLoginUserId type:@"5" resultBlock:^(NSDictionary *result) {
                isPraiseing = NO;
                if ([modelC.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
                    [weakSelf.modelCurriculum setIsPraise:NO];
                    if (weakSelf.modelCurriculum.applauds > 0) {
                        weakSelf.modelCurriculum.applauds -= 1;
                    }
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                        [viewTabbar setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                    });
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isPraiseing = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///实务点赞事件
-(void)btnPracticePraiseClick
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        if (isPraiseing) {
            return;
        }
        isPraiseing = YES;
        ZWEAKSELF
        __weak typeof(ModelPractice) *modelP = self.modelPractice;
        if (!self.modelPractice.isPraise) {
            //点赞
            [snsV1 postClickLikeWithAId:self.modelPractice.ids userId:kLoginUserId type:@"4" resultBlock:^(NSDictionary *result) {
                isPraiseing = NO;
                if ([modelP.ids isEqualToString:weakSelf.modelPractice.ids]) {
                    
                    [weakSelf.modelPractice setIsPraise:YES];
                    weakSelf.modelPractice.applauds += 1;
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModel:weakSelf.modelPractice];
                        [viewTabbar setViewDataWithModel:weakSelf.modelPractice];
                    });
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isPraiseing = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            [snsV1 postClickUnLikeWithAId:self.modelPractice.ids userId:kLoginUserId type:@"4" resultBlock:^(NSDictionary *result) {
                isPraiseing = NO;
                if ([modelP.ids isEqualToString:weakSelf.modelPractice.ids]) {
                    [weakSelf.modelPractice setIsPraise:NO];
                    if (weakSelf.modelPractice.applauds > 0) {
                        weakSelf.modelPractice.applauds -= 1;
                    }
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModel:weakSelf.modelPractice];
                        [viewTabbar setViewDataWithModel:weakSelf.modelPractice];
                    });
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isPraiseing = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///实务收藏事件
-(void)btnPracticeCollectionClick
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        if (isCollectioning) {
            return;
        }
        isCollectioning = YES;
        ZWEAKSELF
        __weak typeof(ModelPractice) *modelP = self.modelPractice;
        if (!self.modelPractice.isCollection) {
            //收藏
            [snsV1 getAddCollectionWithUserId:kLoginUserId cid:self.modelPractice.ids flag:1 type:@"3" resultBlock:^(NSDictionary *result) {
                isCollectioning = NO;
                if ([modelP.ids isEqualToString:weakSelf.modelPractice.ids]) {
                    [weakSelf.modelPractice setIsCollection:YES];
                    weakSelf.modelPractice.ccount += 1;
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModel:weakSelf.modelPractice];
                        [viewTabbar setViewDataWithModel:weakSelf.modelPractice];
                    });
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isCollectioning = NO;
                GCDMainBlock(^{
                });
                [ZProgressHUD showError:msg];
            }];
        } else {
            //取消收藏
            [snsV1 getDelCollectionWithUserId:kLoginUserId cid:self.modelPractice.ids type:@"3" resultBlock:^(NSDictionary *result) {
                isCollectioning = NO;
                if ([modelP.ids isEqualToString:weakSelf.modelPractice.ids]) {
                    [weakSelf.modelPractice setIsCollection:NO];
                    if (weakSelf.modelPractice.ccount > 0) {
                        weakSelf.modelPractice.ccount -= 1;
                    }
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModel:weakSelf.modelPractice];
                        [viewTabbar setViewDataWithModel:weakSelf.modelPractice];
                    });
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isCollectioning = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///订阅收藏事件
-(void)btnCurriculumCollectionClick
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        if (isCollectioning) {
            return;
        }
        isCollectioning = YES;
        ZWEAKSELF
        __weak typeof(ModelCurriculum) *modelC = self.modelCurriculum;
        if (!self.modelCurriculum.isCollection) {
            //收藏
            [snsV1 getAddCollectionWithUserId:kLoginUserId cid:self.modelCurriculum.ids flag:5 type:@"7" resultBlock:^(NSDictionary *result) {
                isCollectioning = NO;
                if ([modelC.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
                    [weakSelf.modelCurriculum setIsCollection:YES];
                    weakSelf.modelCurriculum.ccount += 1;
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                        [viewTabbar setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                    });
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isCollectioning = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消收藏
            [snsV1 getDelCollectionWithUserId:kLoginUserId cid:self.modelCurriculum.ids type:@"7" resultBlock:^(NSDictionary *result) {
                isCollectioning = NO;
                if ([modelC.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
                    [weakSelf.modelCurriculum setIsCollection:NO];
                    if (weakSelf.modelCurriculum.ccount > 0) {
                        weakSelf.modelCurriculum.ccount -= 1;
                    }
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                        [viewTabbar setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                    });
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:kLoginUserId];
                }
            } errorBlock:^(NSString *msg) {
                isCollectioning = NO;
                GCDMainBlock(^{
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
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice:
            [StatisticsManager event:kPractice_Detail_Share];
            break;
        default:
            if (self.modelCurriculum.is_series_course == 0) {
                [StatisticsManager event:kTraining_Detail_Share];
            } else {
                [StatisticsManager event:kEriesCourse_Detail_Share];
            }
            break;
    }
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
                {
                    if (self.modelCurriculum.is_series_course == 0) {
                        [StatisticsManager event: kTraining_Detail_Share_Wechat];
                    } else {
                        [StatisticsManager event: kEriesCourse_Detail_Share_Wechat];
                    }
                    break;
                }
                default:
                    [StatisticsManager event:kPractice_Detail_Share_Wechat];
                    break;
            }
            break;
        case WTPlatformTypeWeChatTimeline:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                {
                    if (self.modelCurriculum.is_series_course == 0) {
                        [StatisticsManager event: kTraining_Detail_Share_WechatCircle];
                    } else {
                        [StatisticsManager event: kEriesCourse_Detail_Share_WechatCircle];
                    }
                    break;
                }
                default:
                    [StatisticsManager event:kPractice_Detail_Share_WeChatCircle];
                    break;
            }
            break;
        case WTPlatformTypeQQFriend:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                    break;
                default:
                    break;
            }
            break;
        case WTPlatformTypeQzone:
            switch (self.tabbarType) {
                case ZPlayTabBarViewTypeSubscribe:
                    break;
                default:
                    break;
            }
        default: break;
    }
    NSString *title = self.modelTrack.trackTitle;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    
    NSString *imageUrl = [Utils getMinPicture:self.modelTrack.coverUrlSmall];
    NSString *webUrl = kShare_VoiceUrl(self.modelTrack.ids);
    
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypeSubscribe:
            webUrl = kApp_CurriculumContentUrl(self.modelCurriculum.subscribeId, self.modelCurriculum.ids);
            break;
        default:
            break;
    }
    NSString *content = self.modelTrack.trackIntro;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}

#pragma mark - PrivateMethod

///设置播放数据对象+设置标题
-(void)setViewPlayPracticeData
{
    [self setTitle:[NSString stringWithFormat:@"%@%d/%d", kPlayNow, (int)self.playIndex+1, (int)self.arrayRawdata.count]];
    if (![AppSetting getAutoLogin]) {
        [self.modelPractice setIsPraise:NO];
        [self.modelPractice setIsCollection:NO];
    }
    [viewFunction setOperEnabled:NO];
    [viewButton setViewDataWithModel:self.modelPractice];
    [viewTabbar setViewDataWithModel:self.modelPractice];
    [viewObjectInfo setViewDataWithPracitce:self.modelPractice];
    [sqlite setLocalPlayPracticeDetailWithModel:self.modelPractice userId:kLoginUserId];
    ZWEAKSELF
    [snsV2 getPracticeDetailWithPracticeId:self.modelPractice.ids userId:kLoginUserId resultBlock:^(ModelPractice *resultModel) {
        if ([resultModel.ids isEqualToString:weakSelf.modelPractice.ids]) {
            [weakSelf setModelPractice:resultModel];
            [viewObjectInfo setViewDataWithPracitce:resultModel];
            [viewButton setViewDataWithModel:resultModel];
            [viewTabbar setViewDataWithModel:resultModel];
            if (weakSelf.arrayRawdata.count > 1) {
                [viewFunction setOperEnabled:YES];
            }
            resultModel.rowIndex = weakSelf.playIndex;
            resultModel.play_time = weakSelf.modelPractice.play_time;
            [sqlite setLocalPlayPracticeDetailWithModel:resultModel userId:kLoginUserId];
        }
    } errorBlock:^(NSString *msg) {
        if (weakSelf.arrayRawdata.count > 1) {
            [viewFunction setOperEnabled:YES];
        }
    }];
}
///设置播放数据对象+设置标题
-(void)setViewPlayCurriculumData
{
    [self setTitle:[NSString stringWithFormat:@"%@%d/%d", kPlayNow, (int)self.playIndex+1, (int)self.arrayRawdata.count]];
    if (![AppSetting getAutoLogin]) {
        [self.modelCurriculum setIsPraise:NO];
        [self.modelCurriculum setIsCollection:NO];
    }
    [viewFunction setOperEnabled:NO];
    [viewTabbar setViewDataWithModelCurriculum:self.modelCurriculum];
    [viewButton setViewDataWithModelCurriculum:self.modelCurriculum];
    [viewObjectInfo setViewDataWithSubscribe:self.modelCurriculum];
    [sqlite setLocalPlayCurriculumDetailWithModel:self.modelCurriculum userId:kLoginUserId];
    ZWEAKSELF
    [snsV2 getCurriculumDetailWithCurriculumId:self.modelCurriculum.ids resultBlock:^(ModelCurriculum *resultModel, NSDictionary *result) {
        if ([resultModel.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
            [weakSelf setModelCurriculum:resultModel];
            [viewObjectInfo setViewDataWithSubscribe:resultModel];
            [viewButton setViewDataWithModelCurriculum:resultModel];
            [viewTabbar setViewDataWithModelCurriculum:resultModel];
            if (weakSelf.arrayRawdata.count > 1) {
                [viewFunction setOperEnabled:YES];
            }
            resultModel.rowIndex = weakSelf.playIndex;
            resultModel.play_time = weakSelf.modelCurriculum.play_time;
            [sqlite setLocalPlayCurriculumDetailWithModel:resultModel userId:kLoginUserId];
        }
    } errorBlock:^(NSString *msg) {
        if (weakSelf.arrayRawdata.count > 1) {
            [viewFunction setOperEnabled:YES];
        }
    }];
}
///提问发布成功
-(void)setPublishPracticeQuestion:(ModelPracticeQuestion *)modelPQ
{
    
}
///留言成功回调
-(void)sendMessageSuccess:(NSDictionary *)dicResult
{
    
}
///改变播放位置
-(void)setPlaySliderValue:(CGFloat)value
{
    NSInteger second = [PlayerManager sharedPlayer].currentTrack.duration*value;
    [[PlayerManager sharedPlayer] seekToTime:second];
}
/// 设置最大滑动值
- (void)setMaxDuratuin:(NSUInteger)duration
{
    [viewFunction setMaxDuratuin:duration];
    
    NSUInteger playTime = [[PlayerTimeManager shared] getPlayTimeWithId:self.modelTrack.trackId];
    CGFloat percent = [[PlayerTimeManager shared] getPercentWithId:self.modelTrack.trackId];
    [viewFunction setViewCurrentTime:playTime percent:percent];
    
    if (self.onTrackWillPlaying) {
        self.onTrackWillPlaying(duration);
    }
}
///准备播放
-(void)setReadyPlay
{
    [viewObjectInfo setContentDefaultOffX];
    BOOL isPlayer = [PlayerManager sharedPlayer].isPlayering;
    if ([PlayerManager sharedPlayer].currentTrack.trackId != self.modelTrack.trackId) {
        [[PlayerManager sharedPlayer] stopTrackPlay];
        [viewFunction setStopPlay];
    } else {
        [self setStartPlay];
    }
    if (!isPlayer) {
        [[PlayerManager sharedPlayer] stopTrackPlay];
        [viewFunction setStopPlay];
    }
}
///开始播放
-(void)setStartPlay
{
    [StatisticsManager event:kPractice_Detail_Play];
    
    [[PlayerManager sharedPlayer] playWithTrack:self.modelTrack playlist:self.arrayTrack];
}
///停止播放
-(void)setStopPlay
{
    [[PlayerTimeManager shared] save];
    [[PlayerManager sharedPlayer] stopTrackPlay];
}
///暂停播放
-(void)setPausePlay
{
    [StatisticsManager event:kPractice_Detail_Suspend];
    
    [[PlayerTimeManager shared] save];
    [[PlayerManager sharedPlayer] pauseTrackPlay];
}
///恢复播放
-(void)setResumePlay
{
    [[PlayerManager sharedPlayer] resumeTrackPlay];
}
///下一首索引改变
- (void)nextIndexChange
{
    self.playIndex++;
    if (self.playIndex == self.arrayRawdata.count) {
        self.playIndex = 0;
    }
    [sqlite setSysParam:kSQLITEPlayViewLastPlayIndex value:[NSString stringWithFormat:@"%d", (int)self.playIndex]];
}
///上一首索引改变
- (void)preIndexChange
{
    self.playIndex--;
    if (self.playIndex < 0) {
        self.playIndex = self.arrayRawdata.count-1;
    }
    [sqlite setSysParam:kSQLITEPlayViewLastPlayIndex value:[NSString stringWithFormat:@"%d", (int)self.playIndex]];
}
///上一首内容改变
-(void)playPreContentChange
{
    [[PlayerTimeManager shared] save];
    [self setModelStatisics];
    [self preIndexChange];
    [self setDefaultModel];
    [self setCheckDownload];
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [self setNowPlayingInfo];
    }
}
///上一首播放变
-(void)playPrevTrack
{
    [StatisticsManager event:kPractice_Detail_Previous];
    [self playPreContentChange];
    [[PlayerManager sharedPlayer] playPrevTrack];
}
///下一首内容改变
-(void)playNextContentChange
{
    [[PlayerTimeManager shared] save];
    [self setModelStatisics];
    [self nextIndexChange];
    [self setDefaultModel];
    [self setCheckDownload];
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [self setNowPlayingInfo];
    }
}
///下一首播放变
-(void)playNextTrack
{
    [StatisticsManager event:kPractice_Detail_Next];
    [self playNextContentChange];
    [[PlayerManager sharedPlayer] playNextTrack];
}
///设置数据模型打点
-(void)setModelStatisics
{
    NSString *eventId = kPractice_Detail_List_PlayTime;
    switch (self.modelTrack.dataType) {
        case ZDownloadTypeSubscribe: eventId = kTraining_Detail_List_PlayTime; break;
        case ZDownloadTypeSeriesCourse: eventId = kEriesCourse_Detail_List_PlayTime; break;
        default: break;
    }
    if (self.modelTrack.ids && self.modelTrack.trackTitle) {
        [StatisticsManager event:eventId value:[PlayerManager sharedPlayer].currentTrack.listenedTime dictionary:@{kObjectId:self.modelTrack.ids,kObjectTitle:self.modelTrack.trackTitle,kObjectUser:kLoginUserId}];
    } else {
        [StatisticsManager event:eventId value:[PlayerManager sharedPlayer].currentTrack.listenedTime];
    }
}
///播放倍率
-(void)playWithRate:(float)rate
{
    switch (self.tabbarType) {
        case ZPlayTabBarViewTypePractice:
        {
            [StatisticsManager event: kPractice_Detail_Play dictionary:@{kObjectId: self.modelPractice.ids == nil ? kEmpty : self.modelPractice.ids, kObjectTitle: self.modelPractice.title == nil ? kEmpty : self.modelPractice.title, kObjectUser: kUserDefaultId}];
            break;
        }
        default:
        {
            if (self.modelCurriculum.is_series_course == 0) {
                [StatisticsManager event: kTraining_Detail_Play dictionary:@{kObjectId: self.modelCurriculum.ids == nil ? kEmpty : self.modelCurriculum.ids, kObjectTitle: self.modelCurriculum.title == nil ? kEmpty : self.modelCurriculum.title, kObjectUser: kUserDefaultId}];
            } else {
                [StatisticsManager event: kEriesCourse_Detail_Play dictionary:@{kObjectId: self.modelCurriculum.ids == nil ? kEmpty : self.modelCurriculum.ids, kObjectTitle: self.modelCurriculum.title == nil ? kEmpty : self.modelCurriculum.title, kObjectUser: kUserDefaultId}];
            }
            break;
        }
    }
    // 如果在播放中设置播放器变速
    if ([PlayerManager sharedPlayer].isPlayering) {
        [[PlayerManager sharedPlayer] setPlayRate:rate];
    }
}
///删除下载对象
-(void)setDeleteDownloadWithModel:(XMCacheTrack *)model
{
    if (self.modelTrack.trackId == model.trackId) {
        [self reloadRawDataWithArray:self.arrayRawdata index:self.playIndex];
        if (self.isPlaying) {
            [self setStartPlay];
        }
    }
}
///检测下载状态
-(void)setCheckDownload
{
    XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:self.modelTrack.trackId];
    switch (status.state) {
        case XMCacheTrackStatusDownloaded:
        {
            NSInteger userId = [kLoginUserId integerValue];
            NSArray *arrayLocalDownload = [sqlite getLocalDownloadListWithTrackId:self.modelTrack.trackId dataType:self.modelTrack.dataType];
            BOOL isDownload = NO;
            for (XMCacheTrack *modelCT in arrayLocalDownload) {
                if (modelCT.announcer.id == userId && self.modelTrack.trackId == modelCT.trackId) {
                    isDownload = YES;
                    break;
                }
            }
            if (isDownload) {
                [viewButton setDownloadButtonImageNoSuspend:(ZDownloadStatusEnd)];
            } else {
                [viewButton setDownloadButtonImageNoSuspend:ZDownloadStatusJoin];
            }
            break;
        }
        default: [viewButton setDownloadButtonImageNoSuspend:ZDownloadStatusJoin]; break;
    }
    GBLog(@"trackDownloadStatus: %d------0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载", (int)status);
}
///开始下载
-(void)setDownloadClick
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZDownloadStatus status = (NSInteger)[[DownloadManager sharedManager] downloadSingleTrack:self.modelTrack immediately:YES];
        switch (status) {
            case ZDownloadStatusDowloading: [ZProgressHUD showSuccess:kDownloading]; break;
            case ZDownloadStatusUrlError: [ZProgressHUD showSuccess:kDownloadError]; break;
            case ZDownloadStatusSqlError: [ZProgressHUD showSuccess:kDownloadError]; break;
            case ZDownloadStatusAudioDowloading: [ZProgressHUD showSuccess:kDownloading]; break;
            case ZDownloadStatusAudioDowloadEnd: [viewButton setDownloadButtonImageNoSuspend:(ZDownloadStatusEnd)]; break;
            case ZDownloadStatusJoin:
                [ZProgressHUD showSuccess:kJoinDownload];
                [viewButton setDownloadButtonImageNoSuspend:ZDownloadStatusJoin];
                break;
            default:
                [ZProgressHUD showSuccess:kJoinDownload];
                [viewButton setDownloadButtonImageNoSuspend:ZDownloadStatusJoin];
                break;
        }
        [sqlite setLocalDownloadListWithModelTrack:self.modelTrack];
        GBLog(@"trackDownloadStatus: %d------0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载", (int)status);
    } else {
        [self showLoginVC];
    }
}
///暂停下载
-(void)setSuspendDownload
{
    [[DownloadManager sharedManager] pauseDownloadSingleTrack:self.modelTrack];
}
#pragma mark - DownloadManagerDelegate
///下载失败时被调用
- (void)trackDownloadDidFailed:(XMTrack *)track
{
    [ZProgressHUD showSuccess:kDownloadFail];
}
////下载完成时被调用
- (void)trackDownloadDidFinished:(XMTrack *)track
{
    if (self.modelTrack.trackId == track.trackId) {
        [viewButton setDownloadButtonImageNoSuspend:(ZDownloadStatusEnd)];
    }
}
///下载开始时被调用
- (void)trackDownloadDidBegan:(XMTrack *)track
{
    if (track.trackId == self.modelTrack.trackId) {
        [ZProgressHUD showSuccess:kJoinDownload];
    }
}
///下载进度更新时被调用
- (void)track:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    
}

#pragma mark - PlayerManagerDelegate

- (void)trackPlayNotifyProcess:(CGFloat)percent currentSecond:(NSUInteger)currentSecond
{
    self.modelTrack.listenedTime = currentSecond;
    if (self.isPlaying) {
        [[PlayerTimeManager shared] setPlayTimeWithId:self.modelTrack.trackId playTime:currentSecond percent:percent];
        if (self.onTrackPlayNotifyProcess) {
            self.onTrackPlayNotifyProcess(percent, currentSecond);
        }
        [viewFunction setViewCurrentTime:currentSecond percent:percent];
    }
}
- (void)trackPlayNotifyCacheProcess:(CGFloat)percent
{
    if (self.onTrackPlayNotifyCacheProcess) {
        self.onTrackPlayNotifyCacheProcess(percent);
    }
    [viewFunction setViewProgress:percent];
}
- (void)trackPlayerWillPlaying
{
    // 设置变速播放
    CGFloat rate = viewFunction.getRate;
    [[PlayerManager sharedPlayer] setPlayRate:rate];
    
    // 添加统计
    [self addStatistics];
    
    //TODO:ZWW-备注采用本地播放器总时间
    /*NSInteger duration = [PlayerManager sharedPlayer].currentTrack.duration;
    [self setMaxDuratuin:duration];*/
    [snsV2 addPlayStaticalWithObjectId:self.modelTrack.ids type:self.modelTrack.dataType resultBlock:nil errorBlock:nil];
}
-(void)trackPlayerDidEnd
{
    [[PlayerTimeManager shared] setPlayTimeWithId:self.modelTrack.trackId];
    [self playNextContentChange];
    if (self.onPlayNextChange) {
        switch (self.tabbarType) {
            case ZPlayTabBarViewTypeSubscribe:
                self.onPlayNextChange(self.modelCurriculum);
                break;
            default:
                self.onPlayNextChange(self.modelPractice);
                break;
        }
    }
}
-(void)trackPlayerDidPlaylistEnd
{
    [[PlayerTimeManager shared] setPlayTimeWithId:self.modelTrack.trackId];
    [self setIsShowNowPlaying:NO];
    [[PlayerManager sharedPlayer] stopTrackPlay];
    [viewFunction setPausePlay];
}
- (void)trackPlayerDidPlaying
{
    [self setIsShowNowPlaying:NO];
    [viewFunction setStartPlay];
}
- (void)trackPlayerDidPaused
{
    [[PlayerTimeManager shared] save];
    [self setIsShowNowPlaying:NO];
    [self setModelStatisics];
    [viewFunction setPausePlay];
}
- (void)trackPlayerDidStopped
{
    [[PlayerTimeManager shared] save];
    [self setIsShowNowPlaying:NO];
    [viewFunction setPausePlay];
}
- (void)trackPlayerDidFailedToPlayTrack:(XMTrack *)track withError:(NSError *)error
{
    [[PlayerTimeManager shared] save];
    [self setIsShowNowPlaying:NO];
    if (self.onTrackPlayFailed) {
        self.onTrackPlayFailed(error);
    }
    [viewFunction setPausePlay];
    [ZProgressHUD showError:kFailedToReadAudioFile];
}
- (void)trackPlayerDidErrorWithType:(NSString *)type withData:(NSDictionary*)data
{
    [viewFunction setStartPlay];
    [[PlayerManager sharedPlayer] resumeTrackPlay];
}

#pragma mark - AppBackgroundPlayingInfo

/// 设置当前播放语音的效果
- (void)setNowPlayingInfo
{
    if (self.modelTrack == nil || self.modelTrack.trackTitle == nil) {
        return;
    }
    [self setIsShowNowPlaying:YES];
    if(NSClassFromString(@"MPNowPlayingInfoCenter")) {
        // 设置Singer
        NSString *strArtist = self.modelTrack.announcer.nickname == nil ? APP_PROJECT_NAME : self.modelTrack.announcer.nickname;
        // 设置封面
        UIImage *image = nil;
        if (self.modelTrack.coverUrlSmall != nil) {
            NSString *imgPath = [[AppSetting getPictureFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.modelTrack.coverUrlSmall]];
            NSString *strPathExtension = [self.modelTrack.coverUrlSmall pathExtension];
            if (strPathExtension) {
                imgPath = [imgPath stringByAppendingPathExtension:strPathExtension];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
                image = [UIImage imageWithContentsOfFile:imgPath];
            }
            if (image == nil) {
                NSURL *imageUrl = [NSURL URLWithString:[Utils getMiddlePicture:self.modelTrack.coverUrlSmall]];
                if (imageUrl && [[UIApplication sharedApplication] canOpenURL:imageUrl]) {
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                }
            }
        }
        if (image == nil) {
            image = [SkinManager getImageWithName:@"Icon"];
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        NSNumber *duration = [NSNumber numberWithInteger:self.modelTrack.duration];
        NSNumber *currentPlayTime = [NSNumber numberWithInteger:self.modelTrack.listenedTime];
        [PlayerManager setNowPlayingInfoCenterWithTitle:self.modelTrack.trackTitle artist:strArtist artwork:artwork duration:duration currentTime:currentPlayTime];    
    }
}

@end
