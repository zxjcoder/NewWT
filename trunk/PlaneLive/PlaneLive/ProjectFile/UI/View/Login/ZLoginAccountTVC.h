//
//  ZLoginAccountTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///登录帐号CELL
@interface ZLoginAccountTVC : ZBaseTVC

///账号开始编辑
@property (copy ,nonatomic) void(^onAccountBeginEditText)();
///密码开始编辑
@property (copy ,nonatomic) void(^onPasswordBeginEditText)();

-(void)setAccountText:(NSString *)text;
-(NSString *)getAccountText;

-(void)setPasswordText:(NSString *)text;
-(NSString *)getPasswordText;

@end
