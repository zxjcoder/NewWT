//
//  ZWebViewProgress.h
//
//  Created by Daniel on 15/11/30.
//  Copyright © 2015年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef Z_weak
#if __has_feature(objc_arc_weak)
#define Z_weak weak
#else
#define Z_weak unsafe_unretained
#endif

extern const float ZInitialProgressValue;
extern const float ZInteractiveProgressValue;
extern const float ZFinalProgressValue;

typedef void (^ZWebViewProgressBlock)(float progress);
@protocol ZWebViewProgressDelegate;

@interface ZWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, Z_weak) id<ZWebViewProgressDelegate>progressDelegate;
@property (nonatomic, Z_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) ZWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;

@end

@protocol ZWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(ZWebViewProgress *)webViewProgress updateProgress:(float)progress;

@end

