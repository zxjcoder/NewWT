//
//  ZAccountCodeTVC.h
//  PlaneLive
//
//  Created by Daniel on 30/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAccountCodeTVC : ZBaseTVC

///获取验证码
@property (copy ,nonatomic) void(^onSendCodeClick)();
///获取验证码
-(NSString *)getCodeText;
///验证码发送成功
-(void)setSendSuccess;
///验证码发送失败
-(void)setSendError;

@end
