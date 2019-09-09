//
//  ZPracticeContentViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/10/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeContentViewController.h"
#import "ZWebView.h"
#import "ZPictureViewerView.h"
#import "ZPracticeDetailNavigationView.h"

@interface ZPracticeContentViewController ()<ZWebViewDelegate>

///导航
@property (strong, nonatomic) ZPracticeDetailNavigationView *viewNavigation;
///Web对象
@property (strong, nonatomic) ZWebView *webView;
///数据源
@property (strong, nonatomic) ModelPractice *modelP;

@end

@implementation ZPracticeContentViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPreRefreshData:) name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNextRefreshData:) name:ZPlayNextNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithShare];
    
    [self.viewNavigation setViewTitle:self.modelP.title];
    
    [self innerData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.viewNavigation setStopScroll];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayNextNotification object:nil];
    _webView.delegate = nil;
    OBJC_RELEASE(_webView);
    OBJC_RELEASE(_modelP);
}

#pragma mark - PrivateMethod
///初始化控件
-(void)innerInit
{
    self.viewNavigation = [[ZPracticeDetailNavigationView alloc] initWithScrollFrame:VIEW_NAVV_FRAME];
    [self.viewNavigation setViewBGAlpha:1.0f];
    [self.view addSubview:self.viewNavigation];
    //TODO:ZWW开启AppConfig配置
    ModelAppConfig *modelAC = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION];
    if (modelAC && modelAC.appStatus == 1) {
        [self.viewNavigation setHiddenMore:NO];
    } else {
        [self.viewNavigation setHiddenMore:YES];
    }
    ZWEAKSELF
    /////////////////导航
    [self.viewNavigation setOnBackClick:^{
        [weakSelf btnBackClick];
    }];
    [self.viewNavigation setOnMoreClick:^{
        [weakSelf btnRightClick];
    }];
    [self.viewNavigation setOnViewClick:^{
        [weakSelf.view endEditing:YES];
    }];
    
    CGRect webFrame = VIEW_ITEM_FRAME;
    webFrame.size.height -= APP_PLAY_HEIGHT;
    
    self.webView = [[ZWebView alloc] initWithFrame:webFrame];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.webView];
}
///初始化数据
-(void)innerData
{
    NSURL *url =  [NSURL URLWithString:kApp_PracticeContentUrl(self.modelP.ids)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    GBLog(@"WebViewController_Url: %@", url.absoluteString);
}
///返回按钮事件
-(void)btnBackClick
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayNextNotification object:nil];
    
    [self.viewNavigation setStopScroll];
    
    [self.navigationController popViewControllerAnimated:YES];
}
///上一页获取数据
-(void)setPreRefreshData:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    ModelPractice *modelN = [dicParam objectForKey:@"model"];
    
    [self setModelP:modelN];
    
    [self.viewNavigation setViewTitle:modelN.title];
    
    [self innerData];
}
///下一页获取数据
-(void)setNextRefreshData:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    ModelPractice *modelN = [dicParam objectForKey:@"model"];
    
    [self setModelP:modelN];
    
    [self.viewNavigation setViewTitle:modelN.title];
    
    [self innerData];
}

-(id)getWebView
{
    return self.webView.realWebView;
}
///更多分享
-(void)btnRightClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Share];
    
    //TODO:ZWW备注-分享-实务详情-文本
    ZWEAKSELF
    ZShareView *shareView = nil;
    shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypePractice)];
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                [MobClick event:kEvent_Practice_Detail_Share_WeChat];
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                [MobClick event:kEvent_Practice_Detail_Share_WeChatCircle];
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [MobClick event:kEvent_Practice_Detail_Share_QQ];
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [MobClick event:kEvent_Practice_Detail_Share_QZone];
                [weakSelf btnQZoneClick];
                break;
            case ZShareTypeYouDao:
                [MobClick event:kEvent_Practice_Detail_Share_YingXiang];
                [weakSelf btnYouDaoClick];
                break;
            case ZShareTypeYinXiang:
                [MobClick event:kEvent_Practice_Detail_Share_YouDao];
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
    NSString *title = self.modelP.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelP.share_content;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = self.modelP.speech_img;
    NSString *webUrl = kShare_VoiceUrl(self.modelP.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (isSuccess) {
            [ZProgressHUD showSuccess:kCShareTitleSuccess];
        }
    }];
}
///设置数据模型
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [super setViewDataWithModel:model];
    
    [self setModelP:model];
}

#pragma mark - ZWebViewDelegate

-(BOOL)webView:(ZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* imgUrl = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        ZPictureViewerView *pvView = [[ZPictureViewerView alloc] init];
        [pvView setViewPictureUrlWithImageUrl:[NSURL URLWithString:imgUrl] defaultImage:nil defaultSize:CGSizeZero];
        [pvView show];
        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(ZWebView *)webView
{
    CGFloat width = webView.frame.size.width;
    CGFloat height = webView.frame.size.height;
    CGFloat aiSize = 30;
    UIActivityIndicatorView *aiView = [webView viewWithTag:111];
    if (!aiView) {
        aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(width/2-aiSize/2, height/2-aiSize-20, aiSize, aiSize)];
        [aiView setColor:RGBCOLOR(253, 116, 34)];
        [aiView setTag:111];
        [webView addSubview:aiView];
        [aiView startAnimating];
    }
}

-(void)webViewDidFinishLoad:(ZWebView *)webView
{
    UIActivityIndicatorView *aiView = [webView viewWithTag:111];
    if (aiView) {
        [aiView stopAnimating];
        [aiView removeFromSuperview];
        OBJC_RELEASE(aiView);
    }
    ///设置实务模块字体大小
    if (self.modelP && self.modelP.ids.length > 0) {
        CGFloat fontSize = [[AppSetting getFontSize] floatValue];
        int fontRatio = fontSize/kFont_Set_Default_Size*100;
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%d%%'",fontRatio];
        [webView stringByEvaluatingJavaScriptFromString:jsString];
    }
    ///设置图片事件函数
    [webView stringByEvaluatingJavaScriptFromString:@"function htmlImageClick(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    ///执行图片点击事件
    [webView stringByEvaluatingJavaScriptFromString:@"htmlImageClick();"];
}

-(void)webView:(ZWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIActivityIndicatorView *aiView = [webView viewWithTag:111];
    if (aiView) {
        [aiView stopAnimating];
        [aiView removeFromSuperview];
        OBJC_RELEASE(aiView);
    }
}


@end
