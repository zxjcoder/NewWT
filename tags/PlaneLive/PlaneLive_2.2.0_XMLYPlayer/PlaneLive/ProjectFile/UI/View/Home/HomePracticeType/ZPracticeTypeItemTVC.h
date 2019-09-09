//
//  ZPracticeTypeItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZPracticeTypeItemTVC : ZBaseTVC

///排序点击事件
@property (copy, nonatomic) void(^onSortClick)(int sort);
///分类点击事件
@property (copy, nonatomic) void(^onTypeClick)(ModelPracticeType *model);
///设置数据源
-(void)setViewDataWithArray:(NSArray *)array;
-(void)setSortButtonText:(NSString *)text;
-(void)setSortButtonTag:(NSInteger)tag;

@end
