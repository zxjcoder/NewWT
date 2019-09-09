//
//  ZQuestionDetailAnswerView.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZQuestionDetailAnswerView : ZView

///邀请回答
@property (copy, nonatomic) void(^onInvitationClick)(ModelQuestionDetail *model);
///添加答案
@property (copy, nonatomic) void(^onAddAnswerClick)(ModelQuestionDetail *model);

///设置数据源
-(void)setViewDataWithModel:(ModelQuestionDetail *)model;

+(CGFloat)getViewH;

@end
