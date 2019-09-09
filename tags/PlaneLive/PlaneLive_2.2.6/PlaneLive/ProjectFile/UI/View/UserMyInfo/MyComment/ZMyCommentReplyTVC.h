//
//  ZMyCommentReplyTVC.h
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyCommentReplyTVC : ZBaseTVC

///头像点击
@property (copy, nonatomic) void(^onPhotoClick)(ModelQuestionMyAnswerComment *model);
///答案点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelQuestionMyAnswerComment *model);
///评论点击
@property (copy, nonatomic) void(^onCommentClick)(ModelQuestionMyAnswerComment *model);

-(void)setViewBackColorChange;
///数据模型
-(CGFloat)getHWithModel:(ModelQuestionMyAnswerComment *)model;

@end
