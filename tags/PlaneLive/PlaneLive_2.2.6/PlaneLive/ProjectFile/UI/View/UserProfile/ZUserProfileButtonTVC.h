//
//  ZUserProfileButtonTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserProfileButtonTVC : ZBaseTVC

///功能按钮事件
@property (copy ,nonatomic) void(^onOperClick)();
///设置是否隐藏
-(void)setButtonHidden:(BOOL)hidden;
///设置按钮状态
-(void)setButtonState:(BOOL)isAtting;

@end
