//
//  ZWebViewProgressBar.h
//  Project
//
//  Created by Daniel on 15/11/30.
//  Copyright © 2015年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWebView.h"
#import "ZWebViewProgressView.h"

@interface ZWebViewProgressBar : NSObject<ZWebViewDelegate>

@property (readonly, nonatomic) float progress;
/**
 *  进度条
 */
@property (strong, nonatomic) UIView <ZWebViewProgressViewProtocol> *progressView;
/**
 *  转发WebViewDelegate
 */
@property (weak, nonatomic) id <ZWebViewDelegate> webViewProxy;


// 外部使用时，不要调用该方法
- (BOOL)checkIfRPCURL:(NSURLRequest *)request;

@end
