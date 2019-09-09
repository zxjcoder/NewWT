//
//  ZFoundCardView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/10.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

#define kZFoundCardViewDefaultWidth 223
#define kZFoundCardViewDefaultHeight 255

@interface ZFoundCardView : ZView

@property (copy, nonatomic) void(^onPracticeTypeClick)(ModelPracticeType *model);
///设置数据对象
-(void)setViewDataWithModel:(ModelPracticeType *)model;
///设置坐标
-(void)setViewChangeFrame:(CGRect)frame;

@end
