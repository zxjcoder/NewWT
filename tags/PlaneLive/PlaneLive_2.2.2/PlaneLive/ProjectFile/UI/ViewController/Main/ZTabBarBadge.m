//
//  ZTabBarBadge.m
//  PlaneLive
//
//  Created by Daniel on 27/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarBadge.h"

//tabbar的数量 如果是5个设置为5.0
#define kTabbarItemNums 5.0

@implementation UITabBar (badge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index {
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //圆形大小为8
    CGFloat badgaSize = 8;
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = badgaSize/2;//圆形
    badgeView.backgroundColor = MAINCOLOR;//[UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.6) / kTabbarItemNums;
    if (IsIPadDevice) {
        percentX =  (index + 0.85) / kTabbarItemNums;
    }
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, badgaSize, badgaSize);
    
    [self addSubview:badgeView];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index {
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index {
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
