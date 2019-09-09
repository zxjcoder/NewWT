//
//  ZNewHomeRecommendView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 每日推荐
@interface ZNewHomeRecommendView : ZView

///实务点击
@property (copy, nonatomic) void(^onPracticeClick)(ModelPractice *model);
///订阅点击
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

-(CGFloat)setViewData:(NSArray *)array;

@end
