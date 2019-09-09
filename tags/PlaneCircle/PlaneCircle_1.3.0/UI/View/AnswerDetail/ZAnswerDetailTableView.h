//
//  ZAnswerDetailTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZAnswerDetailTableView : ZBaseTableView

///问题标题
@property (copy, nonatomic) void(^onQuestionClick)(ModelAnswerBase *model);

///头像->答案
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelAnswerBase *model);
///头像->评论
@property (copy, nonatomic) void(^onCommentPhotoClick)(ModelUserBase *model);

///评论按钮
@property (copy, nonatomic) void(^onCommentClick)(ModelAnswerComment *model, NSInteger row);
///回复内容
@property (copy, nonatomic) void(^onReplyClick)(ModelCommentReply *model, NSInteger row);

///同意
@property (copy, nonatomic) void(^onAgreeClick)(ModelAnswerBase *model);
///图片点击放大
@property (copy , nonatomic) void(^onImageClick)(UIImage *image, NSURL *imgUrl, NSInteger currentIndex, NSArray *arrImageUrl, CGSize size);

///开始滑动
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

///设置答案数据源
-(void)setViewDataWithCommentArray:(NSArray *)arrComment modelAnswer:(ModelAnswerBase *)modelAnswer modelDefaultComment:(ModelAnswerComment *)modelDefaultComment isHeader:(BOOL)isHeader;
///设置数据集合
-(void)setViewDataWithCommentArray:(NSArray *)arrComment modelAnswer:(ModelAnswerBase *)modelAnswer modelDefaultComment:(ModelAnswerComment *)modelDefaultComment isHeader:(BOOL)isHeader  isScrollToRow:(BOOL)isScrollToRow;
///设置答案数据源
-(void)setViewDataWithModel:(ModelAnswerBase *)model;

///设置答案评论数据源
-(void)setViewDataWithCommentModel:(ModelAnswerComment *)model;

///添加一个新的评论对象
-(void)addViewAnswerComment:(ModelAnswerComment *)model;
///删除一个自己的评论对象
-(void)deleteViewAnswerComment:(ModelAnswerComment *)model;

///添加一个新的回复对象
-(void)addViewCommentReply:(ModelCommentReply *)model;
///删除一个自己回复的对象
-(void)deleteViewCommentReply:(ModelCommentReply *)model;

///指定滑动到某个CELL
-(void)setViewScrollToRowAtRow:(NSInteger)row;

@end


