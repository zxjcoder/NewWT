//
//  ZQuestionDetailOperTVC.h
//  PlaneCircle
//
//  Created by Daniel on 8/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZQuestionDetailOperTVC : ZBaseTVC

///邀请回答
@property (copy, nonatomic) void(^onInvitationClick)(ModelQuestionDetail *model);
///添加答案
@property (copy, nonatomic) void(^onAddAnswerClick)(ModelQuestionDetail *model);

@end
