//
//  ZBannerCardItemView.h
//  PlaneLive
//
//  Created by WT on 13/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZBannerCardItemView : ZView

/// 设置数据源
-(void)setViewDataWithModel:(ModelBanner *)model;

+(CGFloat)getW;
+(CGFloat)getH;

@end
