//
//  ZSettingButtonTVC.h
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZSettingButtonTVC : ZBaseTVC

///按钮点击
@property (copy ,nonatomic) void(^onSubmitClick)();

///设置按钮文字
-(void)setButtonText:(NSString *)text;

///设置背景颜色
-(void)setCellBackGroundColor:(UIColor *)color;

@end
