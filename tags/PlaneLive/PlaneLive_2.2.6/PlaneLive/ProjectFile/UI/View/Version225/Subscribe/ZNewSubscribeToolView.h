//
//  ZNewSubscribeToolView.h
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZNewSubscribeToolView : ZView

///初始化
-(instancetype)initWithPoint:(CGPoint)point;

/// 试读点击
@property (copy, nonatomic) void(^onProbationClick)();
/// 购买点击
@property (copy, nonatomic) void(^onSubscribeClick)();

///设置数据
-(void)setViewDataWithModel:(ModelSubscribe *)model;

///获取高度
+(CGFloat)getH;

@end
