//
//  ZMyCommentReplyTableView.h
//  PlaneCircle
//
//  Created by Daniel on 8/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyCommentReplyTableView : ZBaseTableView

///评论区域点击事件
@property (copy, nonatomic) void(^onCommentClick)(ModelAnswerBase *model, ModelAnswerComment *modelAC);

///用户点击事件
@property (copy ,nonatomic) void(^onUserInfoClick)(ModelUserBase *model);

///答案区域点击事件
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
