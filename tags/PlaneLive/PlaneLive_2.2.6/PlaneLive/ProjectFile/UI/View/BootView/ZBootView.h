//
//  ZBootView.h
//  PlaneLive
//
//  Created by Daniel on 14/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZBootView : ZView

///开始
@property (copy, nonatomic) void(^onStartClick)();
///跳过
@property (copy, nonatomic) void(^onSkipClick)();
///显示
-(void)show;

@end
