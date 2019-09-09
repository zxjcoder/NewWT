//
//  ZPracticeContentViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/10/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeContentViewController.h"
#import "ZWebView.h"
#import "ZPictureViewerViewController.h"
#import "IDMPhotoBrowser.h"
#import "ZTaskCompleteView.h"

@interface ZPracticeContentViewController ()<ZWebViewDelegate>

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
    
    [self setTitle:self.modelP.title];
    
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
    OBJC_RELEASE(_modelP);
}

#pragma mark - PrivateMethod
///初始化控件
-(void)innerInit
{
    self.webView = [[ZWebView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.webView];
    
    [super innerInit];
    
    [self innerData];
}
///初始化数据
-(void)innerData
{
    NSURL *url =  [NSURL URLWithString:kApp_PracticeContentUrl(self.modelP.ids)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30]];
}

-(id)getWebView
{
    return self.webView.realWebView;
}
///更多分享
-(void)btnRightClick
{
    //添加统计事件
    [StatisticsManager event:kEvent_Practice_Detail_Share category:kCategory_Practice];
    
    //TODO:ZWW备注-分享-实务详情-文本
    ZWEAKSELF
    ZShareView *shareView = nil;
    shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypePractice)];
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
    NSString *title = self.modelP.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelP.share_content;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelP.speech_img];
    NSString *webUrl = kApp_PracticeContentUrl(self.modelP.ids);
    
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
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
    if ([request.URL.scheme isEqualToString:@"wtqimagepreview"]) {
        NSString *imageParam = [request.URL.absoluteString substringFromIndex:[@"wtqimagepreview:" length]];
        NSArray *imageArray = [imageParam componentsSeparatedByString:@"&"];
        if (self.modelP.arrImage != nil && self.modelP.arrImage.count > 0) {
            NSString *imageIndex = imageArray.firstObject;
            if ([imageIndex intValue] > 0) {
                NSMutableArray *imageUrls = [NSMutableArray new];
                for (NSDictionary *dicImage in self.modelP.arrImage) {
                    NSURL *url = [NSURL URLWithString:[dicImage objectForKey:@"url"]];
                    if (url) {
                        [imageUrls addObject:url];
                    }
                }
                ZPictureViewerViewController *browser = [[ZPictureViewerViewController alloc] initWithPhotos:[IDMPhoto photosWithURLs:imageUrls]];
                if ([imageIndex integerValue]-1 < self.modelP.arrImage.count) {
                    [browser setInitialPageIndex:[imageIndex integerValue]-1];
                }
                browser.progressTintColor       = MAINCOLOR;
                browser.displayCounterLabel     = NO;
                browser.displayActionButton = NO;
                [self presentViewController:browser animated:YES completion:nil];
            }
        } else {
            NSString *imageUrl = imageArray.lastObject;
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithURLs:@[imageUrl]]];
            browser.progressTintColor       = MAINCOLOR;
            [browser setDoneButtonImage:[UIImage imageNamed:@"btn_back1"]];
            [self presentViewController:browser animated:YES completion:nil];
        }
        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(ZWebView *)webView
{
    UIActivityIndicatorView *aiView = [webView viewWithTag:12122];
    if (aiView == nil) {
        aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    } else {
        [aiView stopAnimating];
        [aiView removeFromSuperview];
    }
    if (!aiView.isAnimating) {
        [aiView startAnimating];
    }
    [aiView setCenter:webView.center];
    [aiView setColor:MAINCOLOR];
    [aiView setTag:12122];
    
    [webView addSubview:aiView];
    [webView bringSubviewToFront:aiView];
}

-(void)webViewDidFinishLoad:(ZWebView *)webView
{
    ///设置实务模块字体大小
    if (self.modelP && self.modelP.ids.length > 0) {
        CGFloat fontSize = [[AppSetting getFontSize] floatValue];
        int fontRatio = fontSize/kFont_Set_Default_Size*100;
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%d%%'",fontRatio];
        [webView stringByEvaluatingJavaScriptFromString:jsString];
    }
    ///设置图片事件函数
    [webView stringByEvaluatingJavaScriptFromString:@"function htmlImageClick(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.id=i;img.onclick=function(){window.location.href='wtqimagepreview:'+this.id+'&'+this.src}}}"];
    ///执行图片点击事件
    [webView stringByEvaluatingJavaScriptFromString:@"htmlImageClick();"];
    
    UIActivityIndicatorView *aiView = [webView viewWithTag:12122];
    if (aiView != nil) {
        [aiView stopAnimating];
        [aiView removeFromSuperview];
    }
    [webView setNeedsDisplay];
}

-(void)webView:(ZWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIActivityIndicatorView *aiView = [webView viewWithTag:12122];
    if (aiView != nil) {
        [aiView stopAnimating];
        [aiView removeFromSuperview];
    }
    [webView setNeedsDisplay];
}


@end
