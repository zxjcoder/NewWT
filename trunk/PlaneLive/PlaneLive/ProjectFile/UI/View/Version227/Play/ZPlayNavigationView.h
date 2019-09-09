//
//  ZPlayNavigationView.h
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayNavigationView : ZView

@property (copy, nonatomic) void(^onCloseViewEvent)();
@property (copy, nonatomic) void(^onShareViewEvent)();

-(void)setPageChange:(NSInteger)index total:(NSInteger)total;

/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled;

+(CGFloat)getH;

@end
