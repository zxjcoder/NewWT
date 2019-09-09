//
//  ZPurchaseBindAccountTVC.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZPurchaseBindAccountTVC : ZBaseTVC

///绑定事件点击
@property (copy, nonatomic) void(^onBindEvent)();

@end
