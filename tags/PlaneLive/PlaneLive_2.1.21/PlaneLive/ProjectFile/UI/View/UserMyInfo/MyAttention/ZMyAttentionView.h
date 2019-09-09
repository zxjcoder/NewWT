//
//  ZMyAttentionView.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZMyAttentionView : ZView

///问题顶部刷新
@property (copy, nonatomic) void(^onRefreshQuestionHeader)();
///话题顶部刷新
@property (copy, nonatomic) void(^onRefreshTopicHeader)();
///用户顶部刷新
@property (copy, nonatomic) void(^onRefreshUserHeader)();

///问题刷新
@property (copy, nonatomic) void(^onBackgroundQuestionClick)(ZBackgroundState state);
///话题刷新
@property (copy, nonatomic) void(^onBackgroundTopicClick)(ZBackgroundState state);
///用户刷新
@property (copy, nonatomic) void(^onBackgroundUserClick)(ZBackgroundState state);

///问题底部刷新
@property (copy, nonatomic) void(^onRefreshQuestionFooter)();
///话题底部刷新
@property (copy, nonatomic) void(^onRefreshTopicFooter)();
///用户底部刷新
@property (copy, nonatomic) void(^onRefreshUserFooter)();

///问题设置分页数量
@property (copy, nonatomic) void(^onPageNumChangeQuestion)();
///话题设置分页数量
@property (copy, nonatomic) void(^onPageNumChangeTopic)();
///用户设置分页数量
@property (copy, nonatomic) void(^onPageNumChangeUser)();

///问题选中
@property (copy, nonatomic) void(^onQuestionRowClick)(ModelQuestionBase *model);
///头像选中
@property (copy, nonatomic) void(^onPhotoClick)(ModelUserBase *model);
///答案选中
@property (copy, nonatomic) void(^onAnswerRowClick)(ModelAnswerBase *model);
///标签选中
@property (copy, nonatomic) void(^onTagRowClick)(ModelTag *model);
///用户被选中
@property (copy, nonatomic) void(^onUserRowClick)(ModelUserBase *model, NSInteger row);

///删除问题按钮点击
@property (copy, nonatomic) void(^onDeleteQuestionClick)(ModelAttentionQuestion *model);
///删除话题按钮点击
@property (copy, nonatomic) void(^onDeleteTopicClick)(ModelTag *model);
///删除用户按钮点击
@property (copy, nonatomic) void(^onDeleteUserClick)(ModelUserBase *model);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;
///删除用户的行
-(void)setDeleteUserWithRow:(NSInteger)row;

///设置问题背景状态
-(void)setQuestionBackgroundViewWithState:(ZBackgroundState)backState;
///设置话题背景状态
-(void)setTopicBackgroundViewWithState:(ZBackgroundState)backState;
///设置用户背景状态
-(void)setUserBackgroundViewWithState:(ZBackgroundState)backState;

///设置问题
-(void)setViewQuestionWithDictionary:(NSDictionary *)dic;
///设置话题
-(void)setViewTopicWithDictionary:(NSDictionary *)dic;
///设置用户
-(void)setViewUserWithDictionary:(NSDictionary *)dic;

///结束问题顶部刷新
-(void)endRefreshQuestionHeader;
///结束问题底部刷新
-(void)endRefreshQuestionFooter;
///结束话题顶部刷新
-(void)endRefreshTopicHeader;
///结束话题底部刷新
-(void)endRefreshTopicFooter;
///结束用户顶部刷新
-(void)endRefreshUserHeader;
///结束用户底部刷新
-(void)endRefreshUserFooter;

@end
