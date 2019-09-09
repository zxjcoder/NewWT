//
//  ZPracticePayFooterView.h
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"
#import "ZButton.h"

/// 微课购买底部工具栏
@interface ZPracticePayFooterView : ZView

/// 加入购物车
@property (strong, nonatomic) ZButton *btnJoin;
///加入购物车
@property (copy, nonatomic) void(^onJoinCartClick)();
///购买
@property (copy, nonatomic) void(^onBuyClick)();

/// 设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;

+(CGFloat)getH;

@end
