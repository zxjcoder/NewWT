//
//  ZFoundTableView.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZFoundTableView : ZBaseTableView

///登录
@property (copy, nonatomic) void(^onUserLoginClick)();
///实务分类点击
@property (copy, nonatomic) void(^onPracticeTypeClick)(ModelPracticeType *model);

///设置用户信息
-(void)setViewDataWithModel:(ModelUser *)model;
///设置实务分类数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult;

@end
