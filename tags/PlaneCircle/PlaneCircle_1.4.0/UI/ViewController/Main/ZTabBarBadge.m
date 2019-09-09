//
//  ZTabBarBadge.m
//  PlaneCircle
//
//  Created by Daniel on 9/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarBadge.h"

//tabbar的数量 如果是5个设置为5.0
#define kTabbarItemNums 4.0

@implementation UITabBar (badge)

///显示小红点
- (void)showBadgeOnItemIndex:(int)index count:(int)count
{
    //移除之前的小红点
    //[self removeBadgeOnItemIndex:index];
    
    CGFloat size = 15;
    //新建小红点
    UILabel *badgeView = [self viewWithTag:888 + index];
    if (badgeView == nil) {
        badgeView =  [[UILabel alloc] init];
    }
    badgeView.tag = 888 + index;
    badgeView.layer.masksToBounds = YES;
    badgeView.layer.cornerRadius = size/2;
    badgeView.backgroundColor = MAINCOLOR;
    badgeView.text = [NSString stringWithFormat:@"%d",(count>99?99:count)];
    badgeView.textColor = WHITECOLOR;
    badgeView.font = [ZFont systemFontOfSize:8];
    [badgeView setTextAlignment:(NSTextAlignmentCenter)];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    if (IsIPadDevice) {
        float percentX = (index + 0.58) / kTabbarItemNums;
        CGFloat space = (tabFrame.size.width-440)/2;
        CGFloat x = space+ceilf(percentX * 440);
        CGFloat y = ceilf(0.05 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, size, size);
        [self addSubview:badgeView];
    } else {
        float percentX = (index + 0.58) / kTabbarItemNums;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.05 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, size, size);
        [self addSubview:badgeView];
    }
}
///隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index
{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
///移除小红点
- (void)removeBadgeOnItemIndex:(int)index
{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
