//
//  ZWebView.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWebView;
@protocol ZWebViewDelegate <NSObject>
@optional

- (void)webViewDidStartLoad:(ZWebView *)webView;
- (void)webViewDidFinishLoad:(ZWebView *)webView;
- (void)webView:(ZWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)webView:(ZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

///自动根据系统版本切换UIWebView||WKWebView
@interface ZWebView : UIView

///是否只使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame isUIWebView:(BOOL)isUIWebView;

@property(weak,nonatomic)id<ZWebViewDelegate> delegate;

///内部使用的webView
@property (nonatomic, readonly) id realWebView;
///是否正在使用 UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;
///预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest *originRequest;

///back 层数
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

///---- UI 或者 WK 的API
@property (nonatomic, readonly) UIScrollView *scrollView;

- (id)loadRequest:(NSURLRequest *)request;
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSURLRequest *currentRequest;
@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (id)goBack;
- (id)goForward;
- (id)reload;
- (id)reloadFromOrigin;
- (void)stopLoading;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
///不建议使用这个办法  因为会在内部等待webView 的执行结果
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString;
///是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

@end
