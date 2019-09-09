//
//  ZMyAttentionView.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZMyAttentionView : ZView

///话题顶部刷新
@property (copy, nonatomic) void(^onRefreshTopicHeader)();
///用户顶部刷新
@property (copy, nonatomic) void(^onRefreshUserHeader)();

///话题刷新
@property (copy, nonatomic) void(^onBackgroundTopicClick)(ZBackgroundState state);
///用户刷新
@property (copy, nonatomic) void(^onBackgroundUserClick)(ZBackgroundState state);

///话题底部刷新
@property (copy, nonatomic) void(^onRefreshTopicFooter)();
///用户底部刷新
@property (copy, nonatomic) void(^onRefreshUserFooter)();

///标签选中
@property (copy, nonatomic) void(^onTagRowClick)(ModelTag *model);
///用户被选中
@property (copy, nonatomic) void(^onUserRowClick)(ModelUserBase *model);

///删除话题按钮点击
@property (copy, nonatomic) void(^onDeleteTopicClick)(ModelTag *model);
///删除用户按钮点击
@property (copy, nonatomic) void(^onDeleteUserClick)(ModelUserBase *model);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置话题背景状态
-(void)setTopicBackgroundViewWithState:(ZBackgroundState)backState;
///设置用户背景状态
-(void)setUserBackgroundViewWithState:(ZBackgroundState)backState;

///设置话题
-(void)setViewTopicWithDictionary:(NSDictionary *)dic;
///设置用户
-(void)setViewUserWithDictionary:(NSDictionary *)dic;

///结束顶部刷新
-(void)endRefreshTopicHeader;
///结束底部刷新
-(void)endRefreshTopicFooter;
///结束顶部刷新
-(void)endRefreshUserHeader;
///结束底部刷新
-(void)endRefreshUserFooter;

@end
