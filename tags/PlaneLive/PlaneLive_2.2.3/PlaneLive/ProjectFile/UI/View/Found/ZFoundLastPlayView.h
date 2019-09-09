//
//  ZFoundLastPlayView.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"
#import "ModelAudio.h"

#define kZFoundLastPlayViewHeight 40

@interface ZFoundLastPlayView : ZView

-(instancetype)initWithPoint:(CGPoint)point;

@property (copy, nonatomic) void(^onLastPlayViewClick)(ModelAudio *model);

///设置数据源
-(void)setViewDataWithModel:(ModelAudio *)model;

///设置按钮是否动画起来
-(void)setPlayButtonIsAnimation:(BOOL)isAnimation;

@end
