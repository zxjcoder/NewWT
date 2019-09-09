//
//  ZTabBarBadge.h
//  PlaneLive
//
//  Created by Daniel on 27/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
