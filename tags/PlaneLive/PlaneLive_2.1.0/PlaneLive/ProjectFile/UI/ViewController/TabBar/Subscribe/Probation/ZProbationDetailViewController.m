//
//  ZProbationDetailViewController.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZProbationDetailViewController.h"
#import "ZWebView.h"
#import "ZBackgroundView.h"
#import "ZSubscribeTabBarView.h"
#import "ZPlayToolView.h"
#import "ZAccountBalanceViewController.h"
#import "DownLoadManager.h"
#import "ZPlayerViewController.h"

@interface ZProbationDetailViewController ()<ZWebViewDelegate,DownloadManagerDelegate>

@property (strong, nonatomic) ZWebView *webView;

@property (strong, nonatomic) ZBackgroundView *viewBackground;

@property (strong, nonatomic) ZSubscribeTabBarView *viewTabbar;

@property (strong, nonatomic) ModelCurriculum *model;

@property (strong, nonatomic) ModelAudio *modelA;

@end

@implementation ZProbationDetailViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.model.title];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ModelAudio *modelAudio = [[ZPlayerViewController sharedSingleton] getPlayingModelAudio];
    if (modelAudio && [modelAudio.ids isEqualToString:self.modelA.ids]) {
        if ([[ZPlayerViewController sharedSingleton] isStartPlaying]) {
            [self setCallBackJavaScriptStartPlay];
        } else {
            [self setCallBackJavaScriptPausePlay];
        }
    }
    [[DownLoadManager sharedHelper] setDelegate:self];
    
    [self setRightShareButtonOnly];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[DownLoadManager sharedHelper] setDelegate:nil];
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
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_viewTabbar);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.viewTabbar = [[ZSubscribeTabBarView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT-[ZSubscribeTabBarView getViewHeight]) type:1];
    [self.viewTabbar setViewDataWithModelCurriculum:self.model];
    [self.viewTabbar setOnSubscribeClick:^{
        if ([AppSetting getAutoLogin]) {
            ZPlayToolView *viewPlayTool = [[ZPlayToolView alloc] initWithPlayTitle:weakSelf.model.title];
            [viewPlayTool setOnBalanceClick:^{
                [ZProgressHUD showMessage:kCMsgOrdering];
                ///下订单
                [snsV2 getGenerateOrderWithMoney:weakSelf.model.price type:WTPayTypeSubscribe objid:weakSelf.model.ids title:weakSelf.model.title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                    [snsV2 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
                        [ZProgressHUD dismiss];
                        //订购成功
                        [sqlite setLocalOrderDetailWithModel:model userId:[AppSetting getUserDetauleId]];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:ZSubscribeSuccessNotification object:nil];
                        
                        [ZAlertView showWithMessage:kSubscriptionSuccess completion:^{
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }];
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
                            case 1:
                            {
                                [weakSelf setShowAccountVC];
                                break;
                            }
                            default:break;
                        }
                    } cancelTitle:kCancel doneTitle:kToRecharge];
                }];
            }];
            [viewPlayTool show];
        } else {
            [weakSelf showLoginVC];
        }
    }];
    [self.view addSubview:self.viewTabbar];
    
    self.webView = [[ZWebView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-self.viewTabbar.height) registerMonitorScript:YES];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
    [self.webView setOnDidReceiveScriptMessage:^(WKScriptMessage *script) {
        NSString *key = [script.body objectForKey:@"key"];
        if ([key isEqualToString:@"startdownload"]) {
            [weakSelf setStartDownload];
        } else if ([key isEqualToString:@"pausedownload"]) {
            [weakSelf setPauseDownload];
        } else if ([key isEqualToString:@"startplay"]) {
            [weakSelf setStartPlay];
        } else if ([key isEqualToString:@"pauseplay"]) {
            [weakSelf setPausePlay];
        } else if ([key isEqualToString:@"likecomment"]) {
            
        } else if ([key isEqualToString:@"unlikecomment"]) {
            
        } else if ([key isEqualToString:@"titleclick"]) {
            [weakSelf showPlayVCWithCurriculumArray:@[weakSelf.model] index:0];
        } else if ([key isEqualToString:@"deletecomment"]) {
            
        } else if ([key isEqualToString:@"issuecomment"]) {
            
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

-(void)innerData
{
    ZWEAKSELF
    [self.viewBackground setViewStateWithState:(ZBackgroundStateLoading)];
    [snsV2 getCurriculumDetailWebUrlWithCurriculumId:self.model.ids subscribeId:self.model.subscribeId type:self.model.free_read resultBlock:^(NSString *webUrl, NSDictionary *result) {
        if (![webUrl isKindOfClass:[NSNull class]] &&[webUrl isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:webUrl];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:url]];
        } else {
            [weakSelf.viewBackground setViewStateWithState:(ZBackgroundStateFail)];
        }
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewBackground setViewStateWithState:(ZBackgroundStateFail)];
    }];
}
-(void)btnRightClick
{
    [self btnShareClick];
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
    NSString *title = self.model.ctitle;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.model.content;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.model.audio_picture];
    NSString *webUrl = kApp_CurriculumContentUrl(self.model.subscribeId, self.model.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
///开始下载
-(void)setStartDownload
{
    if ([AppSetting getAutoLogin]) {
        [[DownLoadManager sharedHelper] setDownloadWithModel:self.modelA];
    } else {
        [self showLoginVC];
    }
}
///暂停下载
-(void)setPauseDownload
{
    [[DownLoadManager sharedHelper] suspend];
}
///开始播放
-(void)setStartPlay
{
    [self setStartPlayVCWithCurriculum:self.model];
}
///暂停播放
-(void)setPausePlay
{
    [self setPausePlayVCWithCurriculum:self.model];
}
///显示充值页面
-(void)setShowAccountVC
{
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}
-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    [self setModel:model];
    [self.model setFree_read:1];
    [self setModelA:[[ModelAudio alloc] initWithModelCurriculum:model]];
}

-(id)getWebView
{
    return self.webView.realWebView;
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
#pragma mark - ZWebViewDelegate

-(BOOL)webView:(ZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(ZWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(ZWebView *)webView
{
    if (!self.title) {
        [self setTitle:self.webView.title];
    }
    [self.viewBackground setViewStateWithState:(ZBackgroundStateNone)];
    
    if (self.model.audio_url && self.model.audio_url.length > 0) {
        NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.model.audio_url]] stringByAppendingPathExtension:kPathExtension];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self setCallBackJavaScriptDownloadEnd];
        }
    }
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

-(void)ZDownloadManagerDidErrorDownLoad:(ModelAudio *)model didReturnError:(NSError *)error
{
    if ([self.modelA.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [self setCallBackJavaScriptPausePlay];
        });
    }
}
-(void)ZDownloadManagerDidFinishDownLoad:(ModelAudio *)model
{
    if ([self.modelA.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [self setCallBackJavaScriptDownloadEnd];
        });
    }
}
-(void)ZDownloadManager:(ModelAudio *)model didReceiveProgress:(float)progress
{
    GCDMainBlock(^{
        if ([self.modelA.ids isEqualToString:model.ids]) {
            [self setCallBackJavaScriptWithProgress:progress];
        } else {
            [self setCallBackJavaScriptWithProgress:0];
        }
    });
}

@end
