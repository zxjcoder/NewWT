//
//  ZLoginButtonTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///登录按钮区域CELL
@interface ZLoginButtonTVC : ZBaseTVC

///忘记密码
@property (copy, nonatomic) void(^onForgotPwdClick)();
///注册
@property (copy, nonatomic) void(^onRegisterClick)();
///登录
@property (copy, nonatomic) void(^onLoginClick)();

@end
