//
//  ZWebViewController.m
//  Product
//
//  Created by Daniel on 15/8/5.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZWebViewController.h"
#import "ZWebView.h"

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

- (void)dealloc
{
    _webView.delegate = nil;
    OBJC_RELEASE(_webView);
    OBJC_RELEASE(_webUrl);
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    CGRect webFrame = VIEW_ITEM_FRAME;
    webFrame.size.height -= self.bottomHeight;
    
    self.webView = [[ZWebView alloc] initWithFrame:webFrame];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.webView];
    
    [self innerData];
}

-(void)innerData
{
    GBLog(@"webView URL: %@",self.webUrl);
    
    NSURL *url =  [NSURL URLWithString:self.webUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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
