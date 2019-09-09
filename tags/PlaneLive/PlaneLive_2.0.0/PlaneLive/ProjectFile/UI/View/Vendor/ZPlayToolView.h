//
//  ZPlayToolView.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayToolView : ZView

///初始化
-(id)initWithPlayTitle:(NSString *)title;

///子项按钮事件
@property (copy, nonatomic) void(^onBalanceClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
