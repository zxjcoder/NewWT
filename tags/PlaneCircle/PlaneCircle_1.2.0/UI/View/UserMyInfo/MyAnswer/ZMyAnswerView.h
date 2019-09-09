//
//  ZMyAnswerView.h
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. Answer rights reserved.
//

#import "ZView.h"

@interface ZMyAnswerView : ZView

///我的答案顶部刷新
@property (copy, nonatomic) void(^onRefreshAnswerHeader)();
///收到评论顶部刷新
@property (copy, nonatomic) void(^onRefreshCommentHeader)();

///设置我的答案分页数量
@property (copy, nonatomic) void(^onAnswerPageNumChange)(int pageNum);
///设置收到评论分页数量
@property (copy, nonatomic) void(^onCommentPageNumChange)(int pageNum);

///我的答案刷新
@property (copy, nonatomic) void(^onBackgroundAnswerClick)(ZBackgroundState state);
///收到评论刷新
@property (copy, nonatomic) void(^onBackgroundCommentClick)(ZBackgroundState state);

///我的答案底部刷新
@property (copy, nonatomic) void(^onRefreshAnswerFooter)();
///收到评论底部刷新
@property (copy, nonatomic) void(^onRefreshCommentFooter)();

///我的答案选中
@property (copy, nonatomic) void(^onAnswerRowClick)(ModelQuestionMyAnswer *model);
///我的答案->问题选中
@property (copy, nonatomic) void(^onQuestionRowClick)(ModelQuestionMyAnswer *model);
///收到评论选中
@property (copy, nonatomic) void(^onCommentRowClick)(ModelQuestionMyAnswerComment *model);
///收到评论头像选中
@property (copy, nonatomic) void(^onPhotoClick)(ModelQuestionMyAnswerComment *model);

///删除我的答案按钮点击
@property (copy, nonatomic) void(^onDeleteAnswerClick)(ModelQuestionMyAnswer *model);
///删除收到评论按钮点击
@property (copy, nonatomic) void(^onDeleteCommentClick)(ModelQuestionMyAnswerComment *model);

///设置我的答案背景状态
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState;
///设置收到评论背景状态
-(void)setCommentBackgroundViewWithState:(ZBackgroundState)backState;

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置收到评论未读数量
-(void)setCommentCount:(int)count;

///设置我的答案
-(void)setViewAnswerWithDictionary:(NSDictionary *)dic;
///设置收到评论
-(void)setViewCommentWithDictionary:(NSDictionary *)dic;

///结束我的答案顶部刷新
-(void)endRefreshAnswerHeader;
///结束我的答案底部刷新
-(void)endRefreshAnswerFooter;
///结束收到评论顶部刷新
-(void)endRefreshCommentHeader;
///结束收到评论底部刷新
-(void)endRefreshCommentFooter;

@end
