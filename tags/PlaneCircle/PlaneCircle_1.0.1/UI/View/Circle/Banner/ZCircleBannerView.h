//
//  ZCircleBannerView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

#define kZBannerViewHeight 135*(APP_FRAME_WIDTH/320)
#define kZBannerViewIPadHeight 195

@interface ZCircleBannerView : UIView

///广告点击事件
@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

///设置内容到第一页
-(void)setContentOffsetFrist;

@end
