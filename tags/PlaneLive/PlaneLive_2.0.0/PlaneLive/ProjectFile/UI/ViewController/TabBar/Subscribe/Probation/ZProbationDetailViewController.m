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

@interface ZProbationDetailViewController ()<ZWebViewDelegate>

@property (strong, nonatomic) ZWebView *webView;

@property (strong, nonatomic) ZBackgroundView *viewBackground;

@property (strong, nonatomic) ZSubscribeTabBarView *viewTabbar;

@property (strong, nonatomic) ModelCurriculum *model;

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
    
    [self setRightShareButton];
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
                [DataOper200 getGenerateOrderWithMoney:weakSelf.model.price type:WTPayTypeSubscribe objid:weakSelf.model.ids title:weakSelf.model.title payType:(WTPayWayTypeBalance) resultBlock:^(ModelOrderWT *model, NSDictionary *dicResult, NSDictionary *result) {
                    [DataOper200 updOrderStateWithOrderId:model.order_no resultBlock:^(NSDictionary *result) {
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
    
    self.webView = [[ZWebView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-self.viewTabbar.height)];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.webView];
    
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
    [DataOper200 getCurriculumDetailWebUrlWithCurriculumId:self.model.ids subscribeId:self.model.subscribeId type:self.model.free_read resultBlock:^(NSString *webUrl, NSDictionary *result) {
        if (![webUrl isKindOfClass:[NSNull class]] &&[webUrl isKindOfClass:[NSString class]]) {
            NSURL *url =  [NSURL URLWithString:webUrl];
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
    NSString *title = self.model.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.model.ctitle;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.model.audio_picture];
    NSString *webUrl = kApp_CurriculumContentUrl(self.model.subscribeId, self.model.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
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
}

-(id)getWebView
{
    return self.webView.realWebView;
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
}

-(void)webView:(ZWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.viewBackground setViewStateWithState:(ZBackgroundStateFail)];
}

@end
