//
//  ZUserInfoCenterView.h
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserInfoCenterView : ZView

///子项点击事件
@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoCenterItemType type);

///设置是否审核状态
-(void)setIsAuditStatus:(BOOL)status;

-(void)setViewDataWithModel:(ModelUser *)model;

+(CGFloat)getH;

@end
