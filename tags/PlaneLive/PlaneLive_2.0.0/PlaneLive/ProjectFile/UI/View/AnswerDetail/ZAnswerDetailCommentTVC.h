//
//  ZAnswerDetailCommentTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAnswerDetailCommentTVC : ZBaseTVC

///高度改变
@property (copy, nonatomic) void(^onRowHeightChange)(ModelAnswerComment *model, BOOL isCommentDefaultH, BOOL isReplyDefaultH);

///用户点击事件
@property (copy, nonatomic) void(^onUserClick)(ModelUserBase *model);
///回复内容点击事件
@property (copy, nonatomic) void(^onReplyClick)(ModelCommentReply *model, NSInteger row);
///评论内容点击事件
@property (copy, nonatomic) void(^onCommentClick)(ModelAnswerComment *model, NSInteger row);

///设置评论是否默认高度
-(void)setCellIsCommentDefaultH:(BOOL)isDF;
///设置回复是否默认高度
-(void)setCellIsReplyDefaultH:(BOOL)isDF;

///根据数据模型获取CELL高度
-(CGFloat)getHWithModel:(ModelAnswerComment *)model;

@end
