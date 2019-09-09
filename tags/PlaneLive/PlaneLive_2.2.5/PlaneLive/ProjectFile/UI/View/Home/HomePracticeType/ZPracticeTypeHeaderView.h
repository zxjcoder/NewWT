//
//  ZPracticeTypeHeaderView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeTypeHeaderView : ZView

///排序点击事件
@property (copy, nonatomic) void(^onSortClick)(ZPracticeTypeSort sort);
///分类点击事件
@property (copy, nonatomic) void(^onTypeClick)(ModelPracticeType *model);
///设置数据源
-(CGFloat)setViewDataWithArray:(NSArray *)array;
-(void)setSortButtonTag:(ZPracticeTypeSort)tag;
-(ZPracticeTypeSort)getSortValue;

+(CGFloat)getH;

@end
