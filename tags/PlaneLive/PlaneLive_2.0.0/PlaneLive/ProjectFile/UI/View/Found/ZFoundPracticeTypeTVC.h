//
//  ZFoundPracticeTypeTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZFoundPracticeTypeTVC : ZBaseTVC

///实务分类点击
@property (copy, nonatomic) void(^onPracticeTypeClick)(ModelPracticeType *model);

///设置数据对象
-(CGFloat)setCellDataWithArray:(NSArray *)array;

@end
