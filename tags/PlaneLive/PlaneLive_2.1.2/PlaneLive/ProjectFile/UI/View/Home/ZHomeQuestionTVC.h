//
//  ZHomeQuestionTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZHomeQuestionTVC : ZBaseTVC

///查看全部点击事件
@property (copy, nonatomic) void(^onAllQuestionClick)();

///行高度改变
@property (copy, nonatomic) void(^onChangeRowHeight)(CGFloat rowH);

///问题点击事件
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBoutique *model);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

@end
