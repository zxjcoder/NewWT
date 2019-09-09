//
//  ZCurriculumDetailViewController.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCurriculumDetailViewController.h"
#import "ZWebView.h"
#import "ZBackgroundView.h"
#import "DownLoadManager.h"
#import "ZPlayerViewController.h"
#import "ZCurriculumMessageViewController.h"

@interface ZCurriculumDetailViewController ()<ZWebViewDelegate,DownloadManagerDelegate>

@property (strong, nonatomic) ZWebView *webView;

@property (strong, nonatomic) ZBackgroundView *viewBackground;

@property (strong, nonatomic) ModelCurriculum *model;

@property (strong, nonatomic) ModelAudio *modelA;

@property (strong, nonatomic) NSDictionary *dicResult;

@property (assign, nonatomic) BOOL isPraiseing;

@property (assign, nonatomic) CGRect webFrame;

@property (assign, nonatomic) BOOL isDeleteing;

@end

@implementation ZCurriculumDetailViewController

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
    
    [self setPlayStatus];
    
    [[DownLoadManager sharedHelper] setDelegate:self];
    
    //[self setRightShareButtonOnly];
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
    OBJC_RELEASE(_modelA);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.webFrame = VIEW_ITEM_FRAME;
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
        } else if ([key isEqualToString:@"titleclick"]) {
            [weakSelf showPlayVCWithCurriculumArray:@[weakSelf.model] index:0];
        } else if ([key isEqualToString:@"deletecomment"]) {
            [weakSelf setDeleteMessage:value];
        } else if ([key isEqualToString:@"issuecomment"]) {
            [weakSelf setShowMessageVC];
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
    ZWEAKSELF
    [self.viewBackground setViewStateWithState:(ZBackgroundStateLoading)];
    [snsV2 getCurriculumDetailWebUrlWithCurriculumId:self.model.ids subscribeId:self.model.subscribeId type:1 resultBlock:^(NSString *webUrl, NSDictionary *result) {
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
-(void)setPlayStatus
{
    switch ([[ZPlayerViewController sharedSingleton] getInnerPlayTabbarWithType]) {
        case ZPlayTabBarViewTypeSubscribe:
        {
            ModelAudio *modelA = [[ZPlayerViewController sharedSingleton] getPlayingModelAudio];
            if (modelA && [modelA.ids isEqualToString:self.model.ids]) {
                if ([[ZPlayerViewController sharedSingleton] isStartPlaying]) {
                    [self setCallBackJavaScriptStartPlay];
                } else {
                    [self setCallBackJavaScriptPausePlay];
                }
            }
            break;
        }
        default: break;
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
-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    [self setModel:model];
    [self.model setFree_read:0];
    [self setModelA:[[ModelAudio alloc] initWithModelCurriculum:model]];
}
-(id)getWebView
{
    return self.webView.realWebView;
}
///显示留言界面
-(void)setShowMessageVC
{
    ZCurriculumMessageViewController *itemVC = [[ZCurriculumMessageViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:self.model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
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
    [self setPlayStatus];
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
    if (model && self.modelA && [self.modelA.ids isEqualToString:model.ids]) {
        [self setCallBackJavaScriptPausePlay];
    }
}
-(void)ZDownloadManagerDidFinishDownLoad:(ModelAudio *)model
{
    if (model && self.modelA && [self.modelA.ids isEqualToString:model.ids]) {
        [self setCallBackJavaScriptDownloadEnd];
    }
}
-(void)ZDownloadManager:(ModelAudio *)model didReceiveProgress:(float)progress
{
    if (model && self.modelA && [self.modelA.ids isEqualToString:model.ids]) {
        [self setCallBackJavaScriptWithProgress:progress];
    } else {
        [self setCallBackJavaScriptWithProgress:0];
    }
}

@end
