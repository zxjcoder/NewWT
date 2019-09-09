//
//  ZFeekBackOtherTypeTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 其他反馈方式
@interface ZFeekBackOtherTypeTVC : ZBaseTVC

///微信客服
@property (copy, nonatomic) void(^onWeChatClick)();
///摇一摇反馈
@property (copy, nonatomic) void(^onShakeClick)();

@end
