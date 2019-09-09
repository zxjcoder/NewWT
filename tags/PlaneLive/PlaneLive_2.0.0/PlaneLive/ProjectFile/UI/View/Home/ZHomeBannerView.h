//
//  ZHomeBannerView.h
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "ModelEntity.h"

@interface ZHomeBannerView : ZBaseTVC

///广告点击事件
@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

///设置内容到第一页
-(void)setContentOffsetFrist;

///获取高度
-(CGFloat)getViewHeight;

@end
