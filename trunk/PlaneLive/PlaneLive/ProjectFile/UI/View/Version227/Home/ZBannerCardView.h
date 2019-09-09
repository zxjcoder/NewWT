//
//  ZBannerCardView.h
//  PlaneLive
//
//  Created by WT on 13/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZBannerCardView : ZView

/// 广告区域点击
@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);

-(void)setViewData:(NSArray*)array;
/// 获取View高度
+(CGFloat)getViewH;

@end
