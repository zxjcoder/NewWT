//
//  ZWebViewController.m
//  Product
//
//  Created by Daniel on 15/8/5.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZWebViewController.h"
#import "ZWebView.h"
#import "ZPictureViewerView.h"

@interface ZWebViewController ()<ZWebViewDelegate>

@property (strong, nonatomic) ZWebView *webView;

@end

@implementation ZWebViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
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
    OBJC_RELEASE(_webUrl);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    CGRect webFrame = VIEW_ITEM_FRAME;
    
    self.webView = [[ZWebView alloc] initWithFrame:webFrame];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.webView];
}

-(void)innerData
{
    NSURL *url =  [NSURL URLWithString:self.webUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    GBLog(@"WebViewController_Url: %@", self.webUrl);
}

-(id)getWebView
{
    return self.webView.realWebView;
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
