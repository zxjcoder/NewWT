//
//  ZHomeQuestionView.h
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

#define kHomeQuestionViewHeight 110

@interface ZHomeQuestionView : ZView

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)();

///问题点击事件
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBoutique *model);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

///从新开始动画
-(void)setAnimateQuestion;

@end
