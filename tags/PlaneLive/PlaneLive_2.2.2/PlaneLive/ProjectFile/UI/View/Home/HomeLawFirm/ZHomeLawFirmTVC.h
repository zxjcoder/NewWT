//
//  ZHomeLawFirmTVC.h
//  PlaneLive
//
//  Created by Daniel on 11/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZHomeLawFirmTVC : ZBaseTVC

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)();
///律所点击事件
@property (copy, nonatomic) void(^onLawFirmClick)(ModelLawFirm *model);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

///获取高度
+(CGFloat)getViewHeight;

@end
