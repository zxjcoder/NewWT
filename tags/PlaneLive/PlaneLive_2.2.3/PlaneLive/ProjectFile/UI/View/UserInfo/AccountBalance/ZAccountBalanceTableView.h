//
//  ZAccountBalanceTableView.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZAccountBalanceTableView : ZBaseTableView

///充值点击事件
@property (copy, nonatomic) void(^onRechargeClick)(NSString *money);

///设置账户余额
-(void)setBalanceValue:(NSString *)val;

/// 充值指南链接点击事件
@property (copy, nonatomic) void(^onLinkClick)();

@end
