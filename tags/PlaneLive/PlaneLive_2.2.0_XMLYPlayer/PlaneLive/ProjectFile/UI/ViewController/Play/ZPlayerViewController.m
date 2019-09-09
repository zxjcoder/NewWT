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
#import "XMSDKPlayer.h"
#import "XMSDKDownloadManager.h"
#import "ZPlayFunctionView.h"
#import "ZPlayListView.h"
#import "ZPlayObjectInfoView.h"
#import "ZPlayBottomView.h"
#import "ZPlayButtonView.h"
#import "ZPlayRewardView.h"
#import "ZPlayToolView.h"
#import "ZCircleQuestionViewController.h"
#import "ZWebContentViewController.h"
#import "ZPracticeAnswerViewController.h"
#import "ZCurriculumMessageViewController.h"
#import "ZAccountBalanceViewController.h"
#import "XMTrackDownloadStatus.h"

@interface ZPlayerViewController ()<SDKDownloadMgrDelegate>
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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
    [[XMSDKPlayer sharedPlayer] setAutoNexTrack:YES];
    [[XMSDKPlayer sharedPlayer] settingEnableBackgroundResumePlay];
    //设置播放器
    [[XMSDKPlayer sharedPlayer] setTrackPlayDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化数据
    [self innerData];
    //设置下载
    [[XMSDKDownloadManager sharedSDKDownloadManager] setSdkDownloadMgrDelegate:self];
    //检查下载状态
    [self setCheckDownload];
    //设置是否可以分享
    if (self.tabbarType != ZPlayTabBarViewTypeSubscribe) {
        [self setRightShareButtonOnlyWithPlay];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[XMSDKDownloadManager sharedSDKDownloadManager] setSdkDownloadMgrDelegate:nil];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [[XMSDKPlayer sharedPlayer] setTrackPlayDelegate:nil];
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
                [StatisticsManager event:kSubscription_Detail_PPT];
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
                [StatisticsManager event:kSubscription_Detail_Text];
                ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
                [itemVC setViewDataWithModel:weakSelf.modelCurriculum isCourse:YES];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default:
            {
                [StatisticsManager event:kPractice_Detail_Text];
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
        [weakSelf btnPreClick];
    }];
    //下一首
    [viewFunction setOnNextClick:^{
        [weakSelf btnNextClick];
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
    return [[XMSDKPlayer sharedPlayer] playerState] == XMSDKPlayerStatePlaying;
}
///设置数据源
-(void)setRawdataWithArray:(NSArray *)array index:(NSInteger)index
{
    [self reloadRawDataWithArray:array index:index];
    [self setReadyPlay];
}
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
            [StatisticsManager event:kPractice_FreeDetail];
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
                [StatisticsManager event:kSubscription_FreeDetail];
            } else {
                [StatisticsManager event:kSubscription_Detail];
            }
        } else {
            if (self.modelCurriculum.free_read == 0) {
                [StatisticsManager event:kEriesCourse_FreeDetail];
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
}
///设置默认状态
-(void)setDefaultViewStatus
{
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
    [viewButton setOnDownloadClick:^(ZDownloadStatus type) {
        [weakSelf setDownloadClick];
    }];
    ///实务点赞
    [viewButton setOnPracticePraiseClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Praise];
        [weakSelf btnPracticePraiseClick];
    }];
    ///订阅点赞
    [viewButton setOnCurriculumPraiseClick:^(ModelCurriculum *model) {
        [weakSelf btnCurriculumPraiseClick];
    }];
    ///实务收藏
    [viewButton setOnPracticeCollectionClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Collection];
        [weakSelf btnPracticeCollectionClick];
    }];
    ///订阅收藏
    [viewButton setOnCurriculumCollectionClick:^(ModelCurriculum *model) {
        [weakSelf btnCurriculumCollectionClick];
    }];
    [self.view addSubview:viewButton];
    
    viewTabbar = [[ZPlayBottomView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT-kZPlayBottomViewHeight) type:type];
    ///讲师答疑
    [viewTabbar setOnAnswerClick:^(ModelPractice *model) {
        [StatisticsManager event:kPractice_Detail_Answer];
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
    if ([AppSetting getAutoLogin]) {
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
                [StatisticsManager event:kAccountBalanceFail_Recharge];
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
    if ([AppSetting getAutoLogin]) {
        if (isPraiseing) {
            return;
        }
        isPraiseing = YES;
        ZWEAKSELF
        __weak typeof(ModelCurriculum) *modelC = self.modelCurriculum;
        if (!self.modelCurriculum.isPraise) {
            //点赞
            [snsV1 postClickLikeWithAId:self.modelCurriculum.ids userId:[AppSetting getUserDetauleId] type:@"5" resultBlock:^(NSDictionary *result) {
                isPraiseing = NO;
                if ([modelC.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
                    
                    [weakSelf.modelCurriculum setIsPraise:YES];
                    weakSelf.modelCurriculum.applauds += 1;
                    
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                        [viewTabbar setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                    });
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:[AppSetting getUserDetauleId]];
                }
            } errorBlock:^(NSString *msg) {
                isPraiseing = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            [snsV1 postClickUnLikeWithAId:self.modelCurriculum.ids userId:[AppSetting getUserDetauleId] type:@"5" resultBlock:^(NSDictionary *result) {
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
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:[AppSetting getUserDetauleId]];
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
    if ([AppSetting getAutoLogin]) {
        if (isPraiseing) {
            return;
        }
        isPraiseing = YES;
        ZWEAKSELF
        __weak typeof(ModelPractice) *modelP = self.modelPractice;
        if (!self.modelPractice.isPraise) {
            //点赞
            [snsV1 postClickLikeWithAId:self.modelPractice.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                isPraiseing = NO;
                if ([modelP.ids isEqualToString:weakSelf.modelPractice.ids]) {
                    
                    [weakSelf.modelPractice setIsPraise:YES];
                    weakSelf.modelPractice.applauds += 1;
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModel:weakSelf.modelPractice];
                        [viewTabbar setViewDataWithModel:weakSelf.modelPractice];
                    });
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:[AppSetting getUserDetauleId]];
                }
            } errorBlock:^(NSString *msg) {
                isPraiseing = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            [snsV1 postClickUnLikeWithAId:self.modelPractice.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
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
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:[AppSetting getUserDetauleId]];
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
    if ([AppSetting getAutoLogin]) {
        if (isCollectioning) {
            return;
        }
        isCollectioning = YES;
        ZWEAKSELF
        __weak typeof(ModelPractice) *modelP = self.modelPractice;
        if (!self.modelPractice.isCollection) {
            //收藏
            [snsV1 getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelPractice.ids flag:1 type:@"3" resultBlock:^(NSDictionary *result) {
                isCollectioning = NO;
                if ([modelP.ids isEqualToString:weakSelf.modelPractice.ids]) {
                    [weakSelf.modelPractice setIsCollection:YES];
                    weakSelf.modelPractice.ccount += 1;
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModel:weakSelf.modelPractice];
                        [viewTabbar setViewDataWithModel:weakSelf.modelPractice];
                    });
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:[AppSetting getUserDetauleId]];
                }
            } errorBlock:^(NSString *msg) {
                isCollectioning = NO;
                GCDMainBlock(^{
                });
                [ZProgressHUD showError:msg];
            }];
        } else {
            //取消收藏
            [snsV1 getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelPractice.ids type:@"3" resultBlock:^(NSDictionary *result) {
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
                    [sqlite setLocalPlayPracticeDetailWithModel:weakSelf.modelPractice userId:[AppSetting getUserDetauleId]];
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
    if ([AppSetting getAutoLogin]) {
        if (isCollectioning) {
            return;
        }
        isCollectioning = YES;
        ZWEAKSELF
        __weak typeof(ModelCurriculum) *modelC = self.modelCurriculum;
        if (!self.modelCurriculum.isCollection) {
            //收藏
            [snsV1 getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelCurriculum.ids flag:5 type:@"7" resultBlock:^(NSDictionary *result) {
                isCollectioning = NO;
                if ([modelC.ids isEqualToString:weakSelf.modelCurriculum.ids]) {
                    [weakSelf.modelCurriculum setIsCollection:YES];
                    weakSelf.modelCurriculum.ccount += 1;
                    GCDMainBlock(^{
                        [viewButton setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                        [viewTabbar setViewDataWithModelCurriculum:weakSelf.modelCurriculum];
                    });
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:[AppSetting getUserDetauleId]];
                }
            } errorBlock:^(NSString *msg) {
                isCollectioning = NO;
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消收藏
            [snsV1 getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelCurriculum.ids type:@"7" resultBlock:^(NSDictionary *result) {
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
                    [sqlite setLocalPlayCurriculumDetailWithModel:weakSelf.modelCurriculum userId:[AppSetting getUserDetauleId]];
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
    [sqlite setLocalPlayPracticeDetailWithModel:self.modelPractice userId:[AppSetting getUserDetauleId]];
    ZWEAKSELF
    [snsV2 getPracticeDetailWithPracticeId:self.modelPractice.ids userId:[AppSetting getUserDetauleId] resultBlock:^(ModelPractice *resultModel) {
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
            [sqlite setLocalPlayPracticeDetailWithModel:resultModel userId:[AppSetting getUserDetauleId]];
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
    [sqlite setLocalPlayCurriculumDetailWithModel:self.modelCurriculum userId:[AppSetting getUserDetauleId]];
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
            [sqlite setLocalPlayCurriculumDetailWithModel:resultModel userId:[AppSetting getUserDetauleId]];
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
    NSInteger second = [XMSDKPlayer sharedPlayer].currentTrack.duration*value;
    [[XMSDKPlayer sharedPlayer] seekToTime:second];
}
/// 设置最大滑动值
- (void)setMaxDuratuin:(NSUInteger)duration
{
    [viewFunction setMaxDuratuin:duration];
    if (self.onTrackWillPlaying) {
        self.onTrackWillPlaying(duration);
    }
}
///准备播放
-(void)setReadyPlay
{
    if ([XMSDKPlayer sharedPlayer].currentTrack.trackId != self.modelTrack.trackId) {
        [[XMSDKPlayer sharedPlayer] stopTrackPlay];
    } else {
        [self setStartPlay];
        //[[XMSDKPlayer sharedPlayer] replacePlayList:self.arrayTrack];
    }
    if (self.isPlaying) {
        [viewFunction setStartPlay];
    } else {
        [viewFunction setPausePlay];
    }
}
///开始播放
-(void)setStartPlay
{
    [[XMSDKPlayer sharedPlayer] setPlayMode:XMSDKPlayModeTrack];
    [[XMSDKPlayer sharedPlayer] setTrackPlayMode:XMTrackPlayerModeList];
    [[XMSDKPlayer sharedPlayer] playWithTrack:self.modelTrack playlist:self.arrayTrack];
}
///暂停播放
-(void)setPausePlay
{
    [[XMSDKPlayer sharedPlayer] pauseTrackPlay];
}
///恢复播放
-(void)setResumePlay
{
    [[XMSDKPlayer sharedPlayer] resumeTrackPlay];
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
///上一首
-(void)btnPreClick
{
    [self setModelStatisics];
    [self preIndexChange];
    [self setDefaultModel];
    [self setCheckDownload];
    [[XMSDKPlayer sharedPlayer] playPrevTrack];
    [self setIsShowNowPlaying:NO];
}
///下一首
-(void)btnNextClick
{
    [self setModelStatisics];
    [self nextIndexChange];
    [self setDefaultModel];
    [self setCheckDownload];
    [[XMSDKPlayer sharedPlayer] playNextTrack];
    [self setIsShowNowPlaying:NO];
}
///设置数据模型打点
-(void)setModelStatisics
{
    NSString *eventId = kSubscription_List_PlayTime;
    switch (self.modelTrack.dataType) {
        case ZDownloadTypePractice: eventId = kPractice_List_PlayTime; break;
        default: break;
    }
    if (self.modelTrack.ids && self.modelTrack.trackTitle) {
        [StatisticsManager event:eventId value:[XMSDKPlayer sharedPlayer].currentTrack.listenedTime dictionary:@{kObjectId:self.modelTrack.ids,kObjectTitle:self.modelTrack.trackTitle,kObjectUser:[AppSetting getUserDetauleId]}];
    } else {
        [StatisticsManager event:eventId value:[XMSDKPlayer sharedPlayer].currentTrack.listenedTime];
    }
}
///播放倍率
-(void)playWithRate:(float)rate
{
    [[XMSDKPlayer sharedPlayer] setPlayRate:rate];
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
    XMTrackDownloadStatus *status = [[XMSDKDownloadManager sharedSDKDownloadManager] getSingleTrackDownloadStatus:self.modelTrack.trackId];
    switch (status.state) {
        case XMCacheTrackStatusDownloaded:
        {
            NSInteger userId = [[AppSetting getUserDetauleId] integerValue];
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
    GBLog(@"XMTrackDownloadStatus: %d------0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载", (int)status);
}
///开始下载
-(void)setDownloadClick
{
    if ([AppSetting getAutoLogin]) {
        
        ZDownloadStatus status = (NSInteger)[[XMSDKDownloadManager sharedSDKDownloadManager] downloadSingleTrack:self.modelTrack immediately:YES];
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
        GBLog(@"XMTrackDownloadStatus: %d------0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载", (int)status);
    } else {
        [self showLoginVC];
    }
}
///暂停下载
-(void)setSuspendDownload
{
    [[XMSDKDownloadManager sharedSDKDownloadManager] pauseDownloadSingleTrack:self.modelTrack];
}

#pragma mark - SDKDownloadMgrDelegate
///下载失败时被调用
- (void)XMTrackDownloadDidFailed:(XMTrack *)track
{
    [ZProgressHUD showSuccess:kDownloadFail];
    GBLog(@"XMTrackDownloadDidFailed: %@", track.trackTitle);
}
////下载完成时被调用
- (void)XMTrackDownloadDidFinished:(XMTrack *)track
{
    if (self.modelTrack.trackId == track.trackId) {
        [viewButton setDownloadButtonImageNoSuspend:(ZDownloadStatusEnd)];
    }
    GBLog(@"XMTrackDownloadDidFinished: %@", track.trackTitle);
}
///下载开始时被调用
- (void)XMTrackDownloadDidBegan:(XMTrack *)track
{
    if (track.trackId == self.modelTrack.trackId) {
        [ZProgressHUD showSuccess:kJoinDownload];
    }
    GBLog(@"XMTrackDownloadDidBegan: %@, downloadedBytes: %ld", track.trackTitle, (long)track.downloadedBytes);
}
///下载取消时被调用
- (void)XMTrackDownloadDidCanceled:(XMTrack *)track
{
    GBLog(@"XMTrackDownloadDidCanceled: %@", track.trackTitle);
}
///下载暂停时被调用
- (void)XMTrackDownloadDidPaused:(XMTrack *)track
{
    GBLog(@"XMTrackDownloadDidPaused: %@", track.trackTitle);
}
///下载进度更新时被调用
- (void)XMTrack:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    GBLog(@"XMTrack: %@, updateDownloadedPercent: %f", track.trackTitle, downloadedPercent);
}
///下载状态更新为ready时被调用
- (void)XMTrackDownloadStatusUpdated:(XMTrack *)track
{
    GBLog(@"XMTrackDownloadStatusUpdated: %@", track.trackTitle);
}
///从数据库载入数据时被调用
- (void)XMTrackDownloadDidLoadFromDB
{
    GBLog(@"XMTrackDownloadDidLoadFromDB");
}

#pragma mark - XMTrackPlayerDelegate

- (void)XMTrackPlayNotifyProcess:(CGFloat)percent currentSecond:(NSUInteger)currentSecond
{
    if (self.isPlaying) {
        if (self.onTrackPlayNotifyProcess) {
            self.onTrackPlayNotifyProcess(percent, currentSecond);
        }
        [viewFunction setViewCurrentTime:currentSecond percent:percent];
        
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            [self setLockViewWithCurrentTime:currentSecond];
        }
    }
    GBLog(@"XMTrackPlayNotifyProcess: %lf, currentSecond: %ld", percent, (unsigned long)currentSecond);
}
- (void)XMTrackPlayNotifyCacheProcess:(CGFloat)percent
{
    if (self.onTrackPlayNotifyCacheProcess) {
        self.onTrackPlayNotifyCacheProcess(percent);
    }
    [viewFunction setViewProgress:percent];
    GBLog(@"XMTrackPlayNotifyCacheProcess: %lf", percent);
}
- (void)XMTrackPlayerDidStart
{
    [self setIsShowNowPlaying:NO];
    GBLog(@"XMTrackPlayerDidStart: %ld", (long)[[XMSDKPlayer sharedPlayer] playerState]);
}
- (void)XMTrackPlayerWillPlaying
{
    [self setIsShowNowPlaying:NO];
    //TODO:ZWW-备注采用本地播放器总时间
    /*NSInteger duration = [XMSDKPlayer sharedPlayer].currentTrack.duration;
    [self setMaxDuratuin:duration];*/
    [snsV2 addPlayStaticalWithObjectId:self.modelTrack.ids type:self.modelTrack.dataType resultBlock:nil errorBlock:nil];
    GBLog(@"XMTrackPlayerWillPlaying: %ld,  currentTrack.listenedTime: %ld,  currentTrack.duration: %ld", (long)[XMSDKPlayer sharedPlayer].playerState, (long)[XMSDKPlayer sharedPlayer].currentTrack.listenedTime, (long)[XMSDKPlayer sharedPlayer].currentTrack.duration);
}
-(void)XMTrackPlayerDidEnd
{
    [self btnNextClick];
    [self setIsShowNowPlaying:NO];
    GBLog(@"XMTrackPlayerDidEnd: %ld", (long)[XMSDKPlayer sharedPlayer].playerState);
}
-(void)XMTrackPlayerDidPlaylistEnd
{
    [[XMSDKPlayer sharedPlayer] stopTrackPlay];
    [self setIsShowNowPlaying:NO];
    GBLog(@"XMTrackPlayerDidPlaylistEnd: %ld", (long)[XMSDKPlayer sharedPlayer].playerState);
}
- (void)XMTrackPlayerDidPlaying
{
    [self setIsShowNowPlaying:NO];
    [viewFunction setStartPlay];
    GBLog(@"XMTrackPlayerDidPlaying: %ld", (long)[XMSDKPlayer sharedPlayer].playerState);
}
- (void)XMTrackPlayerDidPaused
{
    [self setModelStatisics];
    [viewFunction setPausePlay];
    GBLog(@"XMTrackPlayerDidPaused: %ld", (long)[XMSDKPlayer sharedPlayer].playerState);
}
- (void)XMTrackPlayerDidStopped
{
    [viewFunction setPausePlay];
    GBLog(@"XMTrackPlayerDidStopped: %ld", (long)[XMSDKPlayer sharedPlayer].playerState);
}
- (void)XMTrackPlayerDidFailedToPlayTrack:(XMTrack *)track withError:(NSError *)error
{
    if (self.onTrackPlayFailed) {
        self.onTrackPlayFailed(error);
    }
    [ZProgressHUD showError:kFailedToReadAudioFile];
    GBLog(@"XMTrackPlayerDidFailedToPlayTrack Error:%ld, %@, %@", (long)error.code, error.domain, error.userInfo[NSLocalizedDescriptionKey]);
}
- (void)XMTrackPlayerDidErrorWithType:(NSString *)type withData:(NSDictionary*)data
{
    [[XMSDKPlayer sharedPlayer] resumeTrackPlay];
    GBLog(@"XMTrackPlayerDidErrorWithType: %@, withData: %@", type, data);
}
- (BOOL)XMTrackPlayerShouldContinueNextTrackWhenFailed:(XMTrack *)track
{
    return NO;
}

#pragma mark - AppBackgroundPlayingInfo

/// 设置当前播放语音的效果
- (void)setLockViewWithCurrentTime:(CGFloat)currentTime
{
    if (self.isShowNowPlaying
        || self.modelTrack == nil
        || self.modelTrack.trackTitle == nil
        || self.modelTrack.announcer == nil
        || self.modelTrack.announcer.nickname == nil) {
        return;
    }
    [self setIsShowNowPlaying:YES];
    if(NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dicMusicInfo = [NSMutableDictionary dictionary];
        // 设置Singer
        [dicMusicInfo setObject:self.modelTrack.announcer.nickname forKey:MPMediaItemPropertyArtist];
        // 设置歌曲名
        [dicMusicInfo setObject:self.modelTrack.trackTitle forKey:MPMediaItemPropertyTitle];
        // 设置封面
        NSURL *imageUrl = [NSURL URLWithString:[Utils getMiddlePicture:self.modelTrack.coverUrlSmall]];
        UIImage *image = [SkinManager getImageWithName:@"Icon"];
        if (imageUrl && [[UIApplication sharedApplication] canOpenURL:imageUrl]) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl] scale:1];
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dicMusicInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
        //音乐剩余时长
        [dicMusicInfo setObject:[NSNumber numberWithInteger:self.modelTrack.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间
        [dicMusicInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dicMusicInfo];
    }
}

@end
