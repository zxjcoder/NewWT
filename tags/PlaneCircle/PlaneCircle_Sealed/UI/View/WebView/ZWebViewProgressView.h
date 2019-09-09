//
//  ZWebViewProgressView.h
//  Project
//
//  Created by Daniel on 15/11/30.
//  Copyright © 2015年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@import WebKit;

@protocol ZWebViewProgressViewProtocol <NSObject>
@required
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end


@interface ZWebViewProgressView : UIView<ZWebViewProgressViewProtocol>

@property (nonatomic) float progress;

@property (readonly, nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration;// default 0.5
@property (nonatomic) NSTimeInterval fadeAnimationDuration;// default 0.27
/**
 *  进度条的颜色
 */
@property (copy, nonatomic) UIColor *progressBarColor;

/**
 *  使用WKWebKit
 *
 *  @param webView WKWebView对象
 */
- (void)useWkWebView:(WKWebView *)webView;

@end

