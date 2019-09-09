//
//  ZAccountPhoneTVC.h
//  PlaneLive
//
//  Created by Daniel on 30/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAccountPhoneTVC : ZBaseTVC

///设置帐号
-(void)setAccountText:(NSString *)text;
///获取帐号
-(NSString *)getAccountText;

-(void)setTextFieldEnabled:(BOOL)isEnabled;

@end
