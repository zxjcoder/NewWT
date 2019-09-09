//
//  ZFoundCardFlowView.h
//  PlaneLive
//
//  Created by Daniel on 01/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFoundCardItemView.h"

@interface ZFoundCardFlowView : UIView

///开始播放
@property (copy, nonatomic) void(^onStartPlayEvent)(ModelPracticeType *type);
///索引改变
@property (copy, nonatomic) void(^onIndexChange)(int maxCount, int index);

-(void)setViewData:(NSArray*)array;

@end
