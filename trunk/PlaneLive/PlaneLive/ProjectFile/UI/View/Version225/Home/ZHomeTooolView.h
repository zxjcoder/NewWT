//
//  ZHomeTooolView.h
//  PlaneLive
//
//  Created by Daniel on 2016/12/23.
//  Copyright © 2016年 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHomeTooolView : UIView

///子项点击事件 1 微课 2 系列课 3 热门培训 4 专业机构
@property (copy, nonatomic) void(^onItemClick)(NSInteger index);

@end
