//
//  ZTabBarView.h
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTabBarView : UIView

///子项点击事件
@property (copy, nonatomic) void(^onTabBarItemClick)(NSInteger index);

// items:保存每一个按钮对应tabBarItem模型
@property (nonatomic, strong) NSArray *items;

@end
