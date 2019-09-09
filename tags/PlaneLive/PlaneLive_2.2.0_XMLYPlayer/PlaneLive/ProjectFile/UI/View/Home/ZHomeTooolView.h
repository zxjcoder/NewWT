//
//  ZHomeTooolView.h
//  PlaneLive
//
//  Created by Daniel on 2016/12/23.
//  Copyright © 2016年 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHomeTooolView : UIView

///子项点击事件
@property (copy, nonatomic) void(^onItemClick)(NSInteger index);

@end
