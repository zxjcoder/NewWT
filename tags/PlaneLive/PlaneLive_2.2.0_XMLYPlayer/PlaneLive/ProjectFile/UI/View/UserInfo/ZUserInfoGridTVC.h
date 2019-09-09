//
//  ZUserInfoGridTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoGridTVC : ZBaseTVC

///子项点击事件
@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoGridCVCType type);

@end
