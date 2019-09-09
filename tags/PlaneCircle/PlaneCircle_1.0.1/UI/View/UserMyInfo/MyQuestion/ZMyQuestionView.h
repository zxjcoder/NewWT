//
//  ZMyQuestionView.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZMyQuestionView : ZView

///所有顶部刷新
@property (copy, nonatomic) void(^onRefreshAllHeader)();
///新答案顶部刷新
@property (copy, nonatomic) void(^onRefreshNewHeader)();

///所有刷新
@property (copy, nonatomic) void(^onBackgroundAllClick)(ZBackgroundState state);
///新答案刷新
@property (copy, nonatomic) void(^onBackgroundNewClick)(ZBackgroundState state);

///所有底部刷新
@property (copy, nonatomic) void(^onRefreshAllFooter)();
///新答案底部刷新
@property (copy, nonatomic) void(^onRefreshNewFooter)();

///所有选中
@property (copy, nonatomic) void(^onAllRowClick)(ModelQuestionDetail *model);
///新答案选中
@property (copy, nonatomic) void(^onNewRowClick)(ModelQuestionDetail *model);

///删除所有按钮点击
@property (copy, nonatomic) void(^onDeleteAllClick)(ModelQuestionDetail *model);
///删除新答案按钮点击
@property (copy, nonatomic) void(^onDeleteNewClick)(ModelQuestionDetail *model);

///设置背景状态
-(void)setAllBackgroundViewWithState:(ZBackgroundState)backState;
///设置背景状态
-(void)setNewBackgroundViewWithState:(ZBackgroundState)backState;

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置所有问题
-(void)setViewAllWithDictionary:(NSDictionary *)dic;
///设置新答案
-(void)setViewNewWithDictionary:(NSDictionary *)dic;

///结束顶部刷新
-(void)endRefreshAllHeader;
///结束底部刷新
-(void)endRefreshAllFooter;
///结束顶部刷新
-(void)endRefreshNewHeader;
///结束底部刷新
-(void)endRefreshNewFooter;

@end
