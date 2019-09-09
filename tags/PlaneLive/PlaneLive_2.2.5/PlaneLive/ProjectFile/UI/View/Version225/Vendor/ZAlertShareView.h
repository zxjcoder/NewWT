//
//  ZAlertShareView.h
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

///分享弹框
@interface ZAlertShareView : ZView

///子项按钮事件
@property (copy, nonatomic) void(^onItemClick)(ZShareType type);

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
