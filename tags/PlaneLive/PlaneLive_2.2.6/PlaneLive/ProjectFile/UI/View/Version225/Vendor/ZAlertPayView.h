//
//  ZAlertPayView.h
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZAlertPayView : ZView

///初始化 - 购买
-(id)initWithTitle:(NSString *)title;

///初始化 - 打赏
-(id)initWithTitle:(NSString *)title reward:(NSString *)reward;

///余额支付
@property (copy, nonatomic) void(^onBalanceClick)();
///支付点击
@property (copy, nonatomic) void(^onItemClick)(WTPayWayType payType);

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
