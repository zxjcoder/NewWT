//
//  ZTabBarButton.h
//  PlaneLive
//
//  Created by Daniel on 27/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTabBarButton : UIButton

@property (nonatomic, strong) UITabBarItem *item;

@property (assign, nonatomic) BOOL isMiddle;

@end
