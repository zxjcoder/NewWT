//
//  ZWebViewController.m
//  Product
//
//  Created by Daniel on 15/8/5.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZWebViewController.h"
#import "ZWebView.h"
#import "ZBackgroundView.h"

@interface ZWebViewController ()<ZWebViewDelegate>

@property (strong, nonatomic) ZWebView *webView;

@property (strong, nonatomic) ZBackgroundView *viewBackground;

@end

@implementation ZWebViewController

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
    
    [self innerData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.webView stopLoading];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self setViewNil];
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
    OBJC_RELEASE(_viewBackground);
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
    
    [super innerInit];
}

-(void)innerData
{
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
        [aiView setColor:MAINCOLOR];
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
    if (!self.title) {
        [self setTitle:self.webView.title];
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
