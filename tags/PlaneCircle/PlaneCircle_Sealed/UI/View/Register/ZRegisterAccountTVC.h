//
//  ZRegisterAccountTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZRegisterAccountTVC : ZBaseTVC

///获取验证码
@property (copy ,nonatomic) void(^onSendCodeClick)();

///验证码发送成功
-(void)setSendSuccess;
///验证码发送失败
-(void)setSendError;

///设置帐号
-(void)setAccountText:(NSString *)text;
///获取帐号
-(NSString *)getAccountText;

///获取验证码
-(NSString *)getCodeText;

///设置密码
-(void)setPasswordText:(NSString *)text;
///获取密码
-(NSString *)getPasswordText;

@end
