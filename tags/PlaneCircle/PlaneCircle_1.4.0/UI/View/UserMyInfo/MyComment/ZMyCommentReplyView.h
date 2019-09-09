//
//  ZMyCommentReplyView.h
//  PlaneCircle
//
//  Created by Daniel on 8/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZMyCommentReplyView : ZView

///收到评论顶部刷新
@property (copy, nonatomic) void(^onRefreshCommentHeader)();

///设置收到评论分页数量
@property (copy, nonatomic) void(^onCommentPageNumChange)(int pageNum);

///收到评论刷新
@property (copy, nonatomic) void(^onBackgroundCommentClick)(ZBackgroundState state);

///收到评论底部刷新
@property (copy, nonatomic) void(^onRefreshCommentFooter)();

///我的答案选中
@property (copy, nonatomic) void(^onAnswerRowClick)(ModelAnswerBase *model);
///收到评论选中
@property (copy, nonatomic) void(^onCommentRowClick)(ModelAnswerBase *model, ModelAnswerComment *modelAC);
///收到评论头像选中
@property (copy, nonatomic) void(^onUserInfoClick)(ModelUserBase *model);

///设置收到评论背景状态
-(void)setCommentBackgroundViewWithState:(ZBackgroundState)backState;

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置收到评论
-(void)setViewCommentWithDictionary:(NSDictionary *)dic;

///结束收到评论顶部刷新
-(void)endRefreshCommentHeader;
///结束收到评论底部刷新
-(void)endRefreshCommentFooter;


@end
