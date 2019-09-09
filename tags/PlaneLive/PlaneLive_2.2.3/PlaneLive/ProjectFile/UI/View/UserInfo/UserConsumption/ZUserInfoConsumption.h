//
//  ZUserInfoConsumption.h
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserInfoConsumption : ZView

///已购买顶部刷新
@property (copy, nonatomic) void(^onRefreshPayHeader)();
///已充值顶部刷新
@property (copy, nonatomic) void(^onRefreshRechargeHeader)();
///打赏
@property (copy, nonatomic) void(^onRefreshRewardHeader)();

///已购买刷新
@property (copy, nonatomic) void(^onBackgroundPayClick)(ZBackgroundState state);
///已充值刷新
@property (copy, nonatomic) void(^onBackgroundRechargeClick)(ZBackgroundState state);
///打赏刷新
@property (copy, nonatomic) void(^onBackgroundRewardClick)(ZBackgroundState state);

///已购买底部刷新
@property (copy, nonatomic) void(^onRefreshPayFooter)();
///已充值底部刷新
@property (copy, nonatomic) void(^onRefreshRechargeFooter)();
///打赏底部刷新
@property (copy, nonatomic) void(^onRefreshRewardFooter)();

///设置已购买背景状态
-(void)setPayBackgroundViewWithState:(ZBackgroundState)backState;
///设置已充值背景状态
-(void)setRechargeBackgroundViewWithState:(ZBackgroundState)backState;
///设置打赏背景状态
-(void)setRewardBackgroundViewWithState:(ZBackgroundState)backState;

///设置已购买
-(void)setPayViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置已充值
-(void)setRechargeViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置打赏
-(void)setRewardViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///结束已购买顶部刷新
-(void)endRefreshPayHeader;
///结束已购买底部刷新
-(void)endRefreshPayFooter;

///结束已充值顶部刷新
-(void)endRefreshRechargeHeader;
///结束已充值底部刷新
-(void)endRefreshRechargeFooter;

///结束打赏顶部刷新
-(void)endRefreshRewardHeader;
///结束打赏底部刷新
-(void)endRefreshRewardFooter;

@end
