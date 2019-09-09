//
//  ZAccountBalanceAlertView.h
//  PlaneLive
//
//  Created by Daniel on 13/06/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZAccountBalanceAlertView : UIView

///本设备充值
@property (copy, nonatomic) void(^onSubmitClick)();
///登录
@property (copy, nonatomic) void(^onLoginClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;


@end
