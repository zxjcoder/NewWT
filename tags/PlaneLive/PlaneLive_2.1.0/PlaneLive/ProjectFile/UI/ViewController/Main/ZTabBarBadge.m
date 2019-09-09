//
//  ZTabBarBadge.m
//  PlaneLive
//
//  Created by Daniel on 27/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarBadge.h"

@implementation ZTabBarBadge

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = NO;
        
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_main_badge"] forState:UIControlStateNormal];
        
        // 设置字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self sizeToFit];
        
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    
    // 判断badgeValue是否有内容
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) { // 没有内容或者空字符串,等于0
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    CGSize size = [badgeValue boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}
                                           context:nil].size;
    // 文字的尺寸大于控件的宽度
    if (size.width > self.width) {
        [self setImage:[UIImage imageNamed:@"tabbar_new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
    
}

@end
