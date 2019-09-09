//
//  AccountBalanceFooterTVC.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface AccountBalanceFooterTVC : ZBaseTVC

/// 充值指南链接点击事件
@property (copy, nonatomic) void(^onLinkClick)();
@property (copy, nonatomic) void(^onWechatLinkClick)();

@end
