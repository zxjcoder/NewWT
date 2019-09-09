//
//  ZNewUserEditBaseTVC.h
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "ZTextField.h"

@interface ZNewUserEditBaseTVC : ZBaseTVC

@property (strong, nonatomic) ZLabel *lbTitle;

@property (retain, nonatomic) ZTextField *textField;

@property (copy ,nonatomic) void(^onBeginEdit)();

-(void)setLineHidden;
-(void)setCellDataWithText:(NSString *)text;
-(NSString *)getText;

@end
