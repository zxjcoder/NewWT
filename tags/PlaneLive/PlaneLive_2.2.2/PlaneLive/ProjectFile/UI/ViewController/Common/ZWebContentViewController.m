//
//  ZWebContentViewController.m
//  PlaneLive
//
//  Created by Daniel on 06/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZWebContentViewController.h"
#import "DownloadManager.h"
#import "ZWebView.h"
#import "ZBackgroundView.h"
#import "ZPlayerViewController.h"
#import "ZCurriculumMessageViewController.h"
#import "ZPlayRewardView.h"
#import "ZPlayToolView.h"
#import "ZAccountBalanceViewController.h"
#import "ZPlaybackProgressView.h"
#import "XMTrackDownloadStatus.h"

@interface ZWebContentViewController ()<ZWebViewDelegate, DownloadManagerDelegate>

@property (strong, nonatomic) ZWebView *webView;
@property (strong, nonatomic) ZBackgroundView *viewBackground;
@property (strong, nonatomic) ZPlaybackProgressView *viewPlaybackProgress;
@property (strong, nonatomic) ModelPractice *modelP;
@property (strong, nonatomic) ModelCurriculum *modelC;
@property (strong, nonatomic) ModelTrack *modelTrack;
@property (strong, nonatomic) NSDictionary *dicResult;
@property (assign, nonatomic) BOOL isPraiseing;
@property (assign, nonatomic) CGRect webFrame;
@property (assign, nonatomic) BOOL isDeleteing;
@property (assign, nonatomic) BOOL isLoadingEnd;
@property (assign, nonatomic) BOOL isMessageLoad;
@property (assign, nonatomic) NSInteger currentSecond;
@property (assign, nonatomic) BOOL isCourse;
@property (assign, nonatomic) BOOL isShowNowPlaying;

@end

@implementation ZWebContentViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setThisPlayState];
    //设置分享按钮
    switch (self.modelTrack.dataType) {
        case ZDownloadTypePractice:
        {
            //免费和收费实务可以分享
            [self setRightShareButtonOnly];
            break;
        }
        default:
        {
            //试读订阅或系列课可以分享
            if (self.modelC && self.modelC.free_read == 1) {
                [self setRightShareButtonOnly];
            }
            break;
        }
    }
    if (self.isCourse) {
        ZWEAKSELF
        [[ZPlayerViewController sharedSingleton] setOnTrackPlayNotifyProcess:^(CGFloat percent, NSUInteger currentSecond) {
            [weakSelf.viewPlaybackProgress setViewCurrentTime:currentSecond percent:percent];
        }];
        [[ZPlayerViewController sharedSingleton] setOnTrackPlayNotifyCacheProcess:^(CGFloat percent) {
            [weakSelf.viewPlaybackProgress setStartPlay];
            [weakSelf setCallBackJavaScriptStartPlay];
            [weakSelf.viewPlaybackProgress setViewProgress:percent];
        }];
        [[ZPlayerViewController sharedSingleton] setOnTrackWillPlaying:^(NSInteger duration) {
            [weakSelf.viewPlaybackProgress setViewProgress:0];
            [weakSelf.viewPlaybackProgress setViewCurrentTime:0 percent:0];
            [weakSelf.viewPlaybackProgress setTotalDuration:duration];
        }];
        [[ZPlayerViewController sharedSingleton] setOnTrackPlayFailed:^(NSError *error) {
            [weakSelf.viewPlaybackProgress setViewProgress:0];
            [weakSelf.viewPlaybackProgress setViewCurrentTime:0 percent:0];
            [weakSelf.viewPlaybackProgress setTotalDuration:0];
            [weakSelf.viewPlaybackProgress setPausePlay];
            [weakSelf setCallBackJavaScriptPausePlay];
        }];
        [[ZPlayerViewController sharedSingleton] setOnPlayNextChange:^(ModelEntity *model) {
            [weakSelf setViewDataWithModel:model isCourse:weakSelf.isCourse];
            [weakSelf innerData];
        }];
        if ([ZPlayerViewController sharedSingleton].modelTrack.trackId == self.modelTrack.trackId) {
            [self.viewPlaybackProgress setTotalDuration:[PlayerManager sharedPlayer].currentTrack.duration];
        }
    }
    [[DownloadManager sharedManager] setDownloadDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isCourse) {
        [[ZPlayerViewController sharedSingleton] setOnTrackWillPlaying:nil];
        [[ZPlayerViewController sharedSingleton] setOnTrackPlayFailed:nil];
        [[ZPlayerViewController sharedSingleton] setOnPlayNextChange:nil];
        [[ZPlayerViewController sharedSingleton] setOnTrackPlayNotifyProcess:nil];
        [[ZPlayerViewController sharedSingleton] setOnTrackPlayNotifyCacheProcess:nil];
    }
    [[DownloadManager sharedManager] setDownloadDelegate:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    _webView.delegate = nil;
    OBJC_RELEASE(_webView);
    OBJC_RELEASE(_modelP);
    OBJC_RELEASE(_modelC);
    OBJC_RELEASE(_modelTrack);
    OBJC_RELEASE(_dicResult);
    OBJC_RELEASE(_viewBackground);
    OBJC_RELEASE(_viewPlaybackProgress);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    CGRect webFrame = VIEW_ITEM_FRAME;
    if (self.isCourse) {
        webFrame.size.height -= APP_TABBAR_HEIGHT;
        self.viewPlaybackProgress = [[ZPlaybackProgressView alloc] initWithFrame:CGRectMake(0, webFrame.origin.y+webFrame.size.height, webFrame.size.width, APP_TABBAR_HEIGHT)];
        [self.viewPlaybackProgress setTotalDuration:0];
        [self.viewPlaybackProgress setOnPlayClick:^{
            [weakSelf setStartPlay];
        }];
        [self.viewPlaybackProgress setOnStopClick:^{
            [weakSelf setPausePlay];
        }];
        [self.viewPlaybackProgress setOnSliderValueChange:^(CGFloat sliderValue) {
            [[ZPlayerViewController sharedSingleton] setPlaySliderValue:sliderValue];
        }];
        [self.view addSubview:self.viewPlaybackProgress];
    }
    self.webFrame = webFrame;
    self.webView = [[ZWebView alloc] initWithFrame:self.webFrame registerMonitorScript:YES];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
    [self.webView setOnDidReceiveScriptMessage:^(WKScriptMessage *script) {
        NSString *key = [script.body objectForKey:@"key"];
        NSString *value = [Utils getSNSString:[script.body objectForKey:@"value"]];
        if ([key isEqualToString:@"startdownload"]) {
            [weakSelf setStartDownload];
        } else if ([key isEqualToString:@"pausedownload"]) {
            [weakSelf setPauseDownload];
        } else if ([key isEqualToString:@"startplay"]) {
            [weakSelf setStartPlay];
        } else if ([key isEqualToString:@"pauseplay"]) {
            [weakSelf setPausePlay];
        } else if ([key isEqualToString:@"likecomment"]) {
            [weakSelf setMessagePraise:value];
        } else if ([key isEqualToString:@"unlikecomment"]) {
            [weakSelf setMessageUnPraise:value];
        } else if ([key isEqualToString:@"deletecomment"]) {
            [weakSelf setDeleteMessage:value];
        } else if ([key isEqualToString:@"issuecomment"]) {
            [weakSelf setShowMessageVC];
        } else if ([key isEqualToString:@"issueReward"]) {
            [weakSelf setShowRewardVC];
        } else if ([key isEqualToString:@"saveuseremail"]) {
            ModelUser *modelU = [AppSetting getUserLogin];
            [modelU setEmail:value];
            [AppSetting setUserLogin:modelU];
            [AppSetting save];
        } else if ([key isEqualToString:@"titleclick"]) {
            switch (weakSelf.modelTrack.dataType) {
                case ZDownloadTypePractice:
                {
                    if ([[ZPlayerViewController sharedSingleton].modelPractice.ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.navigationController pushViewController:[ZPlayerViewController sharedSingleton] animated:YES];
                    } else {
                        [weakSelf showPlayVCWithPracticeArray:@[weakSelf.modelP] index:0];
                    }
                    break;
                }
                default:
                {
                    if ([[ZPlayerViewController sharedSingleton].modelCurriculum.ids isEqualToString:weakSelf.modelC.ids]) {
                        [weakSelf.navigationController pushViewController:[ZPlayerViewController sharedSingleton] animated:YES];
                    } else {
                        [weakSelf showPlayVCWithCurriculumArray:@[weakSelf.modelC] index:0];
                    }
                    break;
                }
            }
        }
    }];
    
    self.viewBackground = [[ZBackgroundView alloc] initWithFrame:self.webView.bounds];
    [self.viewBackground setOnButtonClick:^{
        [weakSelf innerData];
    }];
    [self.webView addSubview:self.viewBackground];
    
    [super innerInit];
    
    [self innerData];
}
///初始化数据
-(void)innerData
{
    [self.viewBackground setViewStateWithState:(ZBackgroundStateLoading)];
    switch (self.modelTrack.dataType) {
        case ZDownloadTypePractice:
            if (self.isCourse) {
                [self innerDataPracticeCourse];
            } else {
                [self innerDataPracticeContent];
            }
            break;
        default:
            if (self.isCourse) {
                [self innerDataCurriculumContentWithType:2];
            } else {
                if (self.modelC.free_read == 0) {
                    [self innerDataCurriculumContentWithType:1];
                } else {
                    [self innerDataCurriculumContentWithType:0];
                }
            }
            break;
    }
    [self setTitle:self.modelTrack.trackTitle];
}
///加载实务内容
-(void)innerDataPracticeContent
{
    NSURL *url =  [NSURL URLWithString:kApp_PracticeContentUrl(self.modelP.ids)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30]];
}
///加载实务课件
-(void)innerDataPracticeCourse
{
    NSURL *url =  [NSURL URLWithString:kApp_PracticeCourseUrl(self.modelP.ids)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30]];
}
///加载订阅内容
-(void)innerDataCurriculumContentWithType:(int)type
{
    ZWEAKSELF
    [snsV2 getCurriculumDetailWebUrlWithCurriculumId:self.modelC.ids subscribeId:self.modelC.subscribeId type:type resultBlock:^(NSString *webUrl, NSDictionary *result) {
        if (![webUrl isKindOfClass:[NSNull class]] && [webUrl isKindOfClass:[NSString class]]) {
            NSURL *url =  [NSURL URLWithString:webUrl];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:url]];
        } else {
            [weakSelf.viewBackground setViewStateWithState:(ZBackgroundStateFail)];
        }
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewBackground setViewStateWithState:(ZBackgroundStateFail)];
    }];
}
///设置当前播放状态
-(void)setThisPlayState
{
    //设置当前播放状态
    ModelTrack *modelT = [[ZPlayerViewController sharedSingleton] modelTrack];
    if (modelT && modelT.trackId == self.modelTrack.trackId) {
        if ([[ZPlayerViewController sharedSingleton] isPlaying]) {
            [self.viewPlaybackProgress setStartPlay];
            [self setCallBackJavaScriptStartPlay];
        } else {
            [self.viewPlaybackProgress setPausePlay];
            [self setCallBackJavaScriptPausePlay];
        }
    }
}
///分享按钮点击事件
-(void)btnShareClick
{
    ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    ZWEAKSELF
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
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelTrack.trackTitle;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelTrack.trackIntro;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelTrack.coverUrlSmall];
    NSString *webUrl = nil;
    if (self.isCourse) {
        switch (self.modelTrack.dataType) {
            case ZDownloadTypePractice: webUrl = kApp_PracticeCourseUrl(self.modelP.ids); break;
            default: webUrl = kApp_CurriculumContentUrl(self.modelC.subscribeId, self.modelC.ids); break;
        }
    } else {
        switch (self.modelTrack.dataType) {
            case ZDownloadTypePractice: webUrl = kApp_PracticeContentUrl(self.modelP.ids); break;
            default: webUrl = kApp_CurriculumContentUrl(self.modelC.subscribeId, self.modelC.ids); break;
        }
    }
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
///设置数据源
-(void)setViewDataWithModel:(ModelEntity *)model isCourse:(BOOL)isCourse
{
    [self setIsCourse:isCourse];
    if ([model isKindOfClass:[ModelPractice class]]) {
        [self setModelP:(ModelPractice *)model];
        [self setModelTrack:[[ModelTrack alloc] initWithModelPractice:self.modelP]];
        
        [sqlite setLocalPlayPracticeDetailWithModel:self.modelP userId:kLoginUserId];
    } else if ([model isKindOfClass:[ModelCurriculum class]]) {
        [self setModelC:(ModelCurriculum *)model];
        if (self.modelC.is_series_course == 0) {
            [self setModelTrack:[[ModelTrack alloc] initWithModelCurriculum:self.modelC]];
        } else {
            [self setModelTrack:[[ModelTrack alloc] initWithModelSeriesCourses:self.modelC]];
        }
        [sqlite setLocalPlayCurriculumDetailWithModel:self.modelC userId:kLoginUserId];
    }
}
-(id)getWebView
{
    return self.webView.realWebView;
}
///显示打赏
-(void)setShowRewardVC
{
    ZPlayRewardView *rewardView = [[ZPlayRewardView alloc] initWithPlayTitle:self.modelTrack.announcer.nickname organization:self.modelTrack.teamName];
    ZWEAKSELF
    [rewardView setOnRewardPriceClick:^(NSString *price) {
        [weakSelf setRewardSendBuy:price];
    }];
    [rewardView show];
}
///发起打赏
-(void)setRewardSendBuy:(NSString *)price
{
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        ZPlayToolView *viewPlayTool = nil;
        NSInteger playtype = WTPayTypeRewardPractice;
        NSString *objid = self.modelTrack.ids;
        NSString *title = self.modelTrack.trackTitle;
        
        playtype = WTPayTypeRewardSubscribe;
        objid = self.modelTrack.ids;
        title = self.modelTrack.trackTitle;
        viewPlayTool = [[ZPlayToolView alloc] initWithPracticeRewardTitle:[NSString stringWithFormat:kCMsgPaymentelement, price] speakerName:[NSString stringWithFormat:kCMsgAppreciationOfTheRight, self.modelTrack.announcer.nickname]];
        
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
///显示留言界面
-(void)setShowMessageVC
{
    ZCurriculumMessageViewController *itemVC = [[ZCurriculumMessageViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:self.modelC];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
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
                //自己的已经下载过
                if (modelCT.announcer.id == userId && self.modelTrack.trackId == modelCT.trackId) {
                    isDownload = YES;
                    break;
                }
            }
            if (isDownload) {
                [self setCallBackJavaScriptDownloadEnd];
            }
            break;
        }
        default: break;
    }
    GBLog(@"XMTrackDownloadStatus: %d------0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载", (int)status);
}
///开始下载
-(void)setStartDownload
{
    if ([AppSetting getAutoLogin]) {
        ZDownloadStatus status = (NSInteger)[[DownloadManager sharedManager] downloadSingleTrack:self.modelTrack immediately:YES];
        switch (status) {
            case ZDownloadStatusDowloading: [ZProgressHUD showSuccess:kDownloading]; break;
            case ZDownloadStatusUrlError: [ZProgressHUD showSuccess:kDownloadError]; break;
            case ZDownloadStatusSqlError: [ZProgressHUD showSuccess:kDownloadError]; break;
            case ZDownloadStatusAudioDowloading: [ZProgressHUD showSuccess:kDownloading]; break;
            case ZDownloadStatusAudioDowloadEnd: [self setCallBackJavaScriptDownloadEnd]; break;
            case ZDownloadStatusJoin: [ZProgressHUD showSuccess:kJoinDownload]; break;
            default: break;
        }
        [sqlite setLocalDownloadListWithModelTrack:self.modelTrack];
        GBLog(@"XMTrackDownloadStatus: %d------0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载", (int)status);
    } else {
        [self showLoginVC];
    }
}
///暂停下载
-(void)setPauseDownload
{
    [[DownloadManager sharedManager] pauseDownloadSingleTrack:self.modelTrack];
}
///开始播放
-(void)setStartPlay
{
    [self.viewPlaybackProgress setStartPlay];
    ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
    switch (self.modelTrack.dataType) {
        case ZDownloadTypePractice:
        {
            [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
            [itemVC setRawdataWithArray:@[self.modelP] index:0];
            break;
        }
        default:
        {
            [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeSubscribe)];
            [itemVC setRawdataWithArray:@[self.modelC] index:0];
            break;
        }
    }
    [itemVC setStartPlay];
}
///暂停播放
-(void)setPausePlay
{
    [self.viewPlaybackProgress setPausePlay];
    [[ZPlayerViewController sharedSingleton] setPausePlay];
}
///点赞
-(void)setMessagePraise:(NSString *)msgId
{
    if (self.isPraiseing) {
        return;
    }
    ZWEAKSELF
    [self setIsPraiseing:YES];
    [snsV2 postMessagePraiseWithMessageId:msgId resultBlock:^(NSDictionary *result) {
        [weakSelf setIsPraiseing:NO];
        NSString *script = [NSString stringWithFormat:@"wutonglive_set('likecomment', '%@')", msgId];
        [weakSelf.webView evaluateJavaScript:script completionHandler:nil];
    } errorBlock:^(NSString *msg) {
        [weakSelf setIsPraiseing:NO];
        [ZProgressHUD showError:msg];
    }];
}
///取消点赞
-(void)setMessageUnPraise:(NSString *)msgId
{
    if (self.isPraiseing) { return; }
    self.isPraiseing = YES;
    ZWEAKSELF
    [snsV2 postMessageUnPraiseWithMessageId:msgId resultBlock:^(NSDictionary *result) {
        [weakSelf setIsPraiseing:NO];
        NSString *script = [NSString stringWithFormat:@"wutonglive_set('unlikecomment', '%@')", msgId];
        [weakSelf.webView evaluateJavaScript:script completionHandler:nil];
    } errorBlock:^(NSString *msg) {
        [weakSelf setIsPraiseing:NO];
        [ZProgressHUD showError:msg];
    }];
}
///标题点击事件
-(void)setContentTitleClick
{
    switch (self.modelTrack.dataType) {
        case ZDownloadTypePractice: [self showPlayVCWithPracticeArray:@[self.modelP] index:0]; break;
        default: [self showPlayVCWithCurriculumArray:@[self.modelC] index:0]; break;
    }
}
///删除留言
-(void)setDeleteMessage:(NSString *)msgId
{
    if (self.isDeleteing) { return; }
    self.isDeleteing = YES;
    ZWEAKSELF
    [snsV2 postDelMessageContentWithMessageId:msgId resultBlock:^(NSDictionary *result) {
        [weakSelf setIsDeleteing:NO];
        [weakSelf setCallBackJavaScriptWithDelete:msgId];
    } errorBlock:^(NSString *msg) {
        [weakSelf setIsDeleteing:NO];
        [ZProgressHUD showError:msg];
    }];
}
///留言成功回调
-(void)sendMessageSuccess:(NSDictionary *)dicResult
{
    if (dicResult) {
        ModelUser *modelU = [AppSetting getUserLogin];
        NSString *userId = modelU.userId==nil?kEmpty:modelU.userId;
        NSString *nickname = modelU.nickname==nil?kEmpty:modelU.nickname;
        NSString *headImg = modelU.head_img==nil?kEmpty:modelU.head_img;
        NSString *sign = modelU.sign==nil?kEmpty:modelU.sign;
        NSString *messageId = [dicResult objectForKey:@"messageId"];
        messageId = messageId==nil?kEmpty:messageId;
        NSString *content = [dicResult objectForKey:@"content"];
        content = content==nil?kEmpty:content;
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\n"];
        
        NSString *json = [NSString stringWithFormat:@"{\"id\":\"%@\",\"content\":\"%@\",\"user_id\":\"%@\",\"nickname\":\"%@\",\"head_img\":\"%@\",\"sign\":\"%@\"}",messageId,content,userId,nickname,headImg,sign];
        NSString *script = [NSString stringWithFormat:@"wutonglive_set('addcomment', '%@')", json];
        
        [self.webView evaluateJavaScript:script completionHandler:nil];
    }
}
-(void)setViewWithMessageLoad
{
    [self setIsMessageLoad:YES];
}
///设置播放进度
-(void)setPlayTimeWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    NSString *script = [NSString stringWithFormat:@"wutonglive_set('setplaytime', %ld, %ld)", (long)currentTime, (long)totalTime];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}
///删除留言回调JS
-(void)setCallBackJavaScriptWithDelete:(NSString *)msgId
{
    NSString *script = [NSString stringWithFormat:@"wutonglive_set('deletecomment', '%@')", msgId];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}
///下载错误回调
-(void)setCallBackJavaScriptWithDownloadError:(NSString *)error
{
    NSString *script = [NSString stringWithFormat:@"wutonglive_set('errordownload', '%@')", error];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}
///下载结束
-(void)setCallBackJavaScriptDownloadEnd
{
    NSString *script = [NSString stringWithFormat:@"wutonglive_set('downloadprogress', '%@')", kDownloadEnd];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}
///开始播放
-(void)setCallBackJavaScriptStartPlay
{
    [self.webView evaluateJavaScript:@"wutonglive_set('startplay')" completionHandler:nil];
}
///暂停播放
-(void)setCallBackJavaScriptPausePlay
{
    [self.webView evaluateJavaScript:@"wutonglive_set('pauseplay')" completionHandler:nil];
}
///下载进度
-(void)setCallBackJavaScriptWithProgress:(CGFloat)progress
{
    NSString *script = [NSString stringWithFormat:@"wutonglive_set('downloadprogress', '%d%%')", (int)(progress*100)];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}
///预览实务图片集合
-(void)setImagePreviewWithPractice:(NSString *)defaultImage
{
    if (self.modelP.arrImage != nil && self.modelP.arrImage.count > 0 && defaultImage.length > 0) {
        NSInteger defaultIndex = 0;
        BOOL isExistence = NO;
        for (NSString *url in self.modelP.arrImage) {
            if ([defaultImage isEqualToString:url]) {
                isExistence = YES;
                break;
            }
            defaultIndex ++;
        }
        if (isExistence) {
            [self showPhotoBrowserWithArray:self.modelP.arrImage index:defaultIndex];
        }
    }
}
///预览订阅图片集合
-(void)setImagePreviewWithCurriculum:(NSString *)defaultImage
{
    if (self.modelC.course_imges != nil && self.modelC.course_imges > 0 && defaultImage.length > 0) {
        NSInteger defaultIndex = 0;
        BOOL isExistence = NO;
        for (NSString *url in self.modelC.course_imges) {
            if ([defaultImage isEqualToString:url]) {
                isExistence = YES;
                break;
            }
            defaultIndex ++;
        }
        if (isExistence) {
            [self showPhotoBrowserWithArray:self.modelC.course_imges index:defaultIndex];
        }
    }
}
#pragma mark - ZWebViewDelegate

-(BOOL)webView:(ZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"wtqimagepreview"]) {
        NSString *defaultImage = [request.URL.absoluteString substringFromIndex:[@"wtqimagepreview:" length]];
        switch (self.modelTrack.dataType) {
            case ZDownloadTypePractice: [self setImagePreviewWithPractice:defaultImage]; break;
            default: [self setImagePreviewWithCurriculum:defaultImage]; break;
        }
        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(ZWebView *)webView
{
    [self setIsLoadingEnd:NO];
}

-(void)webViewDidFinishLoad:(ZWebView *)webView
{
    if (!self.title) {
        [self setTitle:self.webView.title];
    }
    //设置实务模块字体大小
    if (self.modelTrack) {
        CGFloat fontSize = [[AppSetting getFontSize] floatValue];
        int fontRatio = fontSize/kFont_Set_Default_Size*100;
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%d%%'",fontRatio];
        [webView stringByEvaluatingJavaScriptFromString:jsString];
    }
    //设置图片事件函数
    [webView stringByEvaluatingJavaScriptFromString:@"function wtContentImageClick(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){var img=imgs[i];img.onclick=function(){window.location.href='wtqimagepreview:'+this.src}}}"];
    //执行图片点击事件
    [webView stringByEvaluatingJavaScriptFromString:@"wtContentImageClick();"];
    //检查下载状态
    [self setCheckDownload];
    //保存电子邮件
    ModelUser *modelU = [AppSetting getUserLogin];
    if (modelU && modelU.email && modelU.email.length > 0) {
        NSString *script = [NSString stringWithFormat:@"wutonglive_set('setuseremail', '%@')", modelU.email];
        [self.webView evaluateJavaScript:script completionHandler:nil];
    }
    //跳转到评论区域
    if (self.isMessageLoad) {
        [self.webView evaluateJavaScript:@"wutonglive_set('gotocomment')" completionHandler:nil];
    }
    //设置播放进度
    [self setPlayTimeWithCurrentTime:self.currentSecond totalTime:[[PlayerManager sharedPlayer] currentTrack].duration];
    [self setThisPlayState];
    [self setIsLoadingEnd:YES];
    [self.viewBackground setViewStateWithState:(ZBackgroundStateNone)];
}

-(void)webView:(ZWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.viewBackground setViewStateWithState:(ZBackgroundStateFail)];
}

-(void)webView:(ZWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kDetermine style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertVC addAction:actionCancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)webView:(ZWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kCancel style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:kDetermine style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertVC addAction:actionDone];
    [alertVC addAction:actionCancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - DownloadManagerDelegate

///下载失败时被调用
- (void)trackDownloadDidFailed:(XMTrack *)track
{
    if (track.trackId == self.modelTrack.trackId) {
        [self setCallBackJavaScriptWithDownloadError:kDownloadFail];
    }
}
////下载完成时被调用
- (void)trackDownloadDidFinished:(XMTrack *)track
{
    if (track.trackId == self.modelTrack.trackId) {
        [self setCallBackJavaScriptDownloadEnd];
    }
}
///下载取消时被调用
- (void)trackDownloadDidCanceled:(XMTrack *)track
{
    if (track.trackId == self.modelTrack.trackId) {
        [self setCallBackJavaScriptWithDownloadError:kDownloadCancel];
    }
}
///下载进度更新时被调用
- (void)track:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    if (track.trackId == self.modelTrack.trackId) {
        [self setCallBackJavaScriptWithProgress:downloadedPercent];
    } else {
        [self setCallBackJavaScriptWithProgress:0];
    }
}

@end
