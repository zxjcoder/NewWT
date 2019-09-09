//
//  ZTabBarBadge.h
//  PlaneCircle
//
//  Created by Daniel on 9/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITabBar (badge)

///显示小红点
- (void)showBadgeOnItemIndex:(int)index count:(int)count;
///隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index;

@end
