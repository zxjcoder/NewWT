//
//  ZFeekBackListItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 反馈记录列表Cell
@interface ZFeekBackListItemTVC : ZBaseTVC

///图片点击
@property (copy, nonatomic) void(^onImageItemClick)(NSArray *images, NSInteger index);

@end
