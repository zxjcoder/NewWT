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

@interface ZCurriculumDetailViewController ()<ZWebViewDelegate>

@property (strong, nonatomic) ZWebView *webView;

@property (strong, nonatomic) ZBackgroundView *viewBackground;

@property (strong, nonatomic) ModelCurriculum *model;

@end

@implementation ZCurriculumDetailViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    //[self setIsDismissPlay:YES];
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
    
    //[self setRightShareButton];
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
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.webView = [[ZWebView alloc] initWithFrame:VIEW_ITEM_FRAME];
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
    [DataOper200 getCurriculumDetailWebUrlWithCurriculumId:self.model.ids subscribeId:self.model.subscribeId type:1 resultBlock:^(NSString *webUrl, NSDictionary *result) {
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
