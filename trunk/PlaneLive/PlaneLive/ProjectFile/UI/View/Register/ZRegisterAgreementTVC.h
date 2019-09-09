//
//  ZRegisterAgreementTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZRegisterAgreementTVC : ZBaseTVC

///使用协议
@property (copy, nonatomic) void(^onAgreementClick)();

///获取勾选状态
-(BOOL)getCheckState;

///设置背景颜色
-(void)setCellBackGroundColor:(UIColor *)color;

@end
