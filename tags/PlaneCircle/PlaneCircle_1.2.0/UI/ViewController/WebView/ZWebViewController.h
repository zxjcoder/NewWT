//
//  ZWebViewController.h
//  Product
//
//  Created by Daniel on 15/8/5.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZWebViewController : ZBaseViewController

///链接地址
@property (strong, nonatomic) NSString *webUrl;

///获取当前的WebView
-(id)getWebView;

@end
