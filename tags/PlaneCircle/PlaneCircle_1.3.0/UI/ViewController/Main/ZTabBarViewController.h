//
//  ZTabBarViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

///显示小红点
- (void)showBadgeOnItemIndex:(int)index count:(int)count;
///隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index;

@end

@interface ZTabBarViewController : UITabBarController

@end
