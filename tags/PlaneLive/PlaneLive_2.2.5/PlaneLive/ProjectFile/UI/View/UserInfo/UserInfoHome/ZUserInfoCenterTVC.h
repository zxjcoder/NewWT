//
//  ZUserInfoCenterTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoCenterTVC : ZBaseTVC

///子项点击事件
@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoCenterItemType type);

///设置是否审核状态
-(void)setIsAuditStatus:(BOOL)status;

@end
