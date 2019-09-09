//
//  ZUserInfoConsumptionItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoConsumptionItemTVC : ZBaseTVC

///已充值
-(CGFloat)setCellDataWithRechargeRecord:(ModelRechargeRecord *)model;
///已购买
-(CGFloat)setCellDataWithSubscribePlay:(ModelSubscribePlay *)model;

@end
