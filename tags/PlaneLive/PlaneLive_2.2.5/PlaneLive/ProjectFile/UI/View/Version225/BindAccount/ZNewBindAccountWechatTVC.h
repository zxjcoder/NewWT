//
//  ZNewBindAccountWechatTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZNewBindAccountWechatTVC : ZBaseTVC

///绑定解绑按钮
@property (copy ,nonatomic) void(^onBindClick)(ModelUser *model);

@end
