//
//  ZUserInfoCenterTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoCenterTVC : ZBaseTVC

@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoCenterItemType type);

@end
