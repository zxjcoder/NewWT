//
//  ZPayCartItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZPayCartItemTVC : ZBaseTVC

///选中点击
@property (copy, nonatomic) void(^onCheckedClick)(BOOL check, NSInteger row);

///设置选中状态
-(void)setCheckedStatus:(BOOL)isCheck;

///获取数据源
-(ModelPayCart *)getCellModel;

@end
