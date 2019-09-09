//
//  ZCodeTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZCodeTVC : ZBaseTVC

///发送验证码
@property (copy, nonatomic) void(^onSendCodeClick)();

///设置手机号
-(void)setAccount:(NSString*)account;

///设置发送成功
-(void)setSendSuccess;

///获取验证码
-(NSString *)getCode;

@end
