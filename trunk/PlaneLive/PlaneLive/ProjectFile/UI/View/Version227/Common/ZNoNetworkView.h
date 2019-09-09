//
//  ZNoNetworkView.h
//  PlaneLive
//
//  Created by WT on 13/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZNoNetworkView : ZView

/// 点击去设置网络
@property (copy, nonatomic) void(^onSettingClick)();

/// 获取View高度
+(CGFloat)getViewH;

@end
