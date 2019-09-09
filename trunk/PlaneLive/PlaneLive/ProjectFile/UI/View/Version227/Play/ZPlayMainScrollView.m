//
//  ZPlayMainScrollView.m
//  PlaneLive
//
//  Created by WT on 19/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlayMainScrollView.h"

@implementation ZPlayMainScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    [super touchesShouldCancelInContentView:view];
    return YES;
}

@end
